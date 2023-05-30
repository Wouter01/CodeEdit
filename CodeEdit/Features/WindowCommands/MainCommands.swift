//
//  MainCommands.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 13/03/2023.
//

import SwiftUI
import Sparkle

struct MainCommands: Commands {

    @Environment(\.openWindow) var openWindow

    @State var isOn: Bool = false

    @ObservedObject private var themeModel: ThemeModel = .shared

    @ObservedObject var commandManager: CommandManager = .shared

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {

            Command(.aboutCodeEdit) {
                openWindow(id: SceneID.about.rawValue)
            }

            Command(.checkForUpdates) {
                NSApp.sendAction(#selector(SPUStandardUpdaterController.checkForUpdates(_:)), to: nil, from: nil)
            }

            Command(.testBoth) {
                openWindow(id: SceneID.about.rawValue)
            }
            .keyboardShortcut("a", modifiers: [.command, .control, .option, .shift])

            Command(.testOnlyMenubar) {
                openWindow(id: SceneID.about.rawValue)
            }
            .visibility(.menubar)
            .keyboardShortcut("b", modifiers: [.command, .control, .option, .shift])

            Command(.testOnlyPalette) {
                openWindow(id: SceneID.about.rawValue)
            }
            .visibility(.commandPalette)
            .keyboardShortcut("c", modifiers: [.command, .control, .option, .shift])

            Command(.testToggle, isOn: $isOn)

            CommandMenu(.themes) {
                ForEach(themeModel.lightThemes, id: \.id) { theme in
                    Command(.init(id: "theme\(theme.id)", title: theme.displayName)) {
                        themeModel.selectedLightTheme = theme
                    } altContent: {
                        ThemeSettingsThemeRow(theme: .constant(theme), active: themeModel.selectedLightTheme == theme) {
                            themeModel.selectedLightTheme = $0
                        }
                        .onHover { _ in
                            print("Set to theme 1")
                        }
                    }
                }
            }
        }

        CommandGroup(replacing: .appSettings) {
            Command(.settings) {
                openWindow(id: "settings")
            }
            .keyboardShortcut(",")
        }
    }
}
