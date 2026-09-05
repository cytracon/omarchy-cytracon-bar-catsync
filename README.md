# Catsync — Omarchy plugin

**What it is.** [Catsync](https://github.com/cytracon/catsync) keeps a local folder in sync with Google Drive on Omarchy: uploads, downloads, moves, and trash (not permanent delete). It runs as a user daemon, with an optional tray.

This listing is a **Quickshell bar plugin**. It does **not** ship the daemon and does **not** contain OAuth credentials. The **CS** button shows whether the daemon is idle or syncing and how many actions are pending; right-click opens settings. Install the app with `omarchy install catsync`.

Layout follows the official Omarchy plugin template: `manifest.json`, `BarWidget.qml`, `Panel.qml`, `Model.js`.

## Install

```sh
omarchy plugin add https://github.com/cytracon/omarchy-catsync.git --enable
```

The widget lands in the right bar section.

```sh
omarchy bar move io.github.cytracon.catsync --section right
```

## Usage

Click **CS** to open or close the panel. Escape closes it. Right-click opens settings. In the panel: **O** settings, **S** source.

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
- Optional: Catsync at `$HOME/.local/bin/catsyncd` and `$HOME/.local/bin/catsync-tray`.
- `omarchy-launch-browser` for the source link (ships with Omarchy).

## Security

- No install hooks, daemons, privilege escalation, or network clients
- No OAuth client, token, sync root, or file paths in this repository
- Left-click only toggles the panel
- Right-click runs the fixed path `$HOME/.local/bin/catsync-tray --settings` when that file exists
- “Source” opens `https://github.com/cytracon/catsync` via `omarchy-launch-browser`

Omarchy plugins run unsandboxed. Review `BarWidget.qml`, `Panel.qml`, and `Model.js` before enabling.

## License

MIT for this plugin. Catsync remains MIT.
