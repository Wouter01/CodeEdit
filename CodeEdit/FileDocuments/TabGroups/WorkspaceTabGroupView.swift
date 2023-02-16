//
//  WorkspaceTabGroupView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 16/02/2023.
//

import SwiftUI

struct WorkspaceTabGroupView: View {
    @ObservedObject var tabgroup: TabGroupData

    var body: some View {
        Group {
            if let selected = tabgroup.selected {
                WorkspaceFileEditor(file: selected)
            } else {
                VStack {
                    Spacer()
                    Text("Select a file.")
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all)
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                TabBarView()
                    .environmentObject(tabgroup)
                Divider()
            }
            .background(EffectView(.titlebar, blendingMode: .withinWindow, emphasized: false))
        }
    }
}
