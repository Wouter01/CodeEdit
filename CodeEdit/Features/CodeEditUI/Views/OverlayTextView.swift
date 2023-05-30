//
//  OverlayTextView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 30/05/2023.
//

import SwiftUI

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
        textfield.textContainer?.replaceLayoutManager(LayoutManager1())
        textfield.font = font
        textfield.backgroundColor = .clear
        textfield.placeholderString = placeholder
        textfield.text = $text

        Task {
            let old = textfield.window?.firstResponder
            textfield.window?.makeFirstResponder(textfield)
            textfield.window?.makeFirstResponder(old)
        }

        return textfield
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {

        if context.environment.controlActiveState == .key && context.coordinator.monitor == nil {
            print("Adding monitor...")
            context.coordinator.monitor = createMonitor(nsView)
        } else if let monitor = context.coordinator.monitor, context.environment.controlActiveState != .key {
            print("Removing monitor...")
            NSEvent.removeMonitor(monitor)
            context.coordinator.monitor = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var monitor: Any?
    }

    func createMonitor(_ textview: MyTextField) -> Any? {
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

    private final class LayoutManager1: NSLayoutManager {
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
