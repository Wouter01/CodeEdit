//
//  WelcomeWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 01/02/2023.
//

import SwiftUI
import Defaults
import WindowManagement

struct WelcomeWindow: Scene {
    
    var body: some Scene {
        Window("Welcome Window", id: "WelcomeWindow") {
            WelcomeWindowMainView()
                .handlesExternalEvents(preferring: ["WelcomeWindow"], allowing: ["WelcomeWindow"])
            .edgesIgnoringSafeArea(.all)
            .frame(height: 460)
            .fixedSize()
            .injectWindow("WelcomeWindow")
        }
        .register("WelcomeWindow")
        .movableByBackground(true)
        .styleMask([.fullSizeContentView])
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

struct WelcomeWindowMainView: View {
    @Environment(\.openDocument) var openDocument
    @Environment(\.newDocument) var newDocument
    @Environment(\.window) var window

    var body: some View {
        WelcomeWindowView(
            shellClient: currentWorld.shellClient,
            openDocument: { url, opened in
                if let url {
                    Task {
                        try? await NSDocumentController.shared.openDocument(withContentsOf: url, display: true)
                        window.close()
                    }
                }
            },
            newDocument: {
                newDocument {
                    ReferenceWorkspaceFileDocument()
                }
                window.close()
            },
            dismissWindow: {
                window.close()
            }
        )
    }
}
