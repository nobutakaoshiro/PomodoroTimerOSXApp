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
    var _pomodoroTimerModel: PomodoroTimerModel!
    
    @IBOutlet weak var generalView: NSView!
    @IBOutlet weak var advancedView: NSView!
    @IBOutlet weak var maxCountTextField: NSTextField!
    @IBOutlet weak var maxCountReverseTextField: NSTextField!
    
    @IBOutlet weak var popupButton: NSPopUpButton!
    
    class var sharedInstance: PreferencesWindowController {
        struct Singleton {
            static let instance : PreferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindowController")
        }
        return Singleton.instance
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        _pomodoroTimerModel = PomodoroTimerModel.sharedInstance
        loadMaxCount()
        
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
    
    @IBAction func toggleThinMode(sender: AnyObject) {
        let checkbox = sender as NSButton
        
        switch checkbox.state {
        case 0:
            _pomodoroTimerModel.isThinMode = false
        case 1:
            _pomodoroTimerModel.isThinMode = true
        default:
            _pomodoroTimerModel.isThinMode = false
        }
        
        println("Thin Mode: \(_pomodoroTimerModel.isThinMode)")
    }
    
    @IBAction func saveMaxCount(sender: AnyObject) {
        
        var maxCount = maxCountTextField.doubleValue
        var maxCountReverse = maxCountReverseTextField.doubleValue
        
        saveMaxCount(maxCount, reverseTimerMaxCount: maxCountReverse)
    }
    
    func saveMaxCount(timerMaxCount: Double, reverseTimerMaxCount: Double) {
        _pomodoroTimerModel.timerMaxCount = timerMaxCount
        _pomodoroTimerModel.reverseTimerMaxCount = reverseTimerMaxCount
    }
    
    func loadMaxCount() {
        maxCountTextField.doubleValue = _pomodoroTimerModel.timerMaxCount
        maxCountReverseTextField.doubleValue = _pomodoroTimerModel.reverseTimerMaxCount
    }
    
    @IBAction func changePerformance(sender: AnyObject) {
        var popup = sender as NSPopUpButton
        var interval = 1.0 / Double(popup.selectedItem.tag)
        
        _pomodoroTimerModel.timeInterval = interval
    }
}
