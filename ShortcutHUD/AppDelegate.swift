//
//  Untitled 2.swift
//  ShortcutHUD
//
//  Created by Kenichi on R 7/10/22.
//
import Cocoa

extension AppDelegate {
    func stopHUDCapture() {
        print("⏸ AppDelegate: HUDキャプチャ停止")
        keyCapture.stop()
    }

    func startHUDCapture() {
        print("🎬 AppDelegate: HUDキャプチャ開始")
        keyCapture.start()
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusBar: StatusBarController?
    private let hudController = HUDController.shared
    private let keyCapture = KeyCapture.shared

    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // ✅ Dock表示モード
        NSApp.setActivationPolicy(.regular)
        
        //メインメニューをセットアップ
        setupMainMenu()
        
        // ✅ キーキャプチャ開始
        startCapture()
        // ✅ UIスレッド上でStatusBarを初期化（確実に描画）
        DispatchQueue.main.async {
            self.initializeStatusBar()
        }


        print("🚀 ShortcutHUD 起動完了")
    }
    private func setupMainMenu() {
        // ✅ アプリケーションメニュー作成
        let mainMenu = NSMenu()

        // ───────────────
        // [ShortcutHUD] メニュー
        // ───────────────
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu(title: "ShortcutHUD")

        // 終了メニュー項目を追加
        let quitTitle = "終了 ShortcutHUD"
        appMenu.addItem(
            withTitle: quitTitle,
            action: #selector(NSApp.terminate),
            keyEquivalent: "q"
        )

        appMenuItem.submenu = appMenu

        // ✅ 作成したメニューをアプリに登録
        NSApp.mainMenu = mainMenu
        print("📋 メニューバーに『終了』を追加しました")
    }


    func applicationWillTerminate(_ notification: Notification) {
        stopCapture()
        print("🛑 ShortcutHUD 終了")
    }

    private func initializeStatusBar() {
        DispatchQueue.main.async {
            print("🧩 StatusBarController.init() 実行中")
            self.statusBar = StatusBarController(initiallyEnable: true)
            
            self.statusBar?.onToggle = { [weak self] enabled in
                enabled ? self?.startCapture() : self?.stopCapture()
            }
            self.statusBar?.onQuit = { NSApp.terminate(nil) }
        }
    }

    private func startCapture() {
        keyCapture.onKeyCombo = { [weak self] text in
            self?.hudController.show(text: text)
        }
        keyCapture.start()
        print("🎬 キーキャプチャ開始")
    }

    private func stopCapture() {
        keyCapture.stop()
        print("⏹ キーキャプチャ停止")
    }
}

