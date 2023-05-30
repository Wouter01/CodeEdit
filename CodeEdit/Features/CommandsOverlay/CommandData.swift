//
//  CommandDara.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

struct CommandData: Hashable, Identifiable {

    let kind: Kind
    let keyboardShortcut: KeyboardShortcut?
    let visibility: Visibility
    let id: CommandID
    let parentMenu: CommandMenuID?
    var view: _VariadicView.Children.Element?

    var title: String {
        id.paletteTitle
    }

    struct Visibility: OptionSet {
        let rawValue: Int

        static let menubar = Visibility(rawValue: 1 << 0)
        static let commandPalette = Visibility(rawValue: 1 << 1)
    }

    enum Kind {
        case button(action: () -> Void)
        case toggle(isOn: Binding<Bool>)
    }

    static func == (lhs: CommandData, rhs: CommandData) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct MenuData: Hashable {
    static func == (lhs: MenuData, rhs: MenuData) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(children.map(\.id))
    }

    let id: String

    let children: [CommandData]
}

enum MenuBarIem: Hashable, Identifiable {
    case command(CommandData)
    case menu(MenuData)

    var id: String {
        switch self {
        case .command(let commandData):
            return "Command" + commandData.title
        case .menu(let menuData):
            return "Menu" + menuData.id
        }
    }
}
