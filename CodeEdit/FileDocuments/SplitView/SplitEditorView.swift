//
//  SplitEditorView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 16/02/2023.
//

import SwiftUI

struct SplitEditorView: View {
    @ObservedObject var data: WorkspaceSplitViewData

    var body: some View {
        switch data.direction {
        case .vertical:
            VSplitView {
                splitView
            }
        case .horizontal:
            HSplitView {
                splitView
            }
        }
    }

    var splitView: some View {
        ForEach(Array(data.tabgroups.enumerated()), id: \.offset) { index, item in
            WorkspaceEditorView(tabgroup: item)
                .environment(\.splitEditor) { edge, newTabGroup in
                    data.split(edge, at: index, new: newTabGroup)
                }
        }
    }
}
