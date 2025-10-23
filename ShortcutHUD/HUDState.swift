

import SwiftUI
import Combine

final class HUDState: ObservableObject {
    @Published var text: String = ""
    @Published var visible: Bool = false
    private var hideWorkItem: DispatchWorkItem?

    func show(_ message: String) {
        DispatchQueue.main.async {
            // 既存の非表示処理をキャンセル（連続入力に強い）
            self.hideWorkItem?.cancel()

            withAnimation(.easeInOut(duration: 0.1)) {
                self.text = message
                self.visible = true
            }

            // 非表示タイマーを再設定（1秒後）
            let work = DispatchWorkItem {
                withAnimation(.easeOut(duration: 0.3)) {
                    self.visible = false
                }
            }
            self.hideWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: work)
        }
    }
}
