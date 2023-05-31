//
//  Command+Environment.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

struct MenuEnvironmentKey: EnvironmentKey {
    static var defaultValue: CommandID?
}

struct CurrentViewEnvironmentKey: EnvironmentKey {
    static var defaultValue: CommandLocation = .menubar
}

extension EnvironmentValues {
    var commandMenu: MenuEnvironmentKey.Value {
        get { self[MenuEnvironmentKey.self] }
        set { self[MenuEnvironmentKey.self] = newValue }
    }

    var currentView: CurrentViewEnvironmentKey.Value {
        get { self[CurrentViewEnvironmentKey.self] }
        set { self[CurrentViewEnvironmentKey.self] = newValue }
    }
}

struct MenuChildTraitKey: _ViewTraitKey {
    static var defaultValue: CommandID?
}

struct MenuChildCommandData: _ViewTraitKey {
    static var defaultValue: CommandData?
}
