//
//  SettingsView.swift
//  ShortcutHUD
//
//  Created by Kenichi on R 7/10/22.
//
import SwiftUI

final class HUDSettings: ObservableObject {
    static let shared = HUDSettings()
    @Published var fontSize: CGFloat = 80
    @Published var showDuration: Double = 1.2
    @Published var cornerRadius: CGFloat = 20
    @Published var padding: CGFloat = 14
    @Published var position: HUDPosition = .center
    @Published var allowRepeatWhileHeld: Bool = false // 長押し連打抑制
}

enum HUDPosition: String, CaseIterable, Identifiable {
    case top, center, bottom, bottomRight, bottomLeft
    var id: String { rawValue }
}

struct SettingsView: View {
    @ObservedObject var settings = HUDSettings.shared
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Stepper(value: $settings.fontSize, in: 24...100, step: 2) {
                    Text("Font Size: \(Int(settings.fontSize))")
                }
                Stepper(value: $settings.cornerRadius, in: 8...36, step: 2) {
                    Text("Corner Radius: \(Int(settings.cornerRadius))")
                }
                Stepper(value: $settings.padding, in: 8...40, step: 2) {
                    Text("Padding: \(Int(settings.padding))")
                }
                Picker("Position", selection: $settings.position) {
                    ForEach(HUDPosition.allCases) { pos in
                        Text(pos.rawValue.capitalized).tag(pos)
                    }
                }
            }
            Section(header: Text("Behavior")) {
                Slider(value: $settings.showDuration, in: 0.5...3.0, step: 0.1) {
                    Text("Show Duration")
                }
                Text(String(format: "Show Duration: %.1fs", settings.showDuration))
                Toggle("Suppress repeats while key held", isOn: $settings.allowRepeatWhileHeld)
            }
        }
        .padding(20)
        .frame(width: 420)
    }
}
