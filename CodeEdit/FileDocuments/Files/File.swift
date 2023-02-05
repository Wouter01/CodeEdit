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

    var systemImage: String {
        switch self {
        case .file(let dataFile):
            guard let type = dataFile.fileType else {
                return "doc"
            }
            return FileIcon.fileIcon(fileType: type)

        case .symlink(let symlinkFile):
            guard let type = symlinkFile.fileType else {
                return "doc"
            }
            return FileIcon.fileIcon(fileType: type)

        case .folder(let folderFile) where folderFile.fileName == ".codeedit":
            return "folder.fill.badge.gearshape"
        case .folder(let folderFile) where folderFile.children.isEmpty:
            return "folder"
        case .folder:
            return "folder.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .file(let dataFile):
            guard let type = dataFile.fileType else {
                return .accentColor
            }
            return FileIcon.iconColor(fileType: type)

        case .symlink(let symlinkFile):
            guard let type = symlinkFile.fileType else {
                return .accentColor
            }
            return FileIcon.iconColor(fileType: type)

        case .folder:
            return Color(NSColor(named: "FolderBlue") ?? .systemBlue)
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
