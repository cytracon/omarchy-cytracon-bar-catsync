# Marketplace submission

Submit at:
https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=submit-plugin.yml

Title:

```
[Plugin]: Catsync
```

Body (keep headings and checklist exactly):

```
### Repository URL

https://github.com/cytracon/omarchy-cytracon-bar-catsync

### Category

System

### Tags

Bar, System, Quickshell

### Suggest a missing tag

drive

### Maintainer notes

What it is: Catsync keeps a local folder in sync with Google Drive (daemon + tray). This plugin shows status, opens settings, and installs Catsync with `omarchy install catsync` if it is missing. No OAuth secrets in the plugin. Start/stop of the daemon stays in the Catsync tray.

Plugin ID: `io.github.cytracon.catsync`.

This is an Omarchy Quattro bar-widget (Quickshell) for Catsync 0.5.0 on Omarchy/Arch. It does not ship the GTK tray/daemon and does not run installers. `omarchy plugin add` only clones this repo. Catsync itself is installed separately with `omarchy install catsync` (user-local `~/.local`).

The panel reads `$HOME/.local/bin/catsyncd --status` (no secrets or paths) and can launch `$HOME/.local/bin/catsync-tray --settings`. Source opens https://github.com/cytracon/omarchy-cytracon-catsync via `omarchy-launch-browser`. No OAuth credentials in this repository. MIT license. `omarchy plugin validate` passed locally.

Layout matches the official Omarchy plugin template: `BarWidget.qml` + `Panel.qml` + `Model.js`.

### Submission checklist

- [x] The repository is public and contains installation and removal instructions.
- [x] I have documented the plugin license and any external dependencies.
- [x] I confirm that I own or have permission to submit this plugin and its preview assets.
- [x] The plugin does not overwrite user configuration without explicit consent.
- [x] I understand that approval is for listing and is not a security review.
```
