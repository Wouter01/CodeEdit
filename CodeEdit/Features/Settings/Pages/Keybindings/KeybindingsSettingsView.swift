//
//  KeybindingsSettingsView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 30/05/2023.
//

import SwiftUI
import KeyboardShortcuts

struct KeybindingsSettingsView: View {

    @ObservedObject var manager = CommandManager.shared

    var body: some View {
        Form {
            ForEach(Array(manager.commands)) { command in
                LabeledContent(command.title) {
//                    KeyboardShortcuts.
                }
            }
        }
        .formStyle(.grouped)
    }
}
