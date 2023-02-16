//
//  WorkspaceFileManager.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

class WorkspaceFiles: ObservableObject {
    @Published var root: File

    @Published var selection: File?

    var searchState: WorkspaceDocument.SearchState!

    @Published var tabs: TabGroup

    var activeTab: TabGroupData

    init(root: FileWrapper, rootURL: URL) {
        self.root = .folder(.init(fileWrapper: root, root: rootURL))
        self.activeTab = .init()
        self.tabs = .horizontal(.init(.horizontal, tabgroups: [.one(activeTab)]))
        self.searchState = .init(manager: self)
    }

    /// Opens a new tab for the given file in the given tabgroup, or activates the tab if already present.
    func openTab(for file: DataFile) {
        activeTab.files.append(file)
    }

    func searchFile(with url: URL) -> File? {
        var current = root
        for component in url.pathComponents {
            switch current {
            case .folder(let folder):
                guard let newCurrent = folder.children.first(where: { $0.id.lastPathComponent == component }) else {
                    return nil
                }
                current = newCurrent
            case .file, .symlink:
                return nil
            }
        }
        return current
    }
}
