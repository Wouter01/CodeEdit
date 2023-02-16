//
//  WorkspaceTabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import SwiftUI

struct WorkspaceEditorView: View {
    var tabgroup: TabGroup

    var body: some View {
        switch tabgroup {
        case .one(let detailTabGroup):
            WorkspaceTabGroupView(tabgroup: detailTabGroup)
        case .vertical(let data), .horizontal(let data):
            SplitEditorView(data: data)
        }
    }
}
