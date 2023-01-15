//
//  FileType.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import Foundation

enum FileType {
    case child(parent: FolderFile)
    case root(url: URL)
}
