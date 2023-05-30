//
//  CommandPaletteItem.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 31/05/2023.
//

import SwiftUI

protocol CommandPaletteItem: View {
    var title: String { get }
    var textToMatch: String { get }
    func createHighlightText() -> Text
}

extension CommandPaletteItem {
    func createHighlightText() -> Text {
        let range = title.range(of: textToMatch, options: .caseInsensitive)

        guard let range else {
            return Text(title)
        }

        return Text(title[..<range.lowerBound]) +
        Text(title[range]).fontWeight(.bold) +
        Text(title[range.upperBound...])
    }
}
