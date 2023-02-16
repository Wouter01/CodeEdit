//
//  TabGroup.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 06/02/2023.
//

import Foundation

enum TabGroup {
    case one(TabGroupData)
    case vertical(WorkspaceSplitViewData)
    case horizontal(WorkspaceSplitViewData)
}
