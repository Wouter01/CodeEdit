//
//  OverlayTextView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 30/05/2023.
//

import SwiftUI
import Combine

extension KeyEquivalent: Equatable {
    public static func == (lhs: KeyEquivalent, rhs: KeyEquivalent) -> Bool {
        lhs.character == rhs.character
    }
}

struct OverlayTextView: NSViewRepresentable {

    let placeholder: String?

    var font: NSFont = .systemFont(ofSize: 20, weight: .light)
    @Binding var text: String
    let filterKeyEvents: (KeyboardShortcut) -> FilterOption

    typealias NSViewType = MyTextField

    enum FilterOption {
        case sendToTextView, drop, passthrough
    }

    func makeNSView(context: Context) -> NSViewType {
        let textfield = MyTextField()
        textfield.textContainer?.maximumNumberOfLines = 1
        textfield.textContainer?.replaceLayoutManager(LayoutManager())
        textfield.font = font
        textfield.backgroundColor = .clear
        textfield.placeholderString = placeholder
        textfield.text = $text

        Task {
            let old = textfield.window?.firstResponder
            textfield.window?.makeFirstResponder(textfield)
            textfield.window?.makeFirstResponder(old)
        }

        context.coordinator.keywindowWatcher = NSApp.publisher(for: \.keyWindow).sink {
            if $0 == textfield.window && $0 != nil {
                context.coordinator.monitor = createMonitor(textfield)
            } else if let monitor = context.coordinator.monitor {
                NSEvent.removeMonitor(monitor)
                context.coordinator.monitor = nil

            }
        }

        return textfield
    }

    func updateNSView(_ textfield: NSViewType, context: Context) {
        if textfield.placeholderString != placeholder {
            textfield.placeholderString = placeholder
            Task {
                let old = textfield.window?.firstResponder
                textfield.window?.makeFirstResponder(textfield)
                textfield.window?.makeFirstResponder(old)
            }
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {

        fileprivate var monitor: Any?

        var keywindowWatcher: AnyCancellable?

        deinit {
            if let monitor {
                NSEvent.removeMonitor(monitor)
            }
        }
    }

        private func createMonitor(_ textview: MyTextField) -> Any? {
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
                let shortcut = KeyboardShortcut(
                    KeyEquivalent(Character(event.characters!)),
                    modifiers: EventModifiers(event.modifierFlags)
                )

                switch shortcut {
                case .init("a"):
                    textview.selectAll(nil)
                    return nil
                case .init("c"):
                    textview.copy(nil)
                    return nil
                case .init("x"):
                    textview.cut(nil)
                    return nil
                case .init("v"):
                    textview.paste(nil)
                    return nil
                default:
                    break
                }

                switch filterKeyEvents(shortcut) {
                case .drop:
                    return nil
                case .passthrough:
                    return event
                case .sendToTextView:
                    if let window = textview.window {
                        let old = window.firstResponder
                        window.makeFirstResponder(textview)
                        textview.interpretKeyEvents([event])
                        window.makeFirstResponder(old)
                        return nil
                    }
                    return event
                }
            }

    }

    private final class LayoutManager: NSLayoutManager {
        override func fillBackgroundRectArray(
            _ rectArray: UnsafePointer<NSRect>,
            count rectCount: Int,
            forCharacterRange charRange: NSRange,
            color: NSColor
        ) {
            let color1 = NSColor.selectedTextBackgroundColor
            color1.setFill()
            super.fillBackgroundRectArray(
                rectArray,
                count: rectCount,
                forCharacterRange: charRange,
                color: .selectedTextBackgroundColor
            )
            color.setFill()
        }
    }

    final class MyTextField: NSTextView {

        @objc var placeholderString: String?

        var text: Binding<String>?

        override var acceptsFirstResponder: Bool {
            false
        }

        override func becomeFirstResponder() -> Bool {
            let oldResponder = window?.firstResponder
            super.becomeFirstResponder()
            window?.makeFirstResponder(oldResponder)
            return true
        }

        override func resignFirstResponder() -> Bool {
            true
        }

        override func didChangeText() {
            self.text?.wrappedValue = self.string
        }
    }
}
