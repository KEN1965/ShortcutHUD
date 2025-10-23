

import AppKit
import SwiftUI

final class HUDController {
    static let shared = HUDController()

    private var window: NSWindow?
    private var hosting: NSHostingView<HUDView>?
    private let state = HUDState()

    private init() {}

    func show(text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.ensureWindow()
            print("🎬 HUD show() 呼ばれた: ", text)
            print("🪟 window is nil?:", self.window == nil)

            // ✅ 状態更新はメインスレッドで確実に行う
            self.state.show(text)

            // ✅ ウィンドウの再配置＆再描画
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let windowWidth: CGFloat = 600
                let windowHeight: CGFloat = 200
                let newFrame = NSRect(
                    x: screenFrame.midX - windowWidth / 2,
                    y: screenFrame.midY - windowHeight / 2,
                    width: windowWidth,
                    height: windowHeight
                )
                self.window?.setFrame(newFrame, display: true)
            }

            // ✅ 常に前面に再表示
            self.window?.makeKeyAndOrderFront(nil)
            self.window?.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: true)


            print("🪟 HUD show:", text)
        }
    }

    private func ensureWindow() {
        if window == nil {
            let content = HUDView(state: state, onQuit: {
                NSApp.terminate(nil)
            })
            let host = NSHostingView(rootView: content)
            host.wantsLayer = true
            hosting = host

            guard let screen = NSScreen.main else { return }
            let screenFrame = screen.visibleFrame
            let windowWidth: CGFloat = 550
            let windowHeight: CGFloat = 200
            let frame = NSRect(
                x: screenFrame.midX - windowWidth / 2,
                y: screenFrame.midY - windowHeight / 2,
                width: windowWidth,
                height: windowHeight
            )

            let w = NSWindow(
                contentRect: frame,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )

            w.isOpaque = false
            w.backgroundColor = .clear
            w.level = .floating
            w.hasShadow = false
            w.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            w.ignoresMouseEvents = false
            w.contentView = host

            window = w
            print("✅ HUD window created and centered:", w.frame)
        }
    }
}
