//
//  DataFile.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import Combine

class DataFile: ObservableObject, Identifiable {
    private var fileWrapper: FileWrapper

    @Published
    var contents: String = ""

    private var cancellables: Set<AnyCancellable> = []

    var parent: FileType

    init(fileWrapper: FileWrapper, parent: FileType) {
        guard fileWrapper.isRegularFile else {
            fatalError("Provided filewrapper is not a file, but a folder/symlink. \(fileWrapper.filename ?? "Unknown")")
        }
        self.fileWrapper = fileWrapper
        self.parent = parent

        self.$contents
            .dropFirst(10)
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in
                print("Updating filewrapper")
                try? self?.updateFile()
            }
            .store(in: &cancellables)
    }

    deinit {
        try? self.updateFile()
    }

    convenience init(fileWrapper: FileWrapper, parent: FolderFile) {
        self.init(fileWrapper: fileWrapper, parent: .child(parent: parent))
    }

    convenience init(fileWrapper: FileWrapper, root: URL) {
        self.init(fileWrapper: fileWrapper, parent: .root(url: root))
    }

    var icon: NSImage? {
        fileWrapper.icon
    }

    var url: URL {
        switch parent {
        case .child(let parent):
            return parent.url.appending(component: fileWrapper.filename!)
        case .root(let url):
            return url
        }
    }

    var fileName: String {
        fileWrapper.filename!
    }

    var id: URL { url }

    func readFile() throws {
        guard let data = fileWrapper.regularFileContents else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        guard let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadUnknownStringEncoding)
        }

        //        DispatchQueue.main.async {
        self.contents = string
        print("contents updated:", contents.count)
        //        }
    }

    func updateFile() throws {
        guard let data = contents.data(using: .utf8) else {
            fatalError("Datafile wanted to update but contents is nil")
        }
        let newFileWrapper = FileWrapper(regularFileWithContents: data)
        newFileWrapper.preferredFilename = fileWrapper.filename
        newFileWrapper.filename = fileWrapper.filename
        newFileWrapper.icon = fileWrapper.icon

        switch parent {
        case .child(let parent):
            try parent.updateChild(with: fileWrapper.filename!, replacement: newFileWrapper)
        case .root(let url):
            fatalError("Not yet implemented")
        }
    }
}
