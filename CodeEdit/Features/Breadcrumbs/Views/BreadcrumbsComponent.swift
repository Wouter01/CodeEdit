//
//  BreadcrumbsComponent.swift
//  CodeEditModules/Breadcrumbs
//
//  Created by Lukas Pistrol on 18.03.22.
//

import SwiftUI

struct BreadcrumbsComponent: View {

    private let fileItem: File
    private let tappedOpenFile: (File) -> Void

    @Environment(\.colorScheme)
    var colorScheme

    @Environment(\.controlActiveState)
    private var activeState

    @StateObject
    private var prefs: AppPreferencesModel = .shared

    @State
    var position: NSPoint?

    @State var selection: File

    init(
        fileItem: File,
        tappedOpenFile: @escaping (File) -> Void
    ) {
        self.fileItem = fileItem
        self._selection = .init(wrappedValue: fileItem)
        self.tappedOpenFile = tappedOpenFile
    }

    private var color: Color {
        switch fileItem {
        case .file(let dataFile):
            return dataFile.iconColor
        case .folder:
            return Color(hex: colorScheme == .dark ? "#61b6df" :"#27b9ff")
        case .symlink:
            return .accentColor
        }
    }

    var siblings: [File] {
        switch fileItem.parent {
        case .child(let parent):
            return parent.children
        case .root:
            return [fileItem]
        }
    }

    var body: some View {
        NSPopUpButtonView(selection: $selection) {
            let button = NSPopUpButton()
            button.menu = BreadcrumsMenu(fileItems: siblings, tappedOpenFile: tappedOpenFile)
            button.font = .systemFont(ofSize: NSFont.systemFontSize(for: .small))
            button.isBordered = false
            (button.cell as? NSPopUpButtonCell)?.arrowPosition = .noArrow
            return button
        }
        .padding(.leading, -5)
    }

    struct NSPopUpButtonView<ItemType>: NSViewRepresentable where ItemType: Equatable {
        @Binding var selection: ItemType
        var popupCreator: () -> NSPopUpButton

        typealias NSViewType = NSPopUpButton

        func makeNSView(context: NSViewRepresentableContext<NSPopUpButtonView>) -> NSPopUpButton {
            let newPopupButton = popupCreator()
            setPopUpFromSelection(newPopupButton, selection: selection)
            return newPopupButton
        }

        func updateNSView(_ nsView: NSPopUpButton, context: NSViewRepresentableContext<NSPopUpButtonView>) {
            setPopUpFromSelection(nsView, selection: selection)
        }

        func setPopUpFromSelection(_ button: NSPopUpButton, selection: ItemType) {
            let itemsList = button.itemArray
            let matchedMenuItem = itemsList.filter {
                ($0.representedObject as? ItemType) == selection
            }.first
            if matchedMenuItem != nil {
                button.select(matchedMenuItem)
            }
        }

        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }

        class Coordinator: NSObject {
            var parent: NSPopUpButtonView!

            init(_ parent: NSPopUpButtonView) {
                super.init()
                self.parent = parent
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(dropdownItemSelected),
                    name: NSMenu.didSendActionNotification,
                    object: nil
                )
            }

            @objc func dropdownItemSelected(_ notification: NSNotification) {
                let menuItem = (notification.userInfo?["MenuItem"])! as? NSMenuItem
                if let selection = menuItem?.representedObject as? ItemType {
                    parent.selection = selection
                }
            }
        }
    }
}
