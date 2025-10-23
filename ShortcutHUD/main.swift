//
//  main.swift
//  ShortcutHUD
//
//  Created by Kenichi on R 7/10/23.
//

import Cocoa

// ✅ NSApplication を起動して、AppDelegate を設定してから実行
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
