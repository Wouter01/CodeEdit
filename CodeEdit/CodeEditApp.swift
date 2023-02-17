//
//  CodeEditApp.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/01/2023.
//

import SwiftUI
import Defaults

extension Defaults.Keys {
    static let alwaysKeepWindows = Key<Bool>("NSQuitAlwaysKeepsWindows", default: false)
}

@main
struct CodeEditApp: App {
    @NSApplicationDelegateAdaptor var appdelegate: AppDelegate

    init() {
        NSToolbar.swizzle()
        NSSplitViewController.swizzle()
        NSVisualEffectView.swizzle()
        NSDocumentController.swizzle()
        NSDocument.swizzle()
        FileWrapper.swizzle()
        UserDefaults.standard.removeAll()

        // This enables window restoring on normal quit (instead of only on force-quit).
        Defaults[.alwaysKeepWindows] = true
    }

    var body: some Scene {

        WelcomeWindow()

        WorkspaceScene()

        Settings {
            VStack {
                Text("PlaceHolder")
                Button("Old Settings...") {
                    appdelegate.openPreferences(self)
                }
            }
            .frame(width: 200, height: 200)
        }
    }
}
