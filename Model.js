function emptyStatus() {
  return {
    installed: false,
    version: "",
    configured: false,
    oauthClient: false,
    authorized: false,
    daemonActive: false,
    phase: "",
    dryRun: false,
    allowWrites: false,
    allowDeletes: false,
    pending: 0,
    conflicts: 0,
    lastScan: ""
  }
}

function parseStatus(raw) {
  var text = String(raw || "").trim()
  var status = emptyStatus()
  if (text === "") return status
  try {
    var data = JSON.parse(text)
  } catch (e) {
    return status
  }
  if (!data || typeof data !== "object") return status
  status.installed = true
  status.version = String(data.version || "")
  status.configured = data.configured === true
  status.oauthClient = data.oauth_client === true
  status.authorized = data.authorized === true
  status.daemonActive = data.daemon_active === true
  status.phase = String(data.phase || "")
  status.dryRun = data.dry_run === true
  status.allowWrites = data.allow_writes === true
  status.allowDeletes = data.allow_deletes === true
  status.pending = Number(data.pending || 0)
  status.conflicts = Number(data.conflicts || 0)
  status.lastScan = String(data.last_scan || "")
  return status
}

function modeLabel(status) {
  if (!status.installed) return "—"
  var mode = (status.dryRun || !status.allowWrites) ? "dry-run" : "writes"
  if (status.allowDeletes) mode += ", deletes"
  return mode
}
