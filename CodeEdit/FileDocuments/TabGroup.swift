//
//  TabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import Foundation
import OrderedCollections

final class ReferenceTabGroup: ObservableObject {
    @Published var files: OrderedSet<DataFile> = []
    @Published var selected: DataFile?

    @Published var child: Child?

    init(files: OrderedSet<DataFile> = [], selected: DataFile? = nil, child: Child? = nil) {
        self.files = files
        self.selected = selected
        self.child = child
    }

    enum Child {
        case top(ReferenceTabGroup)
        case bottom(ReferenceTabGroup)
        case leading(ReferenceTabGroup)
        case trailing(ReferenceTabGroup)
//        case vertical(ReferenceTabGroup)
//        case horizontal(ReferenceTabGroup)
    }

    static func one(files: OrderedSet<DataFile> = [], selected: DataFile? = nil) -> ReferenceTabGroup {
        .init(files: files, selected: selected)
    }
}
