//
//  TabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import Foundation
import OrderedCollections

indirect enum TabGroup: Identifiable {
    case one(ReferenceTabGroup)
    case vertical(WorkspaceSplitViewData)
    case horizontal(WorkspaceSplitViewData)

    var id: UUID {
        switch self {
        case .one(let referenceTabGroup):
            return referenceTabGroup.uuid
        case .vertical(let workspaceSplitViewData):
            return workspaceSplitViewData.uuid
        case .horizontal(let workspaceSplitViewData):
            return workspaceSplitViewData.uuid
        }
    }
}

final class ReferenceTabGroup: ObservableObject {
    @Published var files: OrderedSet<DataFile> = []
    @Published var selected: DataFile?

    let uuid = UUID()

    init(files: OrderedSet<DataFile> = [], selected: DataFile? = nil) {
        self.files = files
        self.selected = selected
    }
}
