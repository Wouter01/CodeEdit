//
//  OverlayWindow.swift
//  CodeEdit
//
//  Created by Khan Winter on 3/17/23.
//

import Foundation
import SwiftUI

struct OverlayView<RowView: View, PreviewView: View, Option: Identifiable & Hashable>: View {
    @State var selection: Option?
    @State var previewVisible: Bool = true

    let title: String
    let image: Image
    var options: [Option]
    @Binding var text: String
    let content: ((Option, Bool) -> RowView)
    let preview: ((Option) -> PreviewView)?

    let onRowClick: ((Option) -> Void)
    let onClose: (() -> Void)
    let alwaysShowOptions: Bool
    let optionRowHeight: CGFloat

    init(
        title: String,
        image: Image,
        options: [Option],
        text: Binding<String>,
        alwaysShowOptions: Bool = false,
        optionRowHeight: CGFloat = 30,
        content: @escaping ((Option, Bool) -> RowView),
        preview: ((Option) -> PreviewView)? = nil,
        onRowClick: @escaping ((Option) -> Void),
        onClose: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.options = options
        self._text = text
        self.content = content
        self.preview = preview
        self.onRowClick = onRowClick
        self.onClose = onClose
        self.alwaysShowOptions = alwaysShowOptions
        self.optionRowHeight = optionRowHeight
    }

    var hasPreview: Bool {
        preview != nil
    }

    private enum Focus {
        case list, preview
    }

    @FocusState private var focusState: Focus?

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    image
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .padding(.leading, 1)
                        .padding(.trailing, 10)
                    OverlayTextView(placeholder: title, text: $text) { event in
                        switch (event.key, event.modifiers) {
                        case (.escape, []):
                            onClose()
                            return .drop
                        case (.return, []), (.upArrow, _), (.downArrow, _):
                            return .passthrough
                        default:
                            return .sendToTextView
                        }
                    }
                    .frame(height: 22)
                    .task(id: options) {
                        if options.isEmpty {
                            selection = nil
                        } else {
                            if !options.isEmpty {
                                selection = options.first
                            }
                        }
                    }
                    if hasPreview {
                        PreviewToggle(previewVisible: $previewVisible)
                            .onTapGesture {
                                withAnimation {
                                    previewVisible.toggle()
                                }
                            }
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .foregroundColor(.primary.opacity(0.85))
                .background(EffectView(.sidebar, blendingMode: .behindWindow))
            }
            if !text.isEmpty || alwaysShowOptions == true {
                Divider()
                    .padding(0)
                HStack(spacing: 0) {
                    if options.isEmpty {
                        Text("No matching options")
                            .font(.system(size: 17))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: hasPreview ? 272 : .infinity, maxHeight: .infinity)
                    } else {
                        List(selection: $selection) {
                            ForEach(options, id: \.self) { option in
                                content(option, true)
                            }
                        }
                        .focused($focusState, equals: .list)
                        .frame(maxWidth: hasPreview && previewVisible ? 272 : .infinity)
                        .contextMenu(forSelectionType: Option.self) { _ in
                            EmptyView()
                        } primaryAction: { selection in
                            if let selection = selection.first {
                                onRowClick(selection)
                            } else {
                                NSSound.beep()
                            }
                        }

                    }
                    if hasPreview && previewVisible {
                        Divider()
                        if options.isEmpty {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        } else {
                            if let selection, let preview {
                                preview(selection)
                                    .focused($focusState, equals: .preview)
                                    .frame(maxWidth: .infinity)
                                    .transition(.move(edge: .trailing))
                            } else {
                                Text("Select an option to preview")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
        }
        .defaultFocus($focusState, .list)
        .onChange(of: options) { _ in
            focusState = .list
        }
        .background(EffectView(.sidebar, blendingMode: .behindWindow))
        .edgesIgnoringSafeArea(.vertical)
        .frame(
            minWidth: 680,
            minHeight: text.isEmpty && !alwaysShowOptions ? 19 : 400,
            maxHeight: text.isEmpty && !alwaysShowOptions ? 19 : .infinity
        )
    }

}

struct PreviewToggle: View {
    @Binding var previewVisible: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(NSColor.secondaryLabelColor))
                .frame(width: previewVisible ? 12 : 14, height: 1)
                .offset(CGSize(width: 0, height: -2.5))
            if !previewVisible {
                Rectangle()
                    .fill(Color(NSColor.secondaryLabelColor))
                    .frame(width: 1, height: 8)
                    .offset(CGSize(width: -2.5, height: 2))
            }
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .strokeBorder(Color(NSColor.secondaryLabelColor), lineWidth: 1)
                .frame(width: previewVisible ? 14 : 16, height: 14)
        }
        .frame(width: 16, height: 16)
        .padding(4)
        .contentShape(Rectangle())
    }
}
