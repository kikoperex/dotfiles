# Nota: volver a `hyprland/workspaces` cuando salga Waybar 0.16

Fecha: 2026-11-03

## Situación

Ahora mismo se usa `ext/workspaces` para conservar los clics en los
números de workspace.

El módulo `hyprland/workspaces` sí resalta en rojo el workspace urgente
(cuando se abre un enlace desde otra terminal/workspace), pero en Waybar
0.15.0 **no funcionan los clics**: usa el protocolo de dispatch antiguo de
Hyprland (`dispatch workspace N`) y Hyprland 0.54+ lo cambió a Lua
(`hl.dsp.focus({ workspace = N })`).

El arreglo está en Waybar desde el commit `e17c0d9f` (29 abr 2026) y
debería llegar en la versión **0.16.0**.

## Qué hacer cuando Arch actualice a Waybar >= 0.16.0

Comprobar la versión:

```sh
pacman -Q waybar
waybar --version
```

Si ya es 0.16.0 o superior, en `waybar/config` y `waybar/config.sin-iconos`
cambiar:

```json
"modules-left": ["ext/workspaces"],
```

por:

```json
"modules-left": ["hyprland/workspaces"],
```

y sustituir el bloque:

```json
"ext/workspaces": {
    "format": "{name}",
    "on-click": "activate",
    "all-outputs": true,
    "active-only": false,
    "ignore-hidden": true,
    "sort-by-name": true
},
```

por:

```json
"hyprland/workspaces": {
    "all-outputs": true,
    "format": "{id}",
    "active-only": false,
    "show-special": false
},
```

`focus_on_activate = false` en `hypr/hyprland.lua` ya está puesto y no hay
que tocarlo.

Después, recargar Waybar:

```sh
killall -SIGUSR2 waybar
```

## Cómo comprobarlo

Abrir un enlace desde una terminal mientras el navegador está en otro
workspace: debe ponerse en rojo el workspace del navegador, sin cambiar de
workspace, y los clics en los números deben seguir funcionando.
