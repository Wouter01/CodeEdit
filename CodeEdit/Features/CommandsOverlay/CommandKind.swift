//
//  CommandKind.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 31/05/2023.
//

import SwiftUI

enum CommandKind {
    case button(action: () -> Void)
    case toggle(isOn: Binding<Bool>)
}
