//
//  TabGroupData.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 16/02/2023.
//

import Foundation
import OrderedCollections

final class TabGroupData: ObservableObject {
    @Published var files: OrderedSet<DataFile> = []
    @Published var selected: DataFile?

    init(files: OrderedSet<DataFile> = [], selected: DataFile? = nil) {
        self.files = files
        self.selected = selected
    }
}
