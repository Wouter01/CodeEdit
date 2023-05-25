//
//  IDs.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import Foundation

struct CommandID: Hashable {
    let id: String
    let title: String
}

extension CommandID {
    static let aboutCodeEdit = CommandID(id: "aboutCodeEdit", title: "About CodeEdit")
    static let checkForUpdates = CommandID(id: "checkForUpdates", title: "Check for updates...")
    static let testBoth = CommandID(id: "testBoth", title: "testboth")
    static let testOnlyMenubar = CommandID(id: "testOnlyMenubar", title: "testonlymenubar")
    static let testOnlyPalette = CommandID(id: "testOnlyPalette", title: "testOnlyPalette")
    static let testToggle = CommandID(id: "testToggle", title: "testToggle")

}

enum CommandMenuID: String {
    case themes = "Themes"
}
