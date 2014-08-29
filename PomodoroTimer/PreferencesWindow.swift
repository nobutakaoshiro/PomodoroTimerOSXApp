//
//  PreferencesWindow.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/29.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindow {

    override func cancelOperation(sender: AnyObject!) {
        close()
    }
    
    override func validateUserInterfaceItem(anItem: NSValidatedUserInterfaceItem!) -> Bool {
       var action: Selector = anItem.action()
       
        if (action == Selector("toggleToolbarShown")) {
            return false
        }
        return super.validateUserInterfaceItem(anItem)
    }
}
