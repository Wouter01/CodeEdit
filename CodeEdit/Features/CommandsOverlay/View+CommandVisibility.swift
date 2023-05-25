//
//  View+CommandVisibility.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

struct CommandVisibility: EnvironmentKey {
    static var defaultValue: CommandData.Visibility = [.commandPalette, .menubar]
}

extension EnvironmentValues {
    var commandVisibility: CommandVisibility.Value {
        get { self[CommandVisibility.self] }
        set { self[CommandVisibility.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    func visibility(_ visibility: CommandData.Visibility) -> some View {
        if visibility.contains(.menubar) {
            environment(\.commandVisibility, visibility)
        } else {
            environment(\.commandVisibility, visibility)
                .hidden()
        }
    }
}
