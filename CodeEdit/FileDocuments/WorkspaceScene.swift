//
//  WorkspaceScene.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

struct WorkspaceScene: Scene {
    var body: some Scene {
        DocumentGroup(viewing: ReferenceWorkspaceFileDocument.self) { config in
            WorkspaceMainView(files: .init(root: config.document.baseRoot, rootURL: config.fileURL!))
        }
    }
}
