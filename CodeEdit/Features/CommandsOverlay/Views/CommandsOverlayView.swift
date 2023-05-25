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
    private var state: CommandsOverlayViewModel

    @ObservedObject
    private var manager: CommandManager = .shared

    @State
    private var monitor: Any?

    private let closeOverlay: () -> Void

    init(state: CommandsOverlayViewModel, closeOverlay: @escaping () -> Void) {
        self.state = state
        self.closeOverlay = closeOverlay
    }

    @State var chosenMenu: MenuData?

    var shownCommands: [CommandData] {
        manager.commands
            .filter { $0.visibility.contains(.commandPalette) }
            .sorted(using: KeyPathComparator(\.title))
    }

    var availableItems: [MenuBarIem] {
        if let chosenMenu {
            return chosenMenu.children.map { .command($0) }
        }
        return manager.commands
            .filter { $0.visibility.contains(.commandPalette) }
            .sorted(using: KeyPathComparator(\.title))
            .map { .command($0) }
        +
        manager.menus
            .map { .menu($0) }
    }

    var body: some View {
        OverlayView<CommandsOverlayItem, EmptyView, MenuBarIem>(
            title: "Commands",
            image: Image(systemName: "magnifyingglass"),
            options: availableItems,
            text: $state.commandQuery,
            alwaysShowOptions: true,
            optionRowHeight: 30
        ) { command, selected in

            CommandsOverlayItem(command: command, textToMatch: state.commandQuery, selected: selected)

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
        .onReceive(state.$commandQuery.debounce(for: 0.05, scheduler: DispatchQueue.main)) { _ in
            state.fetchMatchingCommands(filter: state.commandQuery)
        }
    }
}

struct ToggleView: View {
    var command: CommandData
    let textToMatch: String?
    let selected: Bool
    @Binding var isOn: Bool

    var body: some View {
        SearchResultLabel(labelName: command.title + (isOn ? " (On)" : " (Off)"), textToMatch: textToMatch ?? "", selected: selected)
    }
}

struct CommandsOverlayItem: View {
    let command: MenuBarIem
    let textToMatch: String?
    let selected: Bool

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
                            SearchResultLabel(labelName: commandData.title, textToMatch: textToMatch ?? "", selected: selected)
                        }
                    case .toggle(let isOn):
                        ToggleView(command: commandData, textToMatch: textToMatch, selected: selected, isOn: isOn)
                        //                    SearchResultLabel(labelName: command.title + (isOn.wrappedValue ? " (On)" : " (Off)"), textToMatch: textToMatch ?? "", selected: selected)
                    }
                case .menu(let menuData):
                    SearchResultLabel(labelName: menuData.id, textToMatch: textToMatch ?? "", selected: selected)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
//            if let shortcut = command.keyboardShortcut {
//                Text(shortcut.modifiers.description + String(shortcut.key.character).uppercased())
//                    .foregroundColor(
//                        selected
//                        ? Color(.selectedMenuItemTextColor)
//                        : Color(.labelColor.withSystemEffect(.disabled))
//                    )
//            }
        }
        .frame(maxWidth: .infinity)
    }
}

/// Implementation of commands overlay entity. While swiftui does not allow to use NSMutableAttributeStrings,
/// the only way to fallback to UIKit and have NSViewRepresentable to be a bridge between UIKit and SwiftUI.
/// Highlights currently entered text query
struct SearchResultLabel: NSViewRepresentable {
    var labelName: String
    var textToMatch: String
    var selected: Bool

    public func makeNSView(context: Context) -> some NSTextField {
        let label = NSTextField(wrappingLabelWithString: labelName)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.drawsBackground = false
        label.textColor = selected ? .selectedMenuItemTextColor : .labelColor
        label.isEditable = false
        label.isSelectable = false
        label.font = .labelFont(ofSize: 13.5)
        label.allowsDefaultTighteningForTruncation = false
        label.cell?.truncatesLastVisibleLine = true
        label.cell?.wraps = true
        label.maximumNumberOfLines = 1
        label.attributedStringValue = highlight()
        return label
    }

    func highlight() -> NSAttributedString {
        let attribText = NSMutableAttributedString(string: self.labelName)
        let range: NSRange = attribText.mutableString.range(
            of: self.textToMatch,
            options: NSString.CompareOptions.caseInsensitive
        )
        attribText.addAttribute(
            .foregroundColor,
            value: NSColor(Color(selected ? .selectedMenuItemTextColor : .labelColor)),
            range: range
        )
        attribText.addAttribute(.font, value: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize), range: range)

        return attribText
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.textColor = selected
            ? .selectedMenuItemTextColor
            : textToMatch.isEmpty
                ? .labelColor
                : .secondaryLabelColor
        nsView.attributedStringValue = highlight()
    }
}
