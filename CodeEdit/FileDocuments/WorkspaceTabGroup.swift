//
//  WorkspaceTabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import SwiftUI

class WorkspaceSplitViewData: ObservableObject {
    @Published var tabgroups: [TabGroup]

    var direction: Direction

    let uuid = UUID()

    init(_ direction: Direction, tabgroups: [TabGroup] = []) {
        self.tabgroups = tabgroups
        self.direction = direction
    }

    func split(_ direction: Edge, at index: Int, new tabgroup: ReferenceTabGroup) {
        switch (self.direction, direction) {
        case (.horizontal, .trailing), (.vertical, .bottom):
            tabgroups.insert(.one(tabgroup), at: index+1)

        case (.horizontal, .leading), (.vertical, .top):
            tabgroups.insert(.one(tabgroup), at: index)

        case (.horizontal, .top):
            tabgroups[index] = .vertical(.init(.vertical, tabgroups: [.one(tabgroup), tabgroups[index]]))

        case (.horizontal, .bottom):
            tabgroups[index] = .vertical(.init(.vertical, tabgroups: [tabgroups[index], .one(tabgroup)]))

        case (.vertical, .leading):
            tabgroups[index] = .horizontal(.init(.horizontal, tabgroups: [.one(tabgroup), tabgroups[index]]))

        case (.vertical, .trailing):
            tabgroups[index] = .horizontal(.init(.horizontal, tabgroups: [tabgroups[index], .one(tabgroup)]))
        }
    }

    enum Direction {
        case horizontal, vertical
    }
}

struct SplitEditorEnvironmentKey: EnvironmentKey {
    static var defaultValue: (Edge, ReferenceTabGroup) -> Void = { _, _ in }
}

extension EnvironmentValues {
    var splitEditor: SplitEditorEnvironmentKey.Value {
        get { self[SplitEditorEnvironmentKey.self] }
        set { self[SplitEditorEnvironmentKey.self] = newValue }
    }
}

struct WorkspaceEditorAltView: View {
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
        ForEach(Array(data.tabgroups.enumerated()), id: \.element.id) { index, item in
            WorkspaceEditorAltView(tabgroup: item)
                .environment(\.splitEditor) { edge, newTabGroup in
                    data.split(edge, at: index, new: newTabGroup)
                }
        }
    }
}

struct WorkspaceTabGroupView: View {
    @ObservedObject var tabgroup: ReferenceTabGroup

    var body: some View {
        let _ = Self._printChanges()
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
        .ignoresSafeArea(.all)
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                TabBarView()
                    .environmentObject(tabgroup)
                Divider()
            }
            .background(EffectView(.titlebar, blendingMode: .withinWindow, emphasized: false))
        }
    }
}
