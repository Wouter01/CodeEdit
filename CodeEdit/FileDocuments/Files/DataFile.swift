//
//  DataFile.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import Combine

class DataFile: ObservableObject, Identifiable {
    var fileWrapper: FileWrapper

    @Published
    var contents: String = ""

    private var fileUpdaterCancellable: AnyCancellable?

    var parent: FileType

    init(fileWrapper: FileWrapper, parent: FileType) {
        guard fileWrapper.isRegularFile else {
            fatalError("Provided filewrapper is not a file, but a folder/symlink. \(fileWrapper.filename ?? "Unknown")")
        }
        self.fileWrapper = fileWrapper
        self.parent = parent


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

    var fileType: FileIcon.FileType? {
        guard let type = fileName.split(separator: ".").last else { return nil }
        return .init(rawValue: String(type))
    }

    var id: URL { url }

    func readFile() throws {
        guard let data = fileWrapper.regularFileContents else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        guard let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadUnknownStringEncoding)
        }
        self.contents = string

        // Cancellable can only be activated when contents have been read,
        // and only one cancellable may be active at a time.
        if fileUpdaterCancellable == nil {
            fileUpdaterCancellable = self.$contents
                .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true)
                .sink { [self] res in
                    // strong self reference is needed,
                    // so the latest changes aren't discarded when the object would be deallocated
                    try? self.updateFile()
                }
        }
    }

    func updateFile() throws {
        guard let data = contents.data(using: .utf8) else {
            fatalError("Datafile wanted to update but contents is nil")
        }

        let newFileWrapper = FileWrapper(regularFileWithContents: data)
        newFileWrapper.preferredFilename = fileWrapper.filename
        newFileWrapper.filename = fileWrapper.filename
        newFileWrapper.fileAttributes = fileWrapper.fileAttributes
        newFileWrapper.icon = fileWrapper.icon

        switch parent {
        case .child(let parent):
            parent.fileWrapper.removeFileWrapper(fileWrapper)
            parent.fileWrapper.addFileWrapper(newFileWrapper)
        case .root(let url):
            fatalError("Not yet implemented")
        }

        fileWrapper = newFileWrapper
    }

    var systemImage: String {
        FileIcon.fileIcon(fileType: fileType)
    }

    var iconColor: Color {
        FileIcon.iconColor(fileType: fileType)
    }
}

extension DataFile: Equatable, Hashable {
    static func == (lhs: DataFile, rhs: DataFile) -> Bool {
        lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
