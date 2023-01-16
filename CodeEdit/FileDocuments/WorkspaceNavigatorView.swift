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

    @State var navSelection: File?
    @State var contextMenuSelection: File?

    @SceneStorage("SelectionState") var selectionScene: File.ID?

//    init(currentOpen: Binding<File?>) {
//        self._currentOpen = currentOpen
//        self._selectionScene = .init("SelectionState")
//        if let selectionScene {
//            self.navSelection = files.searchFile(with: selectionScene)
//        }
//    }

    var body: some View {

        VStack {
            switch selection {
            case .project:
                OutlineView()
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

extension OutlineViewController {

    func contextMenu() {
        outlineView.menu = .init(title: "Hello")
        outlineView.menu?.items.append(.init(title: "HEllo", action: nil, keyEquivalent: ""))
    }
}

//public extension OutlineView {
//
//    /// Sets the style for the `OutlineView`.
//    @available(macOS 11.0, *)
//    func contentMenu(_ style: NSOutlineView.Style) -> Self {
//        var mutableSelf = self
//        mutableSelf.
//        return mutableSelf
//    }
//}
