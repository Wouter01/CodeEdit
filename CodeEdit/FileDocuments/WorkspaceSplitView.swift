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

    @State var showPopover = false
    @State var currentOpen: File?

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            NavigatorView(currentOpen: $currentOpen)

                .navigationSplitViewColumnWidth(min: 200, ideal: 300)
                .toolbar(id: "AltSidebar") {

                    ToolbarItem(id: "ToggleSidebar") {
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
            WorkspaceEditorAltView(tabgroup: files.tabs)
            .navigationSplitViewColumnWidth(min: 500, ideal: 500)
            .toolbar(id: "Editor") {

                ToolbarItem(id: "SourceControl", placement: .navigation, showsByDefault: true) {
                    ToolbarBranchPicker(
                        shellClient: currentWorld.shellClient,
                        folderURL: files.root.url
                    )
                }

                ToolbarItem(id: "FakeSpacer") {
                    Divider()
                }

                ToolbarItem(id: "CenterSection", showsByDefault: true) {
                    HStack {

                        Button("EXample") {
                            showPopover.toggle()
                        }
                        .buttonStyle(.plain)
                        .padding(.leading, 4)

                        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
                            VStack {
                                Text("HEllo")
                            }
                            .padding(10)
                        }

                        Spacer()

                        Image(nsImage: NSApp.applicationIconImage)
                            .resizable()
                            .scaledToFit()
                            .padding(2)

                    }
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.gray.opacity(0.2))
                    }

                }

                ToolbarItem(id: "WarningAndErrorButtons") {
                    HStack {
                        Button {

                        } label: {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("1")
                            }

                        }
                        Button {

                        } label: {
                            HStack {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.red)
                                Text("1")
                            }
                        }
                    }
                }

                ToolbarItem(id: "FakeSpacer") {
                    Divider()
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
            .toolbar(id: "Inspector") {
                ToolbarItem(id: "Spacer") {
                    Spacer()
                }

                ToolbarItem(id: "ToggleInspectorButton") {
                    Button {
                        toggleInspector()
                    } label: {
                        Image(systemName: "sidebar.right")
                    }
                    .controlSize(.large)
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
