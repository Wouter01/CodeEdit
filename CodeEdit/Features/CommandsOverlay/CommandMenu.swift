//
//  CommandMenu.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

struct CommandMenu<Content: View>: View {
    var menu: CommandMenuID

    var content: () -> Content

    init(_ menu: CommandMenuID, @ViewBuilder content: @escaping () -> Content) {
        self.menu = menu
        self.content = content
    }

    var body: some View {
        content()
            .environment(\.currentView, .commandpalette)
            .environment(\.commandMenu, menu)
            .variadic { commandPaletteChildren in

                content()
                    .environment(\.currentView, .menubar)
                    .environment(\.commandMenu, menu)
                    .variadic { menubarChildren in

                        Menu(menu.rawValue) {
                            menubarChildren
                        }
                        .task {
                            let mappedChildren = commandPaletteChildren.compactMap {
                                var data = $0[MenuChildCommandData.self]
                                data?.view = $0
                                return data
                            }
                            CommandManager.shared.registerMenu(
                                MenuData(id: menu.rawValue, children: mappedChildren)
                            )
                        }
                    }
            }
    }
}
