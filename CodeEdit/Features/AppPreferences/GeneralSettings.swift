//
//  GeneralSettings.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 01/02/2023.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let restoreWorkspaces = Key<Set<URL>>("restoreWorkspaces", default: [])
}
