//
//  WorkspaceNavigatorView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI

struct NavigatorView: View {

    @Binding var currentOpen: File?

    @State private var selection: Navigator = .project

    @EnvironmentObject private var files: WorkspaceFiles

    var body: some View {

        VStack {
            switch selection {
            case .project:
                List {
                    switch files.root {
                    case .folder(let folder):
                        ForEach(folder.children) { child in
                            switch child {
                            case .folder(let data):
                                Text("Folder")
                            case .file(let data):
                                Text(data.fileName)
                                    .onTapGesture {
                                        currentOpen = .file(data)
                                        print("Set file to \(data.fileName)")
                                    }
                            }
                        }
                    case .file(let file):
                        Text(file.fileName)
                    }


                }
            case .sourceControl:
                Text("Source Control")
            case .search:
                Text("Search")
            }
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
            VStack {
                Divider()
                NavigatorPicker(selection: $selection)
                Divider()
            }
        }
    }
}
