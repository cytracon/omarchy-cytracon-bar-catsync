import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

Panel {
  id: root
  moduleName: "io.github.cytracon.catsync"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null

  readonly property string sourceUrl: "https://github.com/cytracon/catsync"
  readonly property string appBin: Quickshell.env("HOME") + "/.local/bin/catsyncd"
  readonly property string trayBin: Quickshell.env("HOME") + "/.local/bin/catsync-tray"
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property color dim: Qt.darker(foreground, 1.55)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  property bool installed: false
  property bool configured: false
  property bool daemonActive: false
  property string liveVersion: ""
  property string phaseLabel: "—"
  property string modeLabel: "—"
  property string pendingLabel: "—"
  property string conflictLabel: "—"
  property int actionIndex: 0
  property bool cursorActive: false

  function open() {
    cursorActive = false
    actionIndex = 0
    refresh()
    root.controller.show()
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.controller.hide()
  }

  function toggle() {
    if (root.opened) root.close()
    else root.open()
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
  }

  function refresh() {
    statusProc.running = false
    statusProc.running = true
  }

  function applyStatus(raw) {
    var status = Model.parseStatus(raw)
    root.installed = status.installed
    root.configured = status.configured
    root.daemonActive = status.daemonActive
    root.liveVersion = status.version
    root.phaseLabel = status.installed ? (status.phase || "—") : "—"
    root.modeLabel = Model.modeLabel(status)
    root.pendingLabel = status.installed ? String(status.pending) : "—"
    root.conflictLabel = status.installed ? String(status.conflicts) : "—"
  }

  function launchApp() {
    if (!root.installed) {
      installApp()
      return
    }
    Quickshell.execDetached([root.trayBin, "--settings"])
    root.close()
  }

  function installApp() {
    Quickshell.execDetached([
      "omarchy-launch-floating-terminal-with-presentation",
      "omarchy", "install", "catsync"
    ])
    root.close()
  }

  function toggleDaemon() {
    if (!root.installed) return
    var action = root.daemonActive ? "stop" : "start"
    Quickshell.execDetached(["systemctl", "--user", action, "catsyncd.service"])
    Qt.callLater(root.refresh)
  }

  function openSource() {
    Quickshell.execDetached(["omarchy-launch-browser", root.sourceUrl])
    root.close()
  }

  function activateCursor() {
    if (!root.installed) {
      if (actionIndex === 0) installApp()
      else openSource()
      return
    }
    if (actionIndex === 0) launchApp()
    else if (actionIndex === 1) toggleDaemon()
    else openSource()
  }

  Process {
    id: statusProc
    command: [root.appBin, "--status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.applyStatus(text)
    }
    onExited: function(code) {
      if (code !== 0) {
        root.installed = false
        root.liveVersion = ""
      }
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(420))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onMoveRequested: function(dx, dy) {
        root.cursorActive = true
        var max = root.installed ? 2 : 1
        if (dy > 0) root.actionIndex = Math.min(max, root.actionIndex + 1)
        else if (dy < 0) root.actionIndex = Math.max(0, root.actionIndex - 1)
      }
      onActivateRequested: root.activateCursor()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      onTextKey: function(t) {
        if (t === "o" || t === "O") root.launchApp()
        else if (t === "d" || t === "D") root.toggleDaemon()
        else if (t === "i" || t === "I") root.installApp()
        else if (t === "s" || t === "S") root.openSource()
      }

      Column {
        id: column
        width: parent.width
        spacing: Style.space(12)

        PanelHero {
          width: parent.width
          title: "Catsync"
          meta: root.installed ? (root.liveVersion || "0.5.0") : "Not installed in ~/.local"
          foreground: root.foreground
          fontFamily: root.fontFamily
        }

        Column {
          width: parent.width
          spacing: Style.spacing.labelGap
          InfoPair { label: "Configured"; value: root.installed ? (root.configured ? "yes" : "no") : "—" }
          InfoPair { label: "Daemon"; value: root.phaseLabel }
          InfoPair { label: "Mode"; value: root.modeLabel }
          InfoPair { label: "Pending"; value: root.pendingLabel }
          InfoPair { label: "Conflicts"; value: root.conflictLabel }
        }

        PanelSeparator { foreground: root.foreground }

        ActionRow {
          width: parent.width
          title: root.installed ? "Open settings" : "Install Catsync"
          hint: root.installed ? "Right-click the bar icon, or press O" : "Installs the daemon + tray. Press I"
          selected: root.cursorActive && root.actionIndex === 0
          enabled: true
          onClicked: root.launchApp()
        }

        ActionRow {
          width: parent.width
          visible: root.installed
          title: root.daemonActive ? "Stop daemon" : "Start daemon"
          hint: "systemctl --user catsyncd.service, press D"
          selected: root.cursorActive && root.actionIndex === 1
          enabled: root.installed
          onClicked: root.toggleDaemon()
        }

        ActionRow {
          width: parent.width
          title: "Source"
          hint: "github.com/cytracon/catsync"
          selected: root.cursorActive && root.actionIndex === (root.installed ? 2 : 1)
          enabled: true
          onClicked: root.openSource()
        }
      }
    }
  }

  component InfoPair: Row {
    property string label: ""
    property string value: ""
    width: parent.width
    spacing: Style.space(8)
    Text {
      textFormat: Text.PlainText
      text: label
      color: root.foreground
      opacity: 0.6
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
    }
    Item {
      width: Math.max(0, parent.width - parent.children[0].implicitWidth - parent.children[2].implicitWidth - parent.spacing * 2)
      height: 1
    }
    Text {
      textFormat: Text.PlainText
      text: value
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      elide: Text.ElideRight
    }
  }

  component ActionRow: CursorSurface {
    id: action
    property string title: ""
    property string hint: ""
    property bool selected: false
    property bool enabled: true
    signal clicked()

    hasCursor: selected
    foreground: root.foreground
    implicitHeight: actionColumn.implicitHeight + Style.spacing.rowPaddingX
    opacity: enabled ? 1 : 0.55

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      enabled: action.enabled
      cursorShape: action.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
      onClicked: action.clicked()
    }

    Column {
      id: actionColumn
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: Style.space(10)
      anchors.rightMargin: Style.space(10)
      spacing: Style.space(2)
      Text {
        textFormat: Text.PlainText
        width: parent.width
        text: action.title
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.body
      }
      Text {
        textFormat: Text.PlainText
        width: parent.width
        text: action.hint
        color: root.dim
        font.family: root.fontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
      }
    }
  }
}
