//
//  CommandMenu.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

struct CommandMenu<Content: View>: View {
    var menu: CommandID

    var content: () -> Content

    init(_ menu: CommandID, @ViewBuilder content: @escaping () -> Content) {
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

                        Menu(menu.menubarTitle) {
                            menubarChildren
                        }
                        .task {
                            let mappedChildren = commandPaletteChildren.compactMap {
                                var data = $0[MenuChildCommandData.self]
                                data?.view = $0
                                return data
                            }
                            CommandManager.shared.registerMenu(
                                MenuData(id: menu, children: mappedChildren)
                            )
                        }
                    }
            }
    }
}
