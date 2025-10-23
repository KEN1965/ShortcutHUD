


import SwiftUI

struct HUDView: View {
    @ObservedObject var state: HUDState
    var onQuit: (() -> Void)?

    var body: some View {
        ZStack {
            if state.visible {
            // 背景
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black.opacity(0.85))
                .frame(width: 500, height: 200)
                .shadow(radius: 10)

            // 文字を中央に「ガチ固定」
            Text(state.text)
                .font(.system(size: 90, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(width: 550, height: 160, alignment: .center) // ← 中央固定
                }
            }
        // 画面中央
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.clear)
        .animation(.easeInOut(duration: 0.2), value: state.visible)
    }
}
