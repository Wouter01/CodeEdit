//
//  EventModifiers+CustomStringConvertible.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 24/05/2023.
//

import SwiftUI

extension EventModifiers: CustomStringConvertible {
    public var description: String {
        var symbols: [String] = []

        if self.contains(.control) {
            symbols.append("⌃")
        }

        if self.contains(.option) {
            symbols.append("⌥")
        }

        if self.contains(.shift) {
            symbols.append("⇧")
        }

        if self.contains(.command) {
            symbols.append("⌘")
        }

        if self.contains(.function) {
            symbols.append("fn")
        }

        return symbols.joined()
    }
}

extension EventModifiers {
    init(_ nsEventModifiers: NSEvent.ModifierFlags) {
        let modifiers = nsEventModifiers.intersection(.deviceIndependentFlagsMask)
        self = []

        if modifiers.contains(.control) {
            self.insert(.control)
        }

        if modifiers.contains(.option) {
            self.insert(.option)
        }

        if modifiers.contains(.shift) {
            self.insert(.shift)
        }

        if modifiers.contains(.command) {
            self.insert(.command)
        }

        if modifiers.contains(.function) {
            self.insert(.function)
        }

        if modifiers.contains(.capsLock) {
            self.insert(.capsLock)
        }
    }
}
