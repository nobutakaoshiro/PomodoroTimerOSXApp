//
//  PreferencesWindowController.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/29.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    let viewTypeGeneral = 100
    let viewTypeAdvanced = 101
    
    @IBOutlet weak var generalView: NSView!
    @IBOutlet weak var advancedView: NSView!
    
    class var sharedInstance: PreferencesWindowController {
        struct Singleton {
            static let instance : PreferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindowController")
        }
        return Singleton.instance
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        var toolbar = window.toolbar
        var toolbarItems = toolbar.items
        var leftmostToolbarItem: NSToolbarItem = toolbarItems[0] as NSToolbarItem
        toolbar.selectedItemIdentifier = leftmostToolbarItem.itemIdentifier
        switchView(leftmostToolbarItem)
        window.center()
    }
    
    @IBAction func switchView(sender: AnyObject) {
        let toolbarItem = sender as NSToolbarItem
        let viewType: Int = toolbarItem.tag

        var newView: NSView!
        
        switch viewType {
        case viewTypeGeneral:
            newView = generalView
        case viewTypeAdvanced:
            newView = advancedView
        default:
            newView = generalView
        }
        
        var contentView = window.contentView as NSView
        var subviews = contentView.subviews
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        window.title = toolbarItem.label
        
        var windowFrame = window.frame
        var newWindowFrame = window.frameRectForContentRect(newView.frame)
        newWindowFrame.origin.x = windowFrame.origin.x
        newWindowFrame.origin.y = windowFrame.origin.y + windowFrame.size.height - newWindowFrame.size.height
        window.setFrame(newWindowFrame, display: true, animate: true)
        
        contentView.addSubview(newView)
        
    }
}
