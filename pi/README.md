# Pi Coding Agent

Configuración personal de [Pi](https://pi.dev) versionada en este repositorio.

## Contenido

- `settings.json`: proveedor, modelo y nivel de thinking por defecto.
- `extensions/pi-tabs.ts`: tabs superiores persistentes y clickeables, `/new`, `/clear` y `/btw` flotante.
- `extensions/subagent/`: extensión oficial de subagentes (single, parallel y chain).
- `extensions/response-stats.ts`: al final de cada respuesta muestra tiempo, tokens/s y tokens usados.
- `agents/`: definiciones de `scout`, `planner`, `reviewer` y `worker`.
- `prompts/`: workflows `/implement`, `/scout-and-plan` e `/implement-and-review`.

## Instalación

`install.sh` enlaza o copia estos archivos a `~/.pi/agent`:

- `settings.json`
- `extensions/`
- `agents/`
- `prompts/`

Las credenciales se configuran aparte con `/login` dentro de Pi. No se versionan.

## Archivos que no se versionan

- `auth.json` (credenciales)
- `sessions/` (historial de conversaciones)
- `tab-decks/` (estado de las tabs)
- `models-store.json` (caché del catálogo de modelos)
