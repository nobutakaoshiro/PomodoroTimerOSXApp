//
//  PomodoroTimerWindow.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/27.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PomodoroTimerWindow: NSWindow {
    
    var count = 0
    
    @IBOutlet weak var view: NSView!

//    required init(coder: NSCoder!) {
//        super.init(coder: coder)
//        println("init(coder: NSCoder!)")
//    }
//    
//    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
//        //        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
////        let rect: NSRect = NSMakeRect(0.0, 0.0, 600.0, 24.0)
////        let bStyle: Int = NSBorderlessWindowMask
////        
//        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
//        println("init(content...)")
//
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        println("awakeFromNib()")
        drawRect()
    }
   
    func drawRect() {
        println("drawRect()")
//        backgroundColor = NSColor(calibratedRed: 0.5, green: 0.5, blue: 1.0, alpha: 2.0)
        backgroundColor = NSColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.5)
        opaque = false
        
        let aPoint: NSPoint = NSMakePoint(0.0, 1050.0)
        setFrameTopLeftPoint(aPoint)
        
        ignoresMouseEvents = true
        
        collectionBehavior = NSWindowCollectionBehavior.CanJoinAllSpaces
        
        
        level = 25
        
        println(count++)

    }
    
//    override func constrainFrameRect(frameRect: NSRect, toScreen screen: NSScreen!) -> NSRect {
//        
//        return frameRect
//    }
//    
}
