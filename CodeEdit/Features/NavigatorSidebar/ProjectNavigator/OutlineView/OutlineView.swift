//
//  OutlineView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 05.04.22.
//

import SwiftUI
import Combine

/// Wraps an ``OutlineViewController`` inside a `NSViewControllerRepresentable`
struct Outline2View: NSViewControllerRepresentable {

//    @EnvironmentObject
//    var workspace: WorkspaceDocument

    @EnvironmentObject
    var workspace2: WorkspaceFiles

    @StateObject
    var prefs: AppPreferencesModel = .shared

    typealias NSViewControllerType = OutlineViewController

    func makeNSViewController(context: Context) -> OutlineViewController {
        let controller = OutlineViewController()
        controller.workspace2 = workspace2
        controller.iconColor = prefs.preferences.general.fileIconStyle

//        context.coordinator.controller = controller

        return controller
    }

    func updateNSViewController(_ nsViewController: OutlineViewController, context: Context) {
        nsViewController.iconColor = prefs.preferences.general.fileIconStyle
        nsViewController.rowHeight = prefs.preferences.general.projectNavigatorSize.rowHeight
        nsViewController.fileExtensionsVisibility = prefs.preferences.general.fileExtensionsVisibility
        nsViewController.shownFileExtensions = prefs.preferences.general.shownFileExtensions
        nsViewController.hiddenFileExtensions = prefs.preferences.general.hiddenFileExtensions
        nsViewController.updateSelection()
        return
    }

    func makeCoordinator() {
//        Coordinator(workspace)
    }

//    class Coordinator: NSObject {
//        init(_ workspace: WorkspaceDocument) {
//            self.workspace = workspace
//            super.init()
//
//            listener = workspace.listenerModel.$highlightedFileItem
//                .sink(receiveValue: { [weak self] fileItem in
//                guard let fileItem = fileItem else {
//                    return
//                }
//                self?.controller?.reveal(fileItem)
//            })
//        }
//
//        var listener: AnyCancellable?
//        var workspace: WorkspaceDocument
//        var controller: OutlineViewController?
//
//        deinit {
//            listener?.cancel()
//        }
//    }
}
