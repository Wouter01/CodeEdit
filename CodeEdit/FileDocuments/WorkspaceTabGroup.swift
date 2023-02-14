//
//  WorkspaceTabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import SwiftUI

struct WorkspaceEditorView: View {
    @ObservedObject var tabgroup: ReferenceTabGroup

    var body: some View {
        switch tabgroup.child {
        case .none:
            WorkspaceTabGroupView(tabgroup: tabgroup)
                .frame(minWidth: 100, minHeight: 100)
        case .bottom(let otherTabGroup):
            VSplitView {
                WorkspaceTabGroupView(tabgroup: tabgroup)
                WorkspaceEditorView(tabgroup: otherTabGroup)
            }
        case .top(let otherTabGroup):
            VSplitView {
                WorkspaceEditorView(tabgroup: otherTabGroup)
                WorkspaceTabGroupView(tabgroup: tabgroup)
            }
        case .leading(let otherTabGroup):
            HSplitView {
                WorkspaceTabGroupView(tabgroup: tabgroup)
                WorkspaceEditorView(tabgroup: otherTabGroup)
            }
        case .trailing(let otherTabGroup):
            HSplitView {
                WorkspaceEditorView(tabgroup: otherTabGroup)
                WorkspaceTabGroupView(tabgroup: tabgroup)
            }
        }
    }
}

struct WorkspaceTabGroupView: View {
    @ObservedObject var tabgroup: ReferenceTabGroup

    var body: some View {
        Group {
            if let selected = tabgroup.selected {
                WorkspaceFileEditor(file: selected)
                    
            } else {
                VStack {
                    Spacer()
                    Text("Select a file.")
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
//        .ignoresSafeArea(.all)
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 0) {
                TabBarView()
                    .environmentObject(tabgroup)

//                VStack(spacing: 0) {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(tabgroup.files, id: \.url) { file in
//
//                                Button(file.fileName) {
//                                    tabgroup.selected = file
//                                }
//                                .buttonStyle(.plain)
//                                .contextMenu {
//                                    Button("Split right") {
//                                        tabgroup.child = .horizontal(.init(files: [file], selected: file))
//                                    }
//                                    Button("Split left") {
//                                        tabgroup.child = .horizontal(.init(files: tabgroup.files, selected: tabgroup.selected))
//                                        tabgroup.files = [file]
//                                        tabgroup.selected = file
//                                    }
//                                    Button("Split top") {
//                                        tabgroup.child = .vertical(.init(files: [file], selected: file))
//                                    }
//                                    Button("Split bottom") {
//                                        tabgroup.child = .vertical(.init(files: tabgroup.files, selected: tabgroup.selected))
//                                        tabgroup.files = [file]
//                                        tabgroup.selected = file
//                                    }
//                                }
//
//                            }
//                        }
//                    }
//                    .frame(height: 30)
//                    .padding(.leading)
//                    .scrollContentBackground(.hidden)
                    Divider()
                }
                .background(EffectView(.titlebar, blendingMode: .withinWindow, emphasized: false))
            }

    }
}
