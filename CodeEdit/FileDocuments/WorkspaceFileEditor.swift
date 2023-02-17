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

    var body: some View {
        VStack {
            if !file.contents.isEmpty {
//                TextEditor(text: $file.contents)
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
            } else {
                Spacer()
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Opening \(file.fileName)...")
                        .task(id: file.id) {
                            print("Loading file \(file.id)")
                            try? file.readFile()
                        }
                }
                Spacer()
            }
        }

    }
}
