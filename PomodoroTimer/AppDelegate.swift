//
//  AppDelegate.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/27.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: PomodoroTimerWindow!
    @IBOutlet weak var statusBarMenu: NSMenu!
    
    var mStatusBarItem: NSStatusItem!
    

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        
        NSApp.activateIgnoringOtherApps(true) // 最前面
        
        setupStatusBarItem()

        
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    func setupStatusBarItem() {
        var systemStatusBar = NSStatusBar.systemStatusBar()
//        let statusBarItemLength = NSVariableStatusItemLength
        mStatusBarItem = systemStatusBar.statusItemWithLength(-1) // -1 means "NSVariableStatusItemLength"
        mStatusBarItem.highlightMode = true
//        mStatusBarItem.title = ""
        mStatusBarItem.image = NSImage(named: "AppStatusBarIcon")
        mStatusBarItem.menu = statusBarMenu
    }
    
    @IBAction func showPreferencesWindow(sender: AnyObject) {
        var sharedController = PreferencesWindowController.sharedInstance
        sharedController.showWindow(sender)
    }

}

