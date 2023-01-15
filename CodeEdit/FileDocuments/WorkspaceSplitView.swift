//
//  WorkspaceSplitView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import CodeEditTextView

struct WorkspaceSplitView: View {

    @EnvironmentObject var files: WorkspaceFiles
    @Environment(\.toggleInspector) var toggleInspector
    @State var visibility = NavigationSplitViewVisibility.automatic

    @State var currentOpen: File?

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            NavigatorView(currentOpen: $currentOpen)

                .navigationSplitViewColumnWidth(min: 200, ideal: 300)
                .toolbar(id: "Sidebarr") {

                    ToolbarItem(id: "toggleSidebarr") {
                        Button {
                            withAnimation {
                                if visibility == .all {
                                    visibility = .doubleColumn
                                } else {
                                    visibility = .all
                                }
                            }
                        } label: {
                            Image(systemName: "sidebar.left")
                        }
                        .controlSize(.large)
                    }
                }

        } content: {

            if case .file(let data) = currentOpen {
                WorkspaceFileEditor(file: data)

                .toolbar(id: "Content") {
                    ToolbarItem(id: "TestButto2n", showsByDefault: false) {
                        Button("Hello2") {

                        }
                        .focusable()
                    }

                    ToolbarItem(id: "TestButton", placement: .primaryAction) {
                        Button("Hello") {

                        }
                        .focusable()
                    }
                }
            }
        } detail: {

            Form {
                ForEach(0..<20, id: \.self) {
                    NavigationLink(String($0), value: "He")
                }
            }
            .safeAreaInset(edge: .top) {
                Divider()
            }
            .formStyle(.grouped)
            .toolbar(id: "Detail") {
                ToolbarItem(id: "flexibleSpace", placement: .automatic) {
                    Spacer()
                }

                ToolbarItem(id: "ShowInspector") {
                    Button {
                        toggleInspector()
                    } label: {
                        Image(systemName: "sidebar.right")
                    }
                }
            }
        }

    }
}

struct WorkspaceSplitView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceSplitView()
    }
}
