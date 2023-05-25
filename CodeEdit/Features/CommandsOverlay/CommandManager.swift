//
//  CommandManager.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

final class CommandManager: ObservableObject {
    static var shared = CommandManager()

    var commands: Set<CommandData> = []
    var menus: Set<MenuData> = []

    init() {

    }

    func registerCommand(_ data: CommandData) {
        commands.update(with: data)
    }

    func registerMenu(_ data: MenuData) {
        menus.update(with: data)
        print(menus)
    }
}
