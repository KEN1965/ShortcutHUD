import AppKit
import Carbon

struct KeyMap {

    // MARK: - 日本語キーボード（JIS）
    private let jisKeys: [CGKeyCode: String] = [
        0:"A",1:"S",2:"D",3:"F",4:"H",5:"G",6:"Z",7:"X",8:"C",9:"V",
        10:"¥",11:"B",12:"Q",13:"W",14:"E",15:"R",16:"Y",17:"T",
        18:"1",19:"2",20:"3",21:"4",22:"6",23:"5",24:"=",25:"9",
        26:"7",27:"-",28:"8",29:"0",30:"]",31:"O",32:"U",33:"[",
        34:"I",35:"P",36:"Return",37:"L",38:"J",39:";",40:"K",
        41:":",42:"`",43:",",44:"/",45:"N",46:"M",47:".",48:"Tab",
        49:"Space",50:"_",51:"Delete",52:"Enter",53:"Esc",
        65:"Keypad .",67:"Keypad *",69:"Keypad +",75:"Keypad /",
        76:"Keypad Enter",78:"Keypad -",81:"Keypad =",82:"Keypad 0",
        83:"Keypad 1",84:"Keypad 2",85:"Keypad 3",86:"Keypad 4",
        87:"Keypad 5",88:"Keypad 6",89:"Keypad 7",91:"Keypad 8",
        92:"Keypad 9",
        96:"F5",97:"F6",98:"F7",99:"F3",100:"F8",101:"F9",
        103:"F11",105:"F13",106:"F16",107:"F14",109:"F10",
        111:"F12",113:"F15",114:"Help",115:"Home",116:"PageUp",
        117:"ForwardDelete",118:"F4",119:"End",120:"F2",121:"PageDown",
        122:"F1",123:"←",124:"→",125:"↓",126:"↑"
    ]

    // MARK: - 英語キーボード（US）
    private let usKeys: [CGKeyCode: String] = [
        0:"A",1:"S",2:"D",3:"F",4:"H",5:"G",6:"Z",7:"X",8:"C",9:"V",
        10:"`",11:"B",12:"Q",13:"W",14:"E",15:"R",16:"Y",17:"T",
        18:"1",19:"2",20:"3",21:"4",22:"6",23:"5",24:"=",25:"9",
        26:"7",27:"-",28:"8",29:"0",30:"]",31:"O",32:"U",33:"[",
        34:"I",35:"P",36:"Return",37:"L",38:"J",39:"'",40:"K",
        41:";",42:"\\",43:",",44:"/",45:"N",46:"M",47:".",48:"Tab",
        49:"Space",50:"`",51:"Delete",52:"Enter",53:"Esc",
        65:"Keypad .",67:"Keypad *",69:"Keypad +",75:"Keypad /",
        76:"Keypad Enter",78:"Keypad -",81:"Keypad =",82:"Keypad 0",
        83:"Keypad 1",84:"Keypad 2",85:"Keypad 3",86:"Keypad 4",
        87:"Keypad 5",88:"Keypad 6",89:"Keypad 7",91:"Keypad 8",
        92:"Keypad 9",
        96:"F5",97:"F6",98:"F7",99:"F3",100:"F8",101:"F9",
        103:"F11",105:"F13",106:"F16",107:"F14",109:"F10",
        111:"F12",113:"F15",114:"Help",115:"Home",116:"PageUp",
        117:"ForwardDelete",118:"F4",119:"End",120:"F2",121:"PageDown",
        122:"F1",123:"←",124:"→",125:"↓",126:"↑"
    ]

    // MARK: - キーボード配列に応じてキー名を取得
    func nameFor(event: CGEvent) -> String {
        let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))
        let layout = currentKeyboardLayoutID()
        let dict = (layout.contains("Kotoeri") || layout.contains("Japanese")) ? jisKeys : usKeys
        return dict[keyCode] ?? "Key\(keyCode)"
    }

    // MARK: - 修飾キーのシンボル表示
    func modifierSymbols(from flags: NSEvent.ModifierFlags) -> [String] {
        var parts: [String] = []
        if flags.contains(.control) { parts.append("⌃") }
        if flags.contains(.option) { parts.append("⌥") }
        if flags.contains(.shift) { parts.append("⇧") }
        if flags.contains(.command) { parts.append("⌘") }
        return parts
    }
}

// MARK: - 現在のキーボードレイアウトを取得
func currentKeyboardLayoutID() -> String {
    guard let inputSource = TISCopyCurrentKeyboardLayoutInputSource()?.takeUnretainedValue() else {
        return "unknown"
    }
    if let sourceID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) {
        return Unmanaged<CFString>.fromOpaque(sourceID).takeUnretainedValue() as String
    }
    return "unknown"
}
