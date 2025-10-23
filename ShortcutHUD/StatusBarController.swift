import AppKit

final class StatusBarController {

    // MARK: - コールバック
    var onToggle: ((Bool) -> Void)?
    var onQuit: (() -> Void)?

    
    // MARK: - 内部状態
    private var statusItem: NSStatusItem!
    private var captureEnabled: Bool

    // MARK: - 初期化
    init(initiallyEnable:Bool) {
        
        self.captureEnabled = initiallyEnable
        // ✅ メニューバー右上にアイコンを作成
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
//          メニューバーアイコン設定（システムシンボル）
            button.image = NSImage(systemSymbolName: "command", accessibilityDescription: nil)
            button.image?.isTemplate = true // ダーク/ライト対応
            print("✅ NSStatusItem ボタン設定完了")

        }
        constructMenu()
    }

    // MARK: - メニュー構築
    private func constructMenu() {
        let menu = NSMenu()

        let toggleItem = NSMenuItem(
            title: captureEnabled ? "HUDキャプチャ停止" : "HUDキャプチャ開始",
            action: #selector(toggleCapture),
            keyEquivalent: "t"
            )
        toggleItem.target = self
        menu.addItem(toggleItem)
        //区切り線
        menu.addItem(NSMenuItem.separator())
        
        //終了
        let quitItem = NSMenuItem(
            title: "終了 ShortcutHUD",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        print("📎 メニュー構築完了: captureEnabled =", captureEnabled)

    }

    // MARK: - メニュー操作
    @objc private func toggleCapture() {
        captureEnabled.toggle()//オンオフ切り替え
        print(captureEnabled ? "🎬 キャプチャ開始" : "⏸ キャプチャ停止")
        if let appDelegate = NSApp.delegate as? AppDelegate {
            if captureEnabled {
                appDelegate.startHUDCapture()
            } else {
                appDelegate.stopHUDCapture()
            }
        }
        constructMenu()
    }

    @objc private func quitApp() {
        onQuit?()
        NSApp.terminate(nil)
    }
}
