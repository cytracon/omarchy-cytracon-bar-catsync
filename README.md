# Catsync — Omarchy plugin

**What it is.** [Catsync](https://github.com/cytracon/omarchy-cytracon-catsync) keeps a local folder in sync with Google Drive on Omarchy: uploads, downloads, moves, and trash (not permanent delete). It runs as a user daemon, with an optional tray.

This plugin is the bar UI for that daemon: live phase/pending counts and settings. If Catsync is not installed yet, the panel runs `omarchy install catsync` (daemon + this plugin). Start/stop of the daemon stays in the Catsync tray. OAuth stays in `~/.config/catsyncd/` on the machine.

Layout follows the official Omarchy plugin template: `manifest.json`, `BarWidget.qml`, `Panel.qml`, `Model.js`.

## Install

One command installs the **daemon and this plugin**:

```bash
omarchy install catsync
```

Or add the widget first, then click **Install Catsync** in the panel (same installer):

```sh
omarchy plugin add https://github.com/cytracon/omarchy-cytracon-bar-catsync.git --enable
```

```sh
omarchy bar move io.github.cytracon.catsync --section right
```

## Usage

Click **CS** to open or close the panel. Escape closes it. Right-click opens settings (or installs if missing). In the panel: **I** install, **O** settings, **S** source. Daemon start/stop is in the Catsync tray, not this plugin.

## Remove

```sh
omarchy plugin remove io.github.cytracon.catsync
```

Removal deletes only the plugin checkout. It does **not** uninstall Catsync or touch `~/.config/catsyncd/`.

## Install Catsync (the app)

User-local. On Omarchy:

```bash
omarchy install catsync
```

That writes `~/.local/bin/catsyncd`. OAuth client, token, and sync config stay in `~/.config/catsyncd/` on the machine. They are not part of this plugin.

## External dependencies

- Omarchy Quattro shell (Quickshell). No extra QML modules.
- Catsync at `$HOME/.local/bin/catsyncd` (installed by the panel or by `omarchy install catsync`).
- `omarchy-launch-floating-terminal-with-presentation` and `omarchy-launch-browser` (ship with Omarchy).

## Security

- No OAuth client, token, sync root, or file paths in this repository
- Left-click toggles the panel
- Right-click opens `$HOME/.local/bin/catsync-tray --settings`, or installs Catsync if missing
- Install runs `omarchy install catsync` in a floating terminal
- “Source” opens `https://github.com/cytracon/omarchy-cytracon-catsync` via `omarchy-launch-browser`
- This plugin does not start or stop the daemon; that stays in the Catsync tray

Omarchy plugins run unsandboxed. Review `BarWidget.qml`, `Panel.qml`, and `Model.js` before enabling.

## License

MIT for this plugin. Catsync remains MIT.
