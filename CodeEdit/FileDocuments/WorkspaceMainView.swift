//
//  WorkspaceMainView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import Defaults

struct WorkspaceMainView: View {

    @StateObject var files: WorkspaceFiles

    init(files: WorkspaceFiles) {
        self._files = .init(wrappedValue: files)
    }

    var body: some View {
        WorkspaceSplitView()
            .environmentObject(files)
    }
}
