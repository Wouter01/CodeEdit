//
//  NavigatorSwitcher.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

enum Navigator: CaseIterable, Identifiable, CustomStringConvertible, Hashable {
    case project
    case sourceControl
    case search

    var id: String { description }

    var description: String {
        switch self {
        case .project:
            return "Files"
        case .sourceControl:
            return "Source Control"
        case .search:
            return "Search"
        }
    }

    var icon: Image {
        switch self {
        case .project:
            return Image(systemName: "folder")
        case .sourceControl:
            return Image(nsImage: NSImage.vault)
        case .search:
            return Image(systemName: "magnifyingglass")
        }
    }

    static var allCases: [Navigator] {
        [.project, .sourceControl, .search]
    }
}

struct NavigatorPicker: View {
    @Binding var selection: Navigator

    var body: some View {
        HStack {
            ForEach(Navigator.allCases) { navigator in
                Button {
                    selection = navigator
                } label: {
                    navigator.icon
                }
                .help(navigator.description)
                .buttonStyle(.navigator(selected: navigator == selection))
            }
        }
    }
}

extension ButtonStyle where Self == NavigatorPickerStyle {
    static func navigator(selected: Bool) -> NavigatorPickerStyle {
        NavigatorPickerStyle(isSelected: selected)
    }
}

struct NavigatorPickerStyle: ButtonStyle {
    var isSelected: Bool

    @Environment(\.controlActiveState) var activeState: ControlActiveState

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
            .symbolVariant(isSelected ? .fill : .none)
            .foregroundColor(isSelected ? .accentColor : configuration.isPressed ? .primary : .secondary)
            .frame(width: 15, height: 13, alignment: .center)
            .contentShape(Rectangle())
            .opacity(activeState == .inactive ? 0.45 : 1)
    }
}
