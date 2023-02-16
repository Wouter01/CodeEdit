//
//  BreadcrumbsView.swift
//  CodeEditModules/Breadcrumbs
//
//  Created by Lukas Pistrol on 17.03.22.
//

import SwiftUI

struct BreadcrumbsView: View {

    private let file: File
    private let tappedOpenFile: (File) -> Void

    @Environment(\.colorScheme)
    private var colorScheme

    @Environment(\.controlActiveState)
    private var activeState

    init(
        file: File,
        tappedOpenFile: @escaping (File) -> Void
    ) {
        self.file = file
        self.tappedOpenFile = tappedOpenFile
    }

    var fileItems: [File] {
        var treePath: [File] = [file]

        while true {
            let parent = treePath.first?.parent
            switch parent {
            case .child(let parent):
                treePath.insert(.folder(parent), at: 0)
            case .root, .none:
                return treePath
            }
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 1.5) {
                ForEach(fileItems, id: \.self) { fileItem in
                    if case .child = fileItem.parent {
                        chevron
                    }
                    BreadcrumbsComponent(fileItem: fileItem, tappedOpenFile: tappedOpenFile)
                        .padding(.leading, 2.5)
                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 28, alignment: .center)
        .background(EffectView(.headerView).frame(height: 28))
//        .onAppear {
//            fileInfo(self.file)
//        }
//        .onChange(of: file) { newFile in
//            fileInfo(newFile)
//        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.compact.right")
            .font(.system(size: 14, weight: .thin, design: .default))
            .foregroundStyle(.primary)
            .scaleEffect(x: 1.30, y: 1.0, anchor: .center)
            .imageScale(.large)
            .opacity(activeState != .inactive ? 0.8 : 0.5)
    }

//    private func fileInfo(_ file: WorkspaceClient.FileItem) {
//        fileItems = []
//        var currentFile: WorkspaceClient.FileItem? = file
//        while let currentFileLoop = currentFile {
//            fileItems.insert(currentFileLoop, at: 0)
//            currentFile = currentFileLoop.parent
//        }
//    }
}
