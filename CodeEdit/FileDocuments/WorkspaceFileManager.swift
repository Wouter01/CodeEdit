//
//  WorkspaceFileManager.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

class WorkspaceFiles: ObservableObject {
    @Published var root: File

    init(root: FileWrapper, rootURL: URL) {
        self.root = .folder(.init(fileWrapper: root, root: rootURL))
    }
}
