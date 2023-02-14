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
                    cursorPosition: .none
                )
                .id(file.id)
            } else {
                VStack {}
                    .task(id: file.id) {
                        print("Loading file...")
                        try? file.readFile()
                    }
            }
//        }

        
//        .frame(width: 600, height: 600)
    }
}
