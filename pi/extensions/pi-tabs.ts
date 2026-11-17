/**
 * Top tabs + /new + /clear + floating /btw for Pi.
 *
 * Tabs are session files. Pi runs one active session per process, so switching
 * a tab replaces the foreground session in this process. Session history stays
 * on disk. (True parallel agents need separate Pi processes / a different UI.)
 *
 * Commands:
 *   /new [name]          new tab and switch to it
 *   /tab                 list / pick a tab
 *   /tab new [name]      alias for /new
 *   /tab close           close current tab (session file is kept)
 *   /tab next | prev     cycle tabs
 *   /tab <n>             jump to tab n
 *   /tab rename [name]   rename current tab (also sets the session name)
 *   /clear               clear this tab (fresh session, same tab slot)
 *   /btw <question>      floating side answer; not added to model context
 *
 * Shortcuts:
 *   alt+1 ... alt+9      switch to tab n
 *   ctrl+tab / ctrl+shift+tab, alt+] / alt+[   next / previous tab
 */

import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, renameSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import { uuidv7 } from "@earendil-works/pi-ai";
import {
	BorderedLoader,
	convertToLlm,
	getMarkdownTheme,
	serializeConversation,
	type ExtensionAPI,
	type ExtensionCommandContext,
	type ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { Markdown, MouseRegion, matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

type Tab = {
	id: string;
	name: string;
	sessionFile: string;
};

type Pending = { kind: "new"; id: string; name: string } | { kind: "replace"; id: string };

type Deck = {
	seq: number;
	activeId: string;
	tabs: Tab[];
	pending?: Pending;
};

type HitRegion = {
	startX: number;
	endX: number;
	kind: "tab" | "new" | "overflow";
	index?: number;
};

let extensionApi: ExtensionAPI | undefined;

type TopBar = {
	update(deck: Deck): void;
	done(): void;
};

let topBar: TopBar | undefined;

const AUTO_NAME = /^tab \d+$/;

function agentDir(): string {
	return process.env.PI_CODING_AGENT_DIR || join(homedir(), ".pi", "agent");
}

function deckFile(sessionDir: string): string {
	const hash = createHash("sha1").update(sessionDir).digest("hex").slice(0, 12);
	return join(agentDir(), "tab-decks", `${hash}.json`);
}

function loadDeck(sessionDir: string): Deck {
	try {
		const raw = JSON.parse(readFileSync(deckFile(sessionDir), "utf8")) as Partial<Deck>;
		const activeId = typeof raw.activeId === "string" ? raw.activeId : "";
		const pendingId = raw.pending?.id;
		const tabs = Array.isArray(raw.tabs)
			? raw.tabs.filter(
					(tab): tab is Tab =>
						!!tab &&
						typeof tab.id === "string" &&
						typeof tab.name === "string" &&
						typeof tab.sessionFile === "string" &&
						(tab.id === activeId || tab.id === pendingId || existsSync(tab.sessionFile)),
				)
			: [];
		return {
			seq: typeof raw.seq === "number" ? raw.seq : tabs.length,
			activeId,
			tabs,
			pending: raw.pending,
		};
	} catch {
		return { seq: 0, activeId: "", tabs: [] };
	}
}

function saveDeck(sessionDir: string, deck: Deck): void {
	const file = deckFile(sessionDir);
	mkdirSync(dirname(file), { recursive: true });
	const tmp = `${file}.${process.pid}.tmp`;
	writeFileSync(tmp, JSON.stringify(deck, null, 2));
	renameSync(tmp, file);
}

function snippet(text: string, max = 24): string {
	const clean = text.replace(/\s+/g, " ").trim();
	return clean.length > max ? `${clean.slice(0, max - 1)}…` : clean;
}

function firstUserText(ctx: any): string | undefined {
	for (const entry of ctx.sessionManager.getEntries()) {
		if (entry.type !== "message" || entry.message.role !== "user") continue;
		const content = entry.message.content;
		if (typeof content === "string") {
			const text = snippet(content);
			if (text) return text;
			continue;
		}
		if (!Array.isArray(content)) continue;
		const text = snippet(
			content
				.filter((part): part is { type: "text"; text: string } => part?.type === "text" && typeof part.text === "string")
				.map((part) => part.text)
				.join(" "),
		);
		if (text) return text;
	}
	return undefined;
}

function namedTab(ctx: any): string | undefined {
	const name = ctx.sessionManager.getSessionName()?.trim();
	if (name) return name;
	return firstUserText(ctx);
}

function fitLine(line: string, width: number): string {
	const truncated = truncateToWidth(line, width);
	return truncated + " ".repeat(Math.max(0, width - visibleWidth(truncated)));
}

function renderTopBarLines(deck: Deck, width: number, theme: any, hitRegions: HitRegion[]): string[] {
	if (width < 24 || deck.tabs.length === 0) return [];

	const activeIndex = Math.max(
		0,
		deck.tabs.findIndex((tab) => tab.id === deck.activeId),
	);

	const rendered = deck.tabs.map((tab, index) => {
		const label = snippet(tab.name, Math.min(20, Math.max(8, Math.floor(width * 0.22))));
		const content = ` ${label} `;
		const styled =
			tab.id === deck.activeId
				? theme.bg("selectedBg", theme.fg("toolTitle", content))
				: theme.fg("dim", content);
		return { index, text: styled, width: visibleWidth(styled) };
	});

	const plus = theme.bg("userMessageBg", theme.fg("accent", " + "));
	const plusWidth = visibleWidth(plus);
	const available = Math.max(0, width - plusWidth - visibleWidth(" "));
	let start = activeIndex;
	let end = activeIndex;
	let used = rendered[activeIndex].width;

	while (start > 0 || end < rendered.length - 1) {
		let grew = false;
		if (start > 0 && used + rendered[start - 1].width <= available) {
			start -= 1;
			used += rendered[start].width;
			grew = true;
		}
		if (end < rendered.length - 1 && used + rendered[end + 1].width <= available) {
			end += 1;
			used += rendered[end].width;
			grew = true;
		}
		if (!grew) break;
	}

	let line = "";
	let x = 0;
	if (start > 0) {
		const overflow = theme.fg("dim", `<${start} `);
		const w = visibleWidth(overflow);
		hitRegions.push({ startX: x, endX: x + w, kind: "overflow" });
		line += overflow;
		x += w;
	}

	for (let index = start; index <= end; index++) {
		const segment = rendered[index];
		hitRegions.push({ startX: x, endX: x + segment.width, kind: "tab", index: segment.index });
		line += segment.text;
		x += segment.width;
	}

	const gap = Math.max(1, width - x - plusWidth);
	line += " ".repeat(gap);
	x += gap;
	hitRegions.push({ startX: x, endX: x + plusWidth, kind: "new" });
	line += plus;

	const hint =
		deck.tabs.length > 1
			? "alt+1…9 switch · ctrl+tab next · click a tab · /new new tab"
			: "click + or /new to open another tab";
	return [fitLine(line, width), fitLine(theme.fg("dim", hint), width)];
}

function mountTopBar(ctx: any): void {
	if (!ctx.hasUI || ctx.mode !== "tui") return;
	topBar?.done();

	// Hide the built-in startup header; the persistent overlay below replaces it.
	ctx.ui.setHeader(() => ({ render: () => [], invalidate() {} }));

	let deckRef: Deck = { seq: 0, activeId: "", tabs: [] };
	let requestRender: (() => void) | undefined;
	let doneFn: (() => void) | undefined;
	let handle: any;
	let disposed = false;
	let entry: TopBar;

	const promise = ctx.ui.custom(
		(tui: any, theme: any, _keybindings: any, done: any) => {
			doneFn = () => done(undefined);
			requestRender = () => tui.requestRender();
			let hitRegions: HitRegion[] = [];

			const inner = {
				handleInput(_data: string) {},
				invalidate() {},
				render(width: number): string[] {
					hitRegions = [];
					return renderTopBarLines(deckRef, width, theme, hitRegions);
				},
			};

			return new MouseRegion(inner, (event: any) => {
				if (event.type !== "click" || event.button !== "left" || event.y !== 0) return undefined;
				const hit = hitRegions.find((region) => event.x >= region.startX && event.x < region.endX);
				if (!hit) return undefined;

				if (!ctx.isIdle()) {
					ctx.ui.notify("Wait for the current turn to finish before switching tabs", "warning");
					return { handled: true };
				}

				if (hit.kind === "new") {
					extensionApi?.sendUserMessage("/new", { expandPromptTemplates: true });
				} else if (hit.kind === "overflow") {
					extensionApi?.sendUserMessage("/tab", { expandPromptTemplates: true });
				} else if (hit.kind === "tab" && hit.index !== undefined) {
					extensionApi?.sendUserMessage(`/tab ${hit.index + 1}`, { expandPromptTemplates: true });
				}
				return { handled: true };
			});
		},
		{
			overlay: true,
			overlayOptions: {
				anchor: "top-left",
				width: "100%",
				maxHeight: 2,
				margin: 0,
				nonCapturing: true,
			},
			onHandle: (h: any) => {
				handle = h;
				h.setHidden(deckRef.tabs.length === 0);
			},
		},
	);

	entry = {
		update: (deck: Deck) => {
			deckRef = deck;
			handle?.setHidden(deck.tabs.length === 0);
			requestRender?.();
		},
		done: () => {
			if (disposed) return;
			disposed = true;
			doneFn?.();
			if (topBar === entry) topBar = undefined;
		},
	};
	topBar = entry;
	void promise.catch(() => {}).finally(() => {
		if (topBar === entry) topBar = undefined;
	});
}

function renderTabs(ctx: any, deck: Deck): void {
	if (!ctx.hasUI || ctx.mode !== "tui") return;

	if (!topBar) mountTopBar(ctx);
	topBar?.update(deck);
}

function currentTab(ctx: ExtensionCommandContext, deck: Deck): Tab | undefined {
	const file = ctx.sessionManager.getSessionFile();
	return deck.tabs.find((tab) => tab.id === deck.activeId) ?? deck.tabs.find((tab) => tab.sessionFile === file);
}

function ensureIdle(ctx: ExtensionCommandContext, action: string): boolean {
	if (ctx.isIdle()) return true;
	ctx.ui.notify(`The current tab is still working. Wait or press Esc before ${action}.`, "warning");
	return false;
}

async function activateTab(ctx: ExtensionCommandContext, target: Tab): Promise<void> {
	const sessionDir = ctx.sessionManager.getSessionDir();
	const deck = loadDeck(sessionDir);
	if (target.id === deck.activeId) return;
	if (!ensureIdle(ctx, "switching tabs")) return;

	if (!existsSync(target.sessionFile)) {
		ctx.ui.notify("That tab has no saved session yet. Send it a message first.", "warning");
		return;
	}

	const previous = deck.activeId;
	deck.activeId = target.id;
	saveDeck(sessionDir, deck);
	renderTabs(ctx, deck);

	try {
		const result = await ctx.switchSession(target.sessionFile);
		if (result.cancelled) {
			const restore = loadDeck(sessionDir);
			restore.activeId = previous;
			saveDeck(sessionDir, restore);
			renderTabs(ctx, restore);
		}
	} catch (error) {
		const restore = loadDeck(sessionDir);
		restore.activeId = previous;
		saveDeck(sessionDir, restore);
		renderTabs(ctx, restore);
		ctx.ui.notify(`Could not switch tab: ${error instanceof Error ? error.message : String(error)}`, "error");
	}
}

async function activateIndex(ctx: ExtensionCommandContext, index: number): Promise<void> {
	const sessionDir = ctx.sessionManager.getSessionDir();
	const deck = loadDeck(sessionDir);
	const target = deck.tabs[index];
	if (!target) {
		ctx.ui.notify(`No tab ${index + 1}`, "warning");
		return;
	}
	await activateTab(ctx, target);
}

async function newTab(ctx: ExtensionCommandContext, name?: string): Promise<void> {
	if (!ensureIdle(ctx, "opening a new tab")) return;
	const sessionDir = ctx.sessionManager.getSessionDir();
	const deck = loadDeck(sessionDir);
	const id = `t${++deck.seq}`;
	deck.pending = {
		kind: "new",
		id,
		name: name?.trim() || `tab ${deck.tabs.length + 1}`,
	};
	saveDeck(sessionDir, deck);

	const result = await ctx.newSession();
	if (result.cancelled) {
		const restore = loadDeck(sessionDir);
		restore.pending = undefined;
		saveDeck(sessionDir, restore);
		renderTabs(ctx, restore);
	}
}

async function closeTab(ctx: ExtensionCommandContext): Promise<void> {
	if (!ensureIdle(ctx, "closing the tab")) return;
	const sessionDir = ctx.sessionManager.getSessionDir();
	const deck = loadDeck(sessionDir);
	const index = deck.tabs.findIndex((tab) => tab.id === deck.activeId);
	const old = deck.tabs[index];

	if (!old) {
		ctx.ui.notify("No active tab", "warning");
		return;
	}
	if (deck.tabs.length === 1) {
		ctx.ui.notify("Last tab — use /clear or /new instead", "warning");
		return;
	}

	const target = deck.tabs[index + 1] ?? deck.tabs[index - 1];
	const previous = deck.activeId;
	deck.activeId = target.id;
	saveDeck(sessionDir, deck);
	renderTabs(ctx, deck);

	try {
		const result = await ctx.switchSession(target.sessionFile, {
			withSession: async (newCtx: any) => {
				const current = loadDeck(sessionDir);
				current.tabs = current.tabs.filter((tab) => tab.id !== old.id);
				current.activeId = target.id;
				saveDeck(sessionDir, current);
				renderTabs(newCtx, current);
			},
		});
		if (result.cancelled) {
			const restore = loadDeck(sessionDir);
			restore.activeId = previous;
			saveDeck(sessionDir, restore);
			renderTabs(ctx, restore);
		}
	} catch (error) {
		const restore = loadDeck(sessionDir);
		restore.activeId = previous;
		saveDeck(sessionDir, restore);
		renderTabs(ctx, restore);
		ctx.ui.notify(`Could not close tab: ${error instanceof Error ? error.message : String(error)}`, "error");
	}
}

async function clearTab(ctx: ExtensionCommandContext): Promise<void> {
	if (!ensureIdle(ctx, "clearing the tab")) return;
	const sessionDir = ctx.sessionManager.getSessionDir();
	const deck = loadDeck(sessionDir);
	const tab = currentTab(ctx, deck);

	if (!tab) {
		await ctx.newSession();
		return;
	}

	deck.pending = { kind: "replace", id: tab.id };
	saveDeck(sessionDir, deck);
	const result = await ctx.newSession();
	if (result.cancelled) {
		const restore = loadDeck(sessionDir);
		restore.pending = undefined;
		saveDeck(sessionDir, restore);
	}
}

async function renameTab(ctx: ExtensionCommandContext, name: string): Promise<void> {
	const sessionDir = ctx.sessionManager.getSessionDir();
	const deck = loadDeck(sessionDir);
	const tab = currentTab(ctx, deck);
	if (!tab) return;

	const nextName = name.trim() || (await ctx.ui.input("Rename tab", tab.name))?.trim();
	if (!nextName) return;

	tab.name = nextName;
	deck.activeId = tab.id;
	saveDeck(sessionDir, deck);
	extensionApi?.setSessionName(nextName);
	renderTabs(ctx, deck);
}

function entryToMessage(entry: any): any | undefined {
	if (entry.type === "message") return entry.message;
	if (entry.type === "compaction") {
		return {
			role: "compactionSummary",
			summary: entry.summary,
			tokensBefore: entry.tokensBefore,
			timestamp: new Date(entry.timestamp).getTime(),
		};
	}
	if (entry.type === "branch_summary") {
		return {
			role: "branchSummary",
			summary: entry.summary,
			fromId: entry.fromId,
			timestamp: new Date(entry.timestamp).getTime(),
		};
	}
	return undefined;
}

function buildBtwPrompt(ctx: ExtensionCommandContext): string {
	const messages = ctx.sessionManager
		.buildContextEntries()
		.map(entryToMessage)
		.filter((message): message is any => message !== undefined);
	return serializeConversation(convertToLlm(messages));
}

const BTW_SYSTEM = [
	"The user is asking a quick side question about the conversation so far.",
	"Answer directly and concisely in markdown from what you already know.",
	"Do not call any tools and do not take any actions.",
].join(" ");

async function showBtwOverlay(ctx: ExtensionCommandContext, question: string, answer: string): Promise<void> {
	await ctx.ui.custom<undefined>(
		(tui: any, theme: any, _keybindings: any, done: (value: undefined) => void) => {
			const markdown = new Markdown(answer, 0, 0, getMarkdownTheme());
			let offset = 0;
			let cachedWidth = -1;
			let lines: string[] = [];

			const rebuild = (width: number) => {
				if (width === cachedWidth) return;
				cachedWidth = width;
				const border = theme.fg("accent", "─".repeat(Math.max(1, width)));
				const title = `${theme.bg("selectedBg", theme.fg("accent", " /btw "))} ${theme.fg("dim", snippet(question, Math.max(8, width - 12)))}`;
				const body = markdown.render(Math.max(1, width - 2)).map((line: string) => fitLine(line, width));
				const footer = theme.fg("dim", "↑/↓ scroll · PgUp/PgDn · Home/End · Esc close");
				lines = [fitLine(border, width), fitLine(title, width), fitLine("", width), ...body, fitLine("", width), fitLine(footer, width), fitLine(border, width)];
			};

			const viewport = () => Math.max(6, Math.floor(tui.terminal.rows * 0.8) - 2);

			const clamp = () => {
				offset = Math.max(0, Math.min(offset, Math.max(0, lines.length - viewport())));
			};

			return {
				render(width: number): string[] {
					rebuild(width);
					clamp();
					return lines.slice(offset, offset + viewport());
				},
				handleInput(data: string): void {
					if (matchesKey(data, "escape") || matchesKey(data, "enter") || data === "q") {
						done(undefined);
						return;
					}

					let changed = true;
					if (matchesKey(data, "up") || data === "k") offset -= 1;
					else if (matchesKey(data, "down") || data === "j") offset += 1;
					else if (matchesKey(data, "pageUp")) offset -= viewport();
					else if (matchesKey(data, "pageDown")) offset += viewport();
					else if (matchesKey(data, "home")) offset = 0;
					else if (matchesKey(data, "end")) offset = lines.length;
					else changed = false;

					if (changed) {
						clamp();
						tui.requestRender();
					}
				},
				invalidate() {
					cachedWidth = -1;
					markdown.invalidate();
				},
			};
		},
		{
			overlay: true,
			overlayOptions: { anchor: "center", width: "88%", maxHeight: "80%", margin: 2 },
		},
	);
}

async function askBtw(ctx: ExtensionCommandContext, question: string): Promise<void> {
	if (!ctx.hasUI || ctx.mode !== "tui") {
		ctx.ui.notify("/btw needs interactive mode", "error");
		return;
	}
	if (!ctx.model) {
		ctx.ui.notify("No model selected", "error");
		return;
	}

	const conversation = buildBtwPrompt(ctx);
	if (!conversation.trim()) {
		ctx.ui.notify("No conversation yet", "warning");
		return;
	}

	const prompt = ["<conversation>", conversation, "</conversation>", "", `Question: ${question}`].join("\n");

	const answer = await ctx.ui.custom<string | null>((tui, theme, _keybindings, done) => {
		const loader = new BorderedLoader(tui, theme, `Asking ${ctx.model!.id}…`);
		loader.onAbort = () => done(null);

		ctx.modelRegistry
			.complete(
				ctx.model!,
				{
					systemPrompt: BTW_SYSTEM,
					messages: [
						{
							role: "user",
							content: [{ type: "text", text: prompt }],
							timestamp: Date.now(),
						},
					],
				},
				{ signal: loader.signal, cacheRetention: "none", sessionId: uuidv7() },
			)
			.then((response) => {
				if (response.stopReason === "aborted") {
					done(null);
					return;
				}
				const text = response.content
					.filter((part): part is { type: "text"; text: string } => part.type === "text")
					.map((part) => part.text)
					.join("\n")
					.trim();
				done(text || "No answer returned.");
			})
			.catch((error: unknown) => {
				done(`/btw failed: ${error instanceof Error ? error.message : String(error)}`);
			});

		return loader;
	});

	if (!answer) return;
	await showBtwOverlay(ctx, question, answer);
}

export default function (pi: ExtensionAPI) {
	extensionApi = pi;

	pi.on("session_shutdown", () => {
		topBar?.done();
	});

	pi.on("session_start", (_event, ctx) => {
		if (!ctx.hasUI || ctx.mode !== "tui") return;

		const file = ctx.sessionManager.getSessionFile();
		if (!file) {
			topBar?.done();
			ctx.ui.setHeader(undefined);
			return;
		}

		mountTopBar(ctx);

		const sessionDir = ctx.sessionManager.getSessionDir();
		const deck = loadDeck(sessionDir);
		let tab = deck.tabs.find((item) => item.sessionFile === file);

		if (!tab && deck.pending?.kind === "replace") {
			const target = deck.tabs.find((item) => item.id === deck.pending!.id);
			if (target) {
				target.sessionFile = file;
				tab = target;
			}
			deck.pending = undefined;
		}

		if (!tab && deck.pending?.kind === "new") {
			// Drop tabs that never got a message (Pi saves session files lazily).
			deck.tabs = deck.tabs.filter((item) => existsSync(item.sessionFile));
			tab = {
				id: deck.pending.id,
				name: deck.pending.name || namedTab(ctx) || `tab ${deck.tabs.length + 1}`,
				sessionFile: file,
			};
			deck.tabs.push(tab);
			deck.pending = undefined;
		}

		if (!tab) {
			deck.tabs = deck.tabs.filter((item) => existsSync(item.sessionFile));
			tab = {
				id: `t${++deck.seq}`,
				name: namedTab(ctx) || `tab ${deck.tabs.length + 1}`,
				sessionFile: file,
			};
			deck.tabs.push(tab);
		}

		const sessionName = ctx.sessionManager.getSessionName()?.trim();
		if (sessionName && tab.name !== sessionName) {
			tab.name = sessionName;
		} else if (!sessionName && AUTO_NAME.test(tab.name)) {
			const text = firstUserText(ctx);
			if (text) tab.name = text;
		}

		deck.activeId = tab.id;
		saveDeck(sessionDir, deck);
		renderTabs(ctx, deck);
	});

	pi.on("session_info_changed", (event, ctx) => {
		if (!ctx.hasUI || ctx.mode !== "tui") return;
		const file = ctx.sessionManager.getSessionFile();
		if (!file) return;

		const sessionDir = ctx.sessionManager.getSessionDir();
		const deck = loadDeck(sessionDir);
		const tab = deck.tabs.find((item) => item.sessionFile === file);
		if (!tab) return;

		tab.name = event.name?.trim() || firstUserText(ctx) || tab.name;
		saveDeck(sessionDir, deck);
		renderTabs(ctx, deck);
	});

	pi.on("input", (event, ctx) => {
		if (event.source !== "interactive" || !ctx.hasUI || ctx.mode !== "tui") return;
		const file = ctx.sessionManager.getSessionFile();
		if (!file) return;

		const sessionDir = ctx.sessionManager.getSessionDir();
		const deck = loadDeck(sessionDir);
		const tab = deck.tabs.find((item) => item.sessionFile === file);
		if (!tab || !AUTO_NAME.test(tab.name)) return;

		const text = snippet(event.text);
		if (!text) return;
		tab.name = text;
		saveDeck(sessionDir, deck);
		renderTabs(ctx, deck);
	});

	pi.registerCommand("new", {
		description: "New tab/session (optional name)",
		handler: async (args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/new requires interactive mode", "error");
				return;
			}
			await newTab(ctx, args.trim() || undefined);
		},
	});

	pi.registerCommand("tab", {
		description: "Tabs: list | new [name] | close | next | prev | <n> | rename [name]",
		getArgumentCompletions: (prefix) => {
			const items = ["list", "new", "close", "next", "prev", "rename"].map((value) => ({
				value,
				label: value,
			}));
			const filtered = items.filter((item) => item.value.startsWith(prefix.trim()));
			return filtered.length > 0 ? filtered : null;
		},
		handler: async (args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/tab requires interactive mode", "error");
				return;
			}

			const parts = args.trim() ? args.trim().split(/\s+/) : [];
			const command = parts[0] ?? "list";
			const value = parts.slice(1).join(" ").trim();
			const sessionDir = ctx.sessionManager.getSessionDir();
			const deck = loadDeck(sessionDir);

			switch (command.toLowerCase()) {
				case "list": {
					if (deck.tabs.length === 0) {
						ctx.ui.notify("No tabs", "info");
						return;
					}
					const labels = deck.tabs.map(
						(tab, index) => `${index + 1}. ${tab.name}${tab.id === deck.activeId ? " *" : ""}`,
					);
					const choice = await ctx.ui.select("Switch tab", labels);
					if (!choice) return;
					const index = labels.indexOf(choice);
					if (index >= 0) await activateTab(ctx, deck.tabs[index]);
					return;
				}
				case "new":
					await newTab(ctx, value || undefined);
					return;
				case "close":
					await closeTab(ctx);
					return;
				case "next":
				case "prev": {
					if (deck.tabs.length < 2) return;
					const current = deck.tabs.findIndex((tab) => tab.id === deck.activeId);
					const step = command.toLowerCase() === "next" ? 1 : -1;
					const target = deck.tabs[(current + step + deck.tabs.length) % deck.tabs.length];
					await activateTab(ctx, target);
					return;
				}
				case "rename":
					await renameTab(ctx, value);
					return;
				default: {
					const index = Number(command);
					if (Number.isInteger(index) && index > 0) {
						await activateIndex(ctx, index - 1);
						return;
					}
					ctx.ui.notify("Usage: /tab [list|new [name]|close|next|prev|<n>|rename [name]]", "info");
				}
			}
		},
	});

	pi.registerCommand("clear", {
		description: "Clear this tab and start a fresh session (old session stays on disk)",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/clear requires interactive mode", "error");
				return;
			}
			await clearTab(ctx);
		},
	});

	pi.registerCommand("btw", {
		description: "Ask a floating side question about the conversation (not added to context)",
		handler: async (args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/btw requires interactive mode", "error");
				return;
			}
			let question = args.trim();
			if (!question) {
				question = (await ctx.ui.input("/btw", "Ask about the conversation…"))?.trim() ?? "";
			}
			if (!question) return;
			await askBtw(ctx, question);
		},
	});

	const switchShortcut = (command: string) => async (ctx: ExtensionContext) => {
		if (ctx.mode !== "tui") return;
		if (!ctx.isIdle()) {
			ctx.ui.notify("Wait for the current turn to finish before switching tabs", "warning");
			return;
		}
		extensionApi?.sendUserMessage(command, { expandPromptTemplates: true });
	};

	const altKeys = ["alt+1", "alt+2", "alt+3", "alt+4", "alt+5", "alt+6", "alt+7", "alt+8", "alt+9"] as const;
	for (const [index, shortcut] of altKeys.entries()) {
		pi.registerShortcut(shortcut, {
			description: `Switch to tab ${index + 1}`,
			handler: switchShortcut(`/tab ${index + 1}`),
		});
	}

	pi.registerShortcut("ctrl+tab", { description: "Next tab", handler: switchShortcut("/tab next") });
	pi.registerShortcut("ctrl+shift+tab", { description: "Previous tab", handler: switchShortcut("/tab prev") });
	pi.registerShortcut("alt+]", { description: "Next tab", handler: switchShortcut("/tab next") });
	pi.registerShortcut("alt+[", { description: "Previous tab", handler: switchShortcut("/tab prev") });
}
