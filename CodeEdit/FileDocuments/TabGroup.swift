//
//  TabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import Foundation
import OrderedCollections

indirect enum TabGroup {
    case one(ReferenceTabGroup)
    case vertical(WorkspaceSplitViewData)
    case horizontal(WorkspaceSplitViewData)
}

final class ReferenceTabGroup: ObservableObject {
    @Published var files: OrderedSet<DataFile> = []
    @Published var selected: DataFile?

    init(files: OrderedSet<DataFile> = [], selected: DataFile? = nil) {
        self.files = files
        self.selected = selected
    }
}
