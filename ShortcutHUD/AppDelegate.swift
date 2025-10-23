//
//  Untitled 2.swift
//  ShortcutHUD
//
//  Created by Kenichi on R 7/10/22.
//
import Cocoa

@main
final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusBar: StatusBarController?
    private let hudController = HUDController.shared
    private let keyCapture = KeyCapture.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 AppDelegate.swift が読み込まれました")


        // ✅ Dockを非表示（LSUIElement=trueでさらに安全）
        NSApp.setActivationPolicy(.accessory)
        print("✅ Dock 非表示モードで起動")

        // ✅ 少し遅らせてメニューバーを初期化（0.5秒後）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.initializeStatusBar()
        }

        // ✅ キーキャプチャを開始
        startCapture()

        print("🚀 ShortcutHUD 起動完了")
    }

    func applicationWillTerminate(_ notification: Notification) {
        stopCapture()
        print("🛑 ShortcutHUD 終了")
    }

    private func initializeStatusBar() {
        statusBar = StatusBarController()
        statusBar?.onToggle = { [weak self] enabled in
            enabled ? self?.startCapture() : self?.stopCapture()
        }
        statusBar?.onQuit = { NSApp.terminate(nil) }
        statusBar?.setActive(true)
        print("📎 メニューバーアイコン作成完了")
    }

    private func startCapture() {
        keyCapture.onKeyCombo = { [weak self] text in
            self?.hudController.show(text: text)
        }
        keyCapture.start()
        print("🎬 キーキャプチャ開始")
        statusBar?.setActive(true)
    }

    private func stopCapture() {
        keyCapture.stop()
        print("⏹ キーキャプチャ停止")
        statusBar?.setActive(false)
    }
}
