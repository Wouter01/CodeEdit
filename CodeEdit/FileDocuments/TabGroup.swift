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
        case vertical(ReferenceTabGroup)
        case horizontal(ReferenceTabGroup)
    }

    static func one(files: OrderedSet<DataFile> = [], selected: DataFile? = nil) -> ReferenceTabGroup {
        .init(files: files, selected: selected)
    }
}

indirect enum TabGroup {
    case one(TabGroupData)
    case vertical(TabGroupData, TabGroup)
    case horizontal(TabGroupData, TabGroup)

    var data: TabGroupData {
        switch self {
        case .one(let data):
            return data
        case .vertical(let data, _):
            return data
        case .horizontal(let data, _):
            return data
        }
    }

    func addTab(for file: DataFile) {
        switch self {
        case .one(let data):
            data.files.append(file)
        case .horizontal(let data, _):
            data.files.append(file)
        case .vertical(let data, _):
            data.files.append(file)
        }
    }
}

class TabGroupData: ObservableObject {
    @Published var files: OrderedSet<DataFile> = []
    @Published var selected: DataFile?
}
