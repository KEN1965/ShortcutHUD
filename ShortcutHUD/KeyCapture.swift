//
//  KeyCapture.swift
//  ShortcutHUD
//
//  Created by Kenichi on R 7/10/22.
//
import Cocoa

final class KeyCapture {
    static let shared = KeyCapture()

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var isRunning = false

    var onKeyCombo: ((String) -> Void)?

    private let keyMap = KeyMap()

    func start() {
        guard !isRunning else { return }

        let mask = (1 << CGEventType.keyDown.rawValue) |
                   (1 << CGEventType.flagsChanged.rawValue)

        if let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: { proxy, type, event, refcon in
                let unmanaged = Unmanaged<KeyCapture>.fromOpaque(refcon!)
                let me = unmanaged.takeUnretainedValue()
                return me.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        ) {
            eventTap = tap
            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: tap, enable: true)
            isRunning = true
            
            print("✅ CGEvent tap created successfully")

        } else {
            // アクセシビリティ権限なしの可能性
            NSLog("Failed to create event tap. Check Accessibility permissions.")
            print("❌ Failed to create event tap")

        }
    }

    func stop() {
        guard isRunning else { return }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        runLoopSource = nil
        eventTap = nil
        isRunning = false
    }

    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        print("👉 handleEvent called with type:", type.rawValue)

        // keyDown のときに表示（flagsChanged は修飾キー単体の押下検知用だが、ここでは組み合わせ表示重複を避けるため keyDownで出す）
        if type == .keyDown {
            let flags = NSEvent.ModifierFlags(rawValue: UInt(event.flags.rawValue))
            let parts = modifierSymbols(from: flags)
            let keyName = keyMap.nameFor(event: event)
            let tokens = (parts + [keyName]).filter { !$0.isEmpty }
            let combo = tokens.joined(separator: " + ")
            print("Detected:", combo) // ← これが出るか？

            DispatchQueue.main.async { [weak self] in
                self?.onKeyCombo?(combo)
            }
        }
        return Unmanaged.passUnretained(event)
    }

    private func modifierSymbols(from flags: NSEvent.ModifierFlags) -> [String] {
        var arr: [String] = []
        if flags.contains(.command) { arr.append("⌘") }
        if flags.contains(.shift)   { arr.append("⇧") }
        if flags.contains(.option)  { arr.append("⌥") }
        if flags.contains(.control) { arr.append("⌃") }
        return arr
    }
}


