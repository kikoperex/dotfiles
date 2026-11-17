/**
 * Response metrics: elapsed time, output tokens/s, and token usage.
 *
 * Appends a small TUI-only entry after each completed agent response:
 *   ⏱ 12.3s · 45.6 tok/s · 1.2k in / 567 out / 1.8k total
 *
 * The values cover the whole run: from the user prompt until the agent settles,
 * including tool calls. The entry is not sent to the model.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

type ResponseStats = {
	elapsedMs: number;
	input: number;
	output: number;
	cacheRead: number;
	cacheWrite: number;
	total: number;
	cost: number;
	stopReason?: string;
	aborted?: boolean;
	errorMessage?: string;
};

type UsageTotals = Omit<ResponseStats, "elapsedMs" | "aborted" | "stopReason" | "errorMessage">;

let runStartedAt: number | undefined;
let usage: UsageTotals = emptyUsage();
let hasAssistant = false;
let lastStopReason: string | undefined;
let lastError: string | undefined;

function emptyUsage(): UsageTotals {
	return { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0, cost: 0 };
}

function resetRun(): void {
	runStartedAt = undefined;
	usage = emptyUsage();
	hasAssistant = false;
	lastStopReason = undefined;
	lastError = undefined;
}

function addUsage(target: UsageTotals, source: any): void {
	if (!source) return;
	const input = Number(source.input) || 0;
	const output = Number(source.output) || 0;
	const cacheRead = Number(source.cacheRead) || 0;
	const cacheWrite = Number(source.cacheWrite) || 0;
	const total = Number(source.totalTokens) || input + output + cacheRead + cacheWrite;
	const cost = Number(source.cost?.total) || 0;

	target.input += input;
	target.output += output;
	target.cacheRead += cacheRead;
	target.cacheWrite += cacheWrite;
	target.total += total;
	target.cost += cost;
}

function formatTokens(value: number): string {
	if (!Number.isFinite(value) || value <= 0) return "0";
	if (value < 1000) return String(Math.round(value));
	if (value < 10000) return `${(value / 1000).toFixed(1)}k`;
	if (value < 1000000) return `${Math.round(value / 1000)}k`;
	return `${(value / 1000000).toFixed(1)}M`;
}

function formatDuration(ms: number): string {
	if (!Number.isFinite(ms) || ms < 0) return "?";
	if (ms < 1000) return `${Math.round(ms)}ms`;
	const seconds = ms / 1000;
	if (seconds < 60) return `${seconds.toFixed(1)}s`;
	const minutes = Math.floor(seconds / 60);
	const rest = Math.floor(seconds % 60);
	return `${minutes}m ${String(rest).padStart(2, "0")}s`;
}

function statsLine(stats: ResponseStats): string {
	const elapsedSec = stats.elapsedMs / 1000;
	const tps = elapsedSec > 0 ? stats.output / elapsedSec : 0;
	const status = stats.aborted ? " · aborted" : stats.stopReason === "error" ? " · error" : "";
	const parts = [
		`⏱ ${formatDuration(stats.elapsedMs)}`,
		`${tps.toFixed(1)} out tok/s`,
		`${formatTokens(stats.input)} in / ${formatTokens(stats.output)} out / ${formatTokens(stats.total)} total`,
	];
	if (stats.cacheRead > 0 || stats.cacheWrite > 0) {
		parts.push(`${formatTokens(stats.cacheRead)} cache read`);
	}
	if (stats.cost > 0) {
		parts.push(`$${stats.cost.toFixed(4)}`);
	}
	return `${parts.join(" · ")}${status}`;
}

export default function (pi: ExtensionAPI) {
	pi.registerEntryRenderer<ResponseStats>("response-stats", (entry, _options, theme) => {
		const data = entry.data ?? {
			elapsedMs: 0,
			input: 0,
			output: 0,
			cacheRead: 0,
			cacheWrite: 0,
			total: 0,
			cost: 0,
		};
		return new Text(theme.fg("dim", `  ${statsLine(data)}`), 0, 0);
	});

	pi.on("input", (event, _ctx) => {
		if (event.source !== "interactive" && event.source !== "rpc") return;
		if (runStartedAt === undefined) {
			runStartedAt = Date.now();
			usage = emptyUsage();
			hasAssistant = false;
			lastStopReason = undefined;
			lastError = undefined;
		}
	});

	pi.on("message_end", (event, _ctx) => {
		const message: any = event.message;
		if (message?.role !== "assistant") return;
		hasAssistant = true;
		lastStopReason = message.stopReason;
		lastError = message.errorMessage;
		addUsage(usage, message.usage);
	});

	pi.on("agent_settled", (event, ctx) => {
		if (!ctx.hasUI || ctx.mode !== "tui") {
			resetRun();
			return;
		}
		if (runStartedAt === undefined || !hasAssistant) {
			resetRun();
			return;
		}

		const stats: ResponseStats = {
			...usage,
			elapsedMs: Math.max(0, Date.now() - runStartedAt),
			stopReason: lastStopReason,
			aborted: event.aborted,
			errorMessage: lastError,
		};

		resetRun();
		pi.appendEntry<ResponseStats>("response-stats", stats);
	});
}
