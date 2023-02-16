//
//  OutlintViewController+OutlineTableViewCellDelegate.swift
//  CodeEdit
//
//  Created by Ziyuan Zhao on 2023/2/5.
//

import Foundation

// MARK: - OutlineTableViewCellDelegate

extension OutlineViewController: OutlineTableViewCellDelegate {
    func moveFile(file: Item, to destination: URL) {
//        if case .file(let datafile) = file {
//            workspace2.tabs.closeAllTabs(of: datafile)
//        }
//        if !file.isFolder {
//            workspace?.closeTab(item: .codeEditor(file.id))
//        }
//        file.move(to: destination)
//        if !file.isFolder {
//            workspace?.openTab(item: file)
//        }
        // TODO: Fix this
    }

    func copyFile(file: Item, to destination: URL) {
//        file.duplicate(to: destination)
        // TODO: Fix this
    }
}
