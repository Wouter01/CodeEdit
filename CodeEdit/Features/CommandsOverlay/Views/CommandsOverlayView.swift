//
//  CommandsOverlayView.swift
//  CodeEdit
//
//  Created by Alex Sinelnikov on 24.05.2022.
//

import SwiftUI

/// Commands overlay view
struct CommandsOverlayView: View {

    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme

    @ObservedObject
    private var manager: CommandManager = .shared

    @State
    private var monitor: Any?

    private let closeOverlay: () -> Void

    init(closeOverlay: @escaping () -> Void) {
        self.closeOverlay = closeOverlay
    }

    @State var chosenMenu: MenuData?

    @State var searchText = ""

    var shownCommands: [CommandData] {
        manager.commands
            .filter { $0.visibility.contains(.commandPalette) }
            .sorted(using: KeyPathComparator(\.title))
    }

    var availableItems: [MenuBarItem] {
        if let chosenMenu {
            return chosenMenu.children.map { .command($0) }
        }
        return manager.commands
            .filter { searchText.isEmpty || $0.title.contains(searchText) }
            .filter { $0.visibility.contains(.commandPalette) }
            .filter { $0.parentMenu == nil }
            .sorted(using: KeyPathComparator(\.title))
            .map { .command($0) }
        +
        manager.menus
            .map { .menu($0) }
    }

    var body: some View {
        OverlayView(
            title: "Commands",
            image: Image(systemName: "magnifyingglass"),
            options: availableItems,
            text: $searchText,
            alwaysShowOptions: true
        ) {
            CommandsOverlayItem(command: $0, textToMatch: searchText)
        } onRowClick: {
            switch $0 {
            case .command(let command):
                switch command.kind {
                case .button(let action):
                    action()
                case .toggle(let isOn):
                    isOn.wrappedValue.toggle()
                }
            case .menu(let menu):
                chosenMenu = menu
            }
        } onClose: {
            closeOverlay()
        }
    }
}



struct CommandsOverlayItem: View {
    let command: MenuBarItem
    let textToMatch: String

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                switch command {
                case .command(let commandData):
                    switch commandData.kind {
                    case .button:
                        if let view = commandData.view {
                            view
                        } else {
                            createHighlightText(title: commandData.title, textToMatch: textToMatch)
                                .allowsTightening(false)
                                .frame(height: 30)
                        }
                    case .toggle(let isOn):
                        CommandPaletteToggleItem(command: commandData, textToMatch: textToMatch, isOn: isOn)
                        
                    }
                case .menu(let menuData):
                    createHighlightText(title: menuData.id, textToMatch: textToMatch)
                        .allowsTightening(false)
                        .frame(height: 30)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    func createHighlightText(title: String, textToMatch: String) -> Text {
        let range = title.range(of: textToMatch, options: .caseInsensitive)

        guard let range else {
            return Text(title)
        }

        return Text(title[..<range.lowerBound]) +
        Text(title[range]).fontWeight(.bold) +
        Text(title[range.upperBound...])
    }
}

