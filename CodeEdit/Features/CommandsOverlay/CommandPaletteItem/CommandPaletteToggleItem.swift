//
//  CommandPaletteToggleItem.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 31/05/2023.
//

import SwiftUI

struct CommandPaletteToggleItem: CommandPaletteItem {

    var command: CommandData
    var textToMatch: String
    @Binding var isOn: Bool

    var title: String {
        command.title
    }

    var body: some View {
        (createHighlightText() + Text(isOn ? " (On)" : " (Off)"))
            .allowsTightening(false)
    }
}
