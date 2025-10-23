

import AppKit
import SwiftUI

final class HUDController {
    static let shared = HUDController()   // ← AppleDelegate で使う shared

    private var window: NSWindow?
    private var hosting: NSHostingView<HUDView>?
    private var state = HUDState()

    private init() {}

    func show(text: String) {
        ensureWindow()
        state.show(text)    // ← HUDViewへ反映
        window?.orderFrontRegardless()
        print("🪟 HUD show:", text)
    }
    

    private func ensureWindow() {
        if window == nil {
            // SwiftUIビューを用意
            let content = HUDView(state: state, onQuit: {
                NSApp.terminate(nil)
            })
            let host = NSHostingView(rootView: content)
            host.wantsLayer = true
            hosting = host

            let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1280, height: 800)
            let frame = NSRect(x: screen.midX - 300, y: screen.midY - 100, width: 600, height: 200)
            let w = NSWindow(contentRect: frame,
                             styleMask: [.borderless],
                             backing: .buffered,
                             defer: false)

            w.isOpaque = false
            w.backgroundColor = .clear
            w.level = .mainMenu
            w.ignoresMouseEvents = false
            w.hasShadow = false
            w.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            w.contentView = host

            window = w
            print("✅ HUD window created with frame:", w.frame)
        }
    }
}
