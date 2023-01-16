//
//  FolderFile.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

class FolderFile: ObservableObject, Identifiable {

    var parent: FileType

    private var fileWrapper: FileWrapper

    init(fileWrapper: FileWrapper, parent: FileType) {
        guard fileWrapper.isDirectory else {
            fatalError("Provided filewrapper is not a folder, but a file/symlink. \(fileWrapper.filename ?? "Unknown")")
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

    var fileName: String! {
        fileWrapper.filename!
    }

    var url: URL {
        switch parent {
        case .child(let parent):
            return parent.url.appending(component: fileWrapper.filename!)
        case .root(let url):
            return url
        }
    }

    var id: URL { url }

    var children: [File] {
        fileWrapper.fileWrappers!.values.sorted { $0.filename! < $1.filename! }.map {
            
            if $0.isDirectory {
                return File.folder(.init(fileWrapper: $0, parent: self))
            } else if $0.isRegularFile {
                return File.file(.init(fileWrapper: $0, parent: self))
            } else {
                return File.symlink(.init(fileWrapper: $0, parent: self))
            }
        }
    }

    func updateChild(with name: String, replacement: FileWrapper) throws {
        guard let filewrapper = self.fileWrapper.fileWrappers?[name] else {
            throw CocoaError(.fileReadNoSuchFile)
        }

        self.fileWrapper.removeFileWrapper(filewrapper)
        self.fileWrapper.addFileWrapper(replacement)
    }
}
