//
//  Command.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

struct Command<AltContent: View>: View {
    var id: CommandID

    var kind: CommandData.Kind

    var altContent: () -> AltContent

    @Environment(\.commandVisibility) private var visibility

    @Environment(\.keyboardShortcut) var keyboardShortcut

    @Environment(\.commandMenu) var parentMenu

    @Environment(\.currentView) var currentView

    init(_ id: CommandID, action: @escaping () -> Void, altContent: @escaping () -> AltContent = { EmptyView() }) {
        self.id = id
        self.kind = .button(action: action)
        self.altContent = altContent
    }

    init(_ id: CommandID, isOn: Binding<Bool>, altContent: @escaping () -> AltContent = { EmptyView() }) {
        self.id = id
        self.kind = .toggle(isOn: isOn)
        self.altContent = altContent
    }

    var commandData: CommandData {
        CommandData(
            kind: kind,
            keyboardShortcut: keyboardShortcut,
            visibility: visibility,
            id: id,
            parentMenu: parentMenu
        )
    }

    var body: some View {
        Group {
            switch currentView {
            case .menubar:
                Group {
                    switch kind {
                    case .button(let action):
                        Button(id.menubarTitle, action: action)
                    case .toggle(let isOn):
                        Toggle(id.menubarTitle, isOn: isOn)
                    }
                }
                .task {
                    if parentMenu == nil {
                        CommandManager.shared.registerCommand(commandData)
                    }
                }
            case .commandpalette:
                altContent()
            }
        }
        ._trait(MenuChildTraitKey.self, id)
        ._trait(MenuChildCommandData.self, commandData)
    }
}
