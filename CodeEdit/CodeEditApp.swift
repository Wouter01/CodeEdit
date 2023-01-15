//
//  CodeEditApp.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/01/2023.
//

import SwiftUI

@main
struct CodeEditApp: App {
    @NSApplicationDelegateAdaptor var appdelegate: AppDelegate

    init() {
        NSToolbar.swizzle()
        NSSplitViewController.swizzle()
        NSVisualEffectView.swizzle()
    }

    var body: some Scene {
        WorkspaceScene()
        
        Settings {
            VStack {
                Text("PlaceHolder")
            }
        }
    }
}
