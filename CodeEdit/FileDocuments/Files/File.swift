//
//  File.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/01/2023.
//

import SwiftUI

enum File: Identifiable, Hashable {

    case file(DataFile)
    case folder(FolderFile)
    case symlink(SymlinkFile)

    var id: URL { url }

    var url: URL {
        switch self {
        case .file(let dataFile):
            return dataFile.id
        case .folder(let folderFile):
            return folderFile.id
        case .symlink(let symlinkFile):
            return symlinkFile.id
        }
    }

    var icon: NSImage? {
        switch self {
        case .file(let file):
            return file.icon
        case .folder(let folder):
            return folder.icon
        case .symlink(let symlink):
            return symlink.icon
        }
    }

    var children: [File]? {
        switch self {
        case .file, .symlink:
            return nil
        case .folder(let folderFile):
            return folderFile.children
        }
    }

    var parent: FileType {
        switch self {
        case .file(let dataFile):
            return dataFile.parent
        case .folder(let folderFile):
            return folderFile.parent
        case .symlink(let symlink):
            return symlink.parent
        }
    }

    var fileName: String! {
        switch self {
        case .folder(let folder):
            return folder.fileName
        case .file(let file):
            return file.fileName
        case .symlink(let symlink):
            return symlink.fileName
        }
    }

    static func == (lhs: File, rhs: File) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
