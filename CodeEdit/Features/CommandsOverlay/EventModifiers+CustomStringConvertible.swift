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
