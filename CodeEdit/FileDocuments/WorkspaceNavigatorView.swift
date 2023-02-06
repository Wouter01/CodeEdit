//
//  WorkspaceNavigatorView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import OutlineView

//class FileItemView: NSTextField {
//    
//    init(fileItem: File) {
//        super.ini
//        super.init(string: fileItem.fileName)
//        isEditable = true
//        isSelectable = true
//        field.isEditable = true
//        field.isSelectable = true
//        field.isBezeled = false
//        field.drawsBackground = false
//        field.usesSingleLineMode = false
//        field.cell?.wraps = true
//        field.cell?.isScrollable = false
////        field.preferredMaxLayoutWidth = 20
////        super.init(frame: .zero)
//
//        addSubview(field)
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        NSLayoutConstraint.activate([
//            field.leadingAnchor.constraint(equalTo: leadingAnchor),
//            field.trailingAnchor.constraint(equalTo: trailingAnchor),
//            field.topAnchor.constraint(equalTo: topAnchor, constant: 4),
//            field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

struct FolderFileTree: View {
    @ObservedObject var model: FolderFile
    @State var expanded = false
    var body: some View {
        DisclosureGroup(isExpanded: $expanded) {
            Group {
                ForEach(model.children, id: \.self) {
                    FileTreeView(item: $0, canShowChildren: expanded)
                }
            }
        } label: {
            Text(model.fileName)
        }
    }
    func createNewFolder() -> FileWrapper {
        let fw = FileWrapper(directoryWithFileWrappers: [:])
        fw.filename = "fyjtgukjhlgkfjhcj"
        fw.preferredFilename = "vfhjbknlbvgchjfxhcgvhbk"
        return fw
    }
}

struct FileTreeView: View {
    @State var expanded = false
    var item: File
    var canShowChildren: Bool = true
    var body: some View {
        Group {
            switch item {
            case .file(let dataFile):
                HStack {
                    Image(systemName: FileIcon.fileIcon(fileType: dataFile.fileType))
                    Text(dataFile.fileName)
                }
                .frame(height: 15)
            case .folder(let folderFile) where !canShowChildren:
                DisclosureGroup(folderFile.fileName) {
                    Text("")
                }
            case .folder(let folderFile):
                FolderFileTree(model: folderFile)
            case .symlink(let symlinkFile):
                Text(symlinkFile.fileName)
            }
        }
        .id(item.id)
    }
}

struct NavigatorView: View {

    @Binding var currentOpen: File?

    @State var selectedItems: Set<File> = []

    @State private var selection: Navigator = .project

    @EnvironmentObject private var files: WorkspaceFiles

    @State var navSelection: File?
    @State var contextMenuSelection: File?

    @SceneStorage("SelectionState") var selectionScene: File.ID?

    var body: some View {

        VStack {
            switch selection {
            case .project:
                // Implementation 1
//                OutlineView([files.root], children: \.children, selection: $currentOpen) { item in
//                    OutlineTableViewCell(frame: .init(origin: .zero, size: .init(width: 0, height: 22)), item: item, isEditable: true, delegate: nil)
//                }
//                .dragDataSource { item in
//                    let pasteboardItem = NSPasteboardItem()
//                    pasteboardItem.setData(item.url.dataRepresentation, forType: .fileURL)
//                    return pasteboardItem
//                }
//                .onDrop(of: [.fileURL], receiver: MyDropReceiver())

                // Implementation 2
                List(selection: $selectedItems) {
                    FileTreeView(item: files.root)
                }
                .environment(\.defaultMinListRowHeight, 15)

                // Implementation 3
//                Outline2View()
            case .sourceControl:
                SourceControlNavigatorView()

            case .search:
                Text("Search")
            }
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .top, alignment: .center, spacing: 0) {
            VStack {
                Divider()
                NavigatorPicker(selection: $selection)
                Divider()
            }
        }
    }
}

class MyDropReceiver: DropReceiver {
    
    typealias DataElement = File

    func readPasteboard(item: NSPasteboardItem) -> DraggedItem<DataElement>? {
        guard let pasteboardType = item.availableType(from: [.fileURL]) else { return nil }

        switch pasteboardType {
        case .fileURL:
//            if let draggedUrlString = item.string(forType: .fileURL),
//               draggedUrl = URL(string: draggedUrlString)
//            {
////                let newFileItem = File.file(<#T##DataFile#>)/* instance of OutlineView.Data.Element from draggedUrl */
////                return (newFileItem, .fileUrl)
//                return nil
//            } else {
//                return nil
//            }
            return nil
        default:
            return nil
        }
    }

    func validateDrop(target: DropTarget<DataElement>) -> ValidationResult<DataElement> {
//        let draggedItems = target.draggedItems
        print(target)
        if target.childIndex != nil {
            return .deny
        }
        switch target.intoElement {
        case .file, .symlink, .none:
            return .deny
        case .folder:
            return .move
        }
    }

    func acceptDrop(target: DropTarget<DataElement>) -> Bool {
        // update data source to reflect that drop was successful or not
        return true
    }
}
