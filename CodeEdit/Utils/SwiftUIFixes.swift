//
//  SwiftUIFixes.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 15/01/2023.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

// This will make the gray center bar have a reliable minimum and maximum size.
extension NSToolbar {

    @objc var itemsSwizzled: [NSToolbarItem] {
        return self.itemsSwizzled
            .map {
                if $0.itemIdentifier.rawValue == "CenterSection" {
                    $0.minSize = .init(width: 100, height: 25)
                    $0.maxSize = .init(width: 400, height: 25)
                }
                return $0
            }
    }

    static func swizzle() {
        swizzle(#selector (getter: items), #selector (getter: itemsSwizzled))
        NSObject.swizzleSwiftUIToolbar()
    }
}

// Bugfix for SwiftUI: SwiftUI will crash if multiple window toolbar sections have spacers.
// This is because SwiftUI injects too much splitview tracking separators when spacers are added.
// To fix this, dummy spacers defined in SwiftUI are replaced with default flexible space.
// Also, SwiftUI's default sidebar toggle is filtered out.
extension NSObject {
    @objc func defaultSwizzle(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        defaultSwizzle(toolbar)
            .replacing([.init("FakeSpacer")], with: [.flexibleSpace])
            .filter { $0.rawValue != "com.apple.SwiftUI.navigationSplitView.toggleSidebar" }
    }

    fileprivate static func swizzleSwiftUIToolbar() {
        let originalMethodSet = class_getInstanceMethod(NSClassFromString("SwiftUI.ToolbarPlatformDelegate"), #selector(NSToolbarDelegate.toolbarDefaultItemIdentifiers(_:)))
        let swizzledMethodSet = class_getInstanceMethod(self as AnyClass, #selector(defaultSwizzle))

        method_exchangeImplementations(originalMethodSet!, swizzledMethodSet!)
    }
}


// This will set the last column in a 3-column NavigationSplitView to an inspector state.
extension NSSplitViewController {

    @objc func setItemsSwizzled(_ newValue: [NSSplitViewItem]) {
        if newValue.count == 3, let inspector = newValue.last {
            inspector.minimumThickness = 150
            inspector.maximumThickness = 300
            inspector.allowsFullHeightLayout = true
            inspector.titlebarSeparatorStyle = .none
            inspector.canCollapse = true
            inspector.holdingPriority = newValue[0].holdingPriority
            inspector.isSpringLoaded = true
        }

        setItemsSwizzled(newValue)
    }

    static func swizzle() {
        swizzle(#selector (setter: NSSplitViewController.splitViewItems), #selector (NSSplitViewController.setItemsSwizzled))
    }
}

// This will fix a SwiftUI bug where the window toolbar has an incorrect color.
extension NSVisualEffectView {

    @objc func setMaterialSwizzled(_ newValue: Material) {
        if let superview = self.superview, superview.className == "NSTitlebarView" {
            if superview.subviews.map(\.className).filter { $0 == "NSVisualEffectView" }.count == 3 && superview.subviews.first == self {
                setMaterialSwizzled(.hudWindow)
                return
            }
        }
        setMaterialSwizzled(newValue)
    }

    static func swizzle() {
        swizzle(#selector(setter: material), #selector(setMaterialSwizzled))
    }

}

extension NSObject {
    static func swizzle(_ original: Selector, _ replacement: Selector) {
        let originalMethodSet = class_getInstanceMethod(self as AnyClass, original)
        let swizzledMethodSet = class_getInstanceMethod(self as AnyClass, replacement)

        method_exchangeImplementations(originalMethodSet!, swizzledMethodSet!)
    }
}

extension NSDocumentController {
    static var isFirstLaunch = true

    @objc func swizzled_beginOpenPanel(
        _ openPanel: NSOpenPanel,
        forTypes inTypes: [String]?,
        completionHandler: @escaping (Int) -> Void
    ) {
        // Bugfix that prevented opening folders
        if let inTypes, inTypes.contains(UTType.folder.identifier) {
            openPanel.canChooseDirectories = true
        }

        // Don't open the file selector view on launch
        // TODO: improve isFirstLaunch checking
        guard !Self.isFirstLaunch else {
            Self.isFirstLaunch = false
            completionHandler(NSApplication.ModalResponse.cancel.rawValue)
            return
        }

        self.swizzled_beginOpenPanel(openPanel, forTypes: inTypes, completionHandler: completionHandler)
    }

    static func swizzle() {
        swizzle(
            #selector (NSDocumentController.beginOpenPanel(_:forTypes:completionHandler:)),
            #selector (NSDocumentController.swizzled_beginOpenPanel(_:forTypes:completionHandler:))
        )
    }
}
