//
//  File.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/01/2023.
//

import Foundation

enum File: Identifiable, Hashable {

    case file(DataFile)
    case folder(FolderFile)

    var id: URL {
        switch self {
        case .file(let dataFile):
            return dataFile.id
        case .folder(let folderFile):
            return folderFile.id
        }
    }

    static func == (lhs: File, rhs: File) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
