//
//  TabBarContextMenu.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/4/22.
//

import Foundation
import SwiftUI
import OrderedCollections

extension View {
    func tabBarContextMenu(item: DataFile, isTemporary: Bool) -> some View {
        modifier(TabBarContextMenu(item: item, isTemporary: isTemporary))
    }
}

struct TabBarContextMenu: ViewModifier {
    init(
        item: DataFile,
        isTemporary: Bool
    ) {
        self.item = item
        self.isTemporary = isTemporary
    }

    @EnvironmentObject
    var tabs: ReferenceTabGroup

    @EnvironmentObject
    var workspace: WorkspaceFiles

    private var item: DataFile
    private var isTemporary: Bool

    // swiftlint:disable:next function_body_length
    func body(content: Content) -> some View {
        content.contextMenu(menuItems: {
            Group {
                Button("Close Tab") {
                    withAnimation {
                        _ = tabs.files.remove(item)
                    }
                }
                .keyboardShortcut("w", modifiers: [.command])

                Button("Close Other Tabs") {
                    withAnimation {
                        tabs.files = [item]
                    }
                }
                Button("Close Tabs to the Right") {
                    withAnimation {
                        tabs.files = OrderedSet(tabs.files.prefix { $0 == item })
                    }
                }
                // Disable this option when current tab is the last one.
                .disabled(tabs.files.last == item)

                Button("Close All") {
                    withAnimation {
                        tabs.files = []
                    }
                }

                if isTemporary {
                    Button("Keep Open") {
                        // TODO: Fix this
//                        workspace.convertTemporaryTab()
                    }
                }
            }

            Divider()

            if let item = item as? WorkspaceClient.FileItem {
                Group {
                    Button("Copy Path") {
                        copyPath(item: item)
                    }

                    Button("Copy Relative Path") {
                        copyRelativePath(item: item)
                    }
                }

                Divider()

                Group {
                    Button("Show in Finder") {
                        item.showInFinder()
                    }

                    Button("Reveal in Project Navigator") {
                        // TODO: Fix this
//                        workspace.listenerModel.highlightedFileItem = item
                    }

                    Button("Open in New Window") {

                    }
                    .disabled(true)
                }
            }
        })
    }

    // MARK: - Actions

    /// Copies the absolute path of the given `FileItem`
    /// - Parameter item: The `FileItem` to use.
    private func copyPath(item: WorkspaceClient.FileItem) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.url.standardizedFileURL.path, forType: .string)
    }

    /// Copies the relative path from the workspace folder to the given file item to the pasteboard.
    /// - Parameter item: The `FileItem` to use.
    private func copyRelativePath(item: WorkspaceClient.FileItem) {
        let rootPath = workspace.root.url

        // Calculate the relative path
        var rootComponents = rootPath.standardizedFileURL.pathComponents
        var destinationComponents = item.url.standardizedFileURL.pathComponents

        // Remove any same path components
        while !rootComponents.isEmpty && !destinationComponents.isEmpty
                && rootComponents.first == destinationComponents.first {
            rootComponents.remove(at: 0)
            destinationComponents.remove(at: 0)
        }

        // Make a "../" for each remaining component in the root URL
        var relativePath: String = String(repeating: "../", count: rootComponents.count)
        // Add the remaining components for the destination url.
        relativePath += destinationComponents.joined(separator: "/")

        // Copy it to the clipboard
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(relativePath, forType: .string)
    }
}
