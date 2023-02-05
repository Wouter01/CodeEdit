//
//  Env+WorkspaceURL.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 05/02/2023.
//

import SwiftUI

private struct WorkspaceURLEnvironmentKey: EnvironmentKey {
    static let defaultValue: URL? = nil
}

extension EnvironmentValues {
    var workspaceURL: URL? {
        get { self[WorkspaceURLEnvironmentKey.self] }
        set { self[WorkspaceURLEnvironmentKey.self] = newValue }
    }
}
