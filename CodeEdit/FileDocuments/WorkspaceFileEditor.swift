//
//  WorkspaceFileEditor.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import CodeEditTextView

struct WorkspaceFileEditor: View {
    @ObservedObject var file: DataFile


    @ViewBuilder
    var body: some View {
        VStack {
            //        VStack {

            if !file.contents.isEmpty {
                CodeEditTextView(
                    $file.contents,
                    language: .swift,
                    theme: .constant(ThemeModel.shared.selectedTheme!.editor.editorTheme),
                    font: .constant(.systemFont(ofSize: 12)),
                    tabWidth: .constant(4),
                    lineHeight: .constant(1),
                    wrapLines: .constant(true),
                    cursorPosition: .none,
                    contentInsets: .some(.init(top: TabBarView.height, left: 0, bottom: 10, right: 0))
                )
                .id(file.id)
            }
        }
        .task(id: file.id) {
            print("Loading file...")
            try? file.readFile()
        }
                }
}
