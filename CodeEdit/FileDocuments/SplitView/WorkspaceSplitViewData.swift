//
//  WorkspaceSplitViewData.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 16/02/2023.
//

import SwiftUI

class WorkspaceSplitViewData: ObservableObject {
    @Published var tabgroups: [TabGroup]

    var direction: Direction

    init(_ direction: Direction, tabgroups: [TabGroup] = []) {
        self.tabgroups = tabgroups
        self.direction = direction
    }

    // Splits the editor at a certain index into two separate editors.
    func split(_ direction: Edge, at index: Int, new tabgroup: TabGroupData) {
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
