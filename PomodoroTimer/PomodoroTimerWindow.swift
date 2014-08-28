//
//  PomodoroTimerWindow.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/27.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PomodoroTimerWindow: NSWindow {
    
    var _count = 0.0
    
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var startMenuItem: NSMenuItem!
    @IBOutlet weak var stopMenuItem: NSMenuItem!
    @IBOutlet weak var resetMenuItem: NSMenuItem!
    @IBOutlet weak var goalTextMenuItem: NSMenuItem!
    @IBOutlet weak var timerTextMenuItem: NSMenuItem!
    @IBOutlet weak var timerSeparatorMenuItem: NSMenuItem!
    
    var _pomodoroTimer: NSTimer!
    var _mainScreenRect: NSRect!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        println("awakeFromNib()")
        
        setupView()
        initializeTimer()
        drawRect()
    }
    
    func setupView() {
        opaque = false // 透過ON
        ignoresMouseEvents = true
        collectionBehavior = NSWindowCollectionBehavior.CanJoinAllSpaces

        _mainScreenRect = getMainScreenFrameRect()
        
        println("level: \(level)")
        
        level = 25
        
        println("level: \(level)")

    }
    
    
    func drawRect() {
        showProgressBar()
        println("draw count:\(_count)")

    }
    
    func getMainScreenFrameRect() -> (NSRect) {

        var screenRect: NSRect!
        
        for (index, screen) in enumerate(NSScreen.screens()) {
            screenRect = screen.frame
            
            NSLog("[%d]: %@, %@", index, screenRect.width, screenRect.height)

        }
        return screenRect
    }
    
    func showProgressBar() {
        changeProgressBarColor()
        
        var progressWidth = CGFloat(300.0) + CGFloat(_count * 10)
        
        let menuBarHeight = CGFloat(22.0)
//        var mainScreenRect = getMainScreenFrameRect()
//        var myScreenRect = NSMakeRect(0.0, _mainScreenRect.size.height - menuBarHeight, _mainScreenRect.size.width, menuBarHeight)
        var myScreenRect = NSMakeRect(0.0, _mainScreenRect.size.height - menuBarHeight, progressWidth, menuBarHeight)
        
        self.setFrame(myScreenRect, display: true, animate: false)
        println("drawRect(), [x:\(myScreenRect.origin.x), y:\(myScreenRect.origin.y), w:\(myScreenRect.size.width), h:\(myScreenRect.origin.y)")
        
        _count += 1.0
    }
    
    func changeProgressBarColor() {
        if (_count <= 10.0) {
            backgroundColor = NSColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.5)
        } else {
            backgroundColor = NSColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.5)
        }
    }
    
    @IBAction func startTimer(sender: AnyObject) {
        println("startTimer!")
        startTimer()
    }
    
    @IBAction func stopTimer(sender: AnyObject) {
        println("stopTimer!")
        stopTimer()
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
        println("resetTimer!")
    }
    
    @IBAction func setGoal(sender: AnyObject) {
        println("setGoal!")
    }
    
    func initializeTimer() {
//         _pomodoroTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("showProgressBar"), userInfo: nil, repeats: true)
        _pomodoroTimer = NSTimer(timeInterval:1.0, target: self, selector: Selector("drawRect"), userInfo: false, repeats: true)

        _count += 0.0
        
    }
    
    func startTimer() {
        if (_pomodoroTimer.valid) {
        
            initializeTimer()
            _pomodoroTimer.fire()
            
            startMenuItem.hidden = true
            stopMenuItem.hidden = false
        }
    }
    
    func stopTimer() {
        if (_pomodoroTimer.valid) {
            _pomodoroTimer.invalidate()
            
            stopMenuItem.hidden = true
            startMenuItem.hidden = false
        }
    }
    
    
}
