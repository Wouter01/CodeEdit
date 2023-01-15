//
//  FolderFileDocument.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/01/2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

final class ReferenceWorkspaceFileDocument: ReferenceFileDocument {

    static var readableContentTypes: [UTType] = [.folder]

    var baseRoot: FileWrapper

    init() {
        fatalError("Cannot create temporary folder yet.")
    }

    init(configuration: ReadConfiguration) throws {
        baseRoot = configuration.file
    }

    func snapshot(contentType: UTType) throws -> FileWrapper {
        print("Taking snapshot...")
        return baseRoot
    }

    func fileWrapper(snapshot: FileWrapper, configuration: WriteConfiguration) throws -> FileWrapper {
        return snapshot
    }
}
