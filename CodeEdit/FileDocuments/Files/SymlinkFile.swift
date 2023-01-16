//
//  SymlinkFile.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

class SymlinkFile: ObservableObject, Identifiable {

    private var fileWrapper: FileWrapper

    var parent: FileType

    init(fileWrapper: FileWrapper, parent: FileType) {
        guard fileWrapper.isSymbolicLink else {
            fatalError("Provided filewrapper is not a symlink, but a folder/file. \(fileWrapper.filename ?? "Unknown")")
        }
        self.fileWrapper = fileWrapper
        self.parent = parent
    }

    convenience init(fileWrapper: FileWrapper, parent: FolderFile) {
        self.init(fileWrapper: fileWrapper, parent: .child(parent: parent))
    }

    convenience init(fileWrapper: FileWrapper, root: URL) {
        self.init(fileWrapper: fileWrapper, parent: .root(url: root))
    }

    var icon: NSImage? {
        fileWrapper.icon
    }

    var url: URL {
        switch parent {
        case .child(let parent):
            return parent.url.appending(component: fileWrapper.filename!)
        case .root(let url):
            return url
        }
    }

    var fileName: String {
        fileWrapper.filename!
    }

    var id: URL { url }
}
