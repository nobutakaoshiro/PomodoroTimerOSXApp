//
//  PomodoroTimerWindow.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/27.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PomodoroTimerWindow: NSWindow {
    
    var _timerCount = 0.0
    var _timerMaxCount = 1500.0 // 1500 seconds = 25 minutes
    var _timeInterval = 1.0 / 2.0
    var _reverseCount = false
    
    let _menuBarHeight = CGFloat(22.0)
    var _progressBarHeight: CGFloat!
//    var _progressBarHeight = CGFloat(14.0)
    
    @IBOutlet weak var view: NSView!
    @IBOutlet weak var startMenuItem: NSMenuItem!
    @IBOutlet weak var stopMenuItem: NSMenuItem!
    @IBOutlet weak var resetMenuItem: NSMenuItem!
    @IBOutlet weak var goalTextMenuItem: NSMenuItem!
    @IBOutlet weak var timerTextMenuItem: NSMenuItem!
    @IBOutlet weak var timerSeparatorMenuItem: NSMenuItem!
    @IBOutlet weak var pauseMenuItem: NSMenuItem!
    
    var _pomodoroTimer: NSTimer!
    var _mainScreenRect: NSRect!
    
    let _colors = [
        "progress" : [128,128,255,128],
        "progress_half" : [255,164,0,128],
        "progress_few_left" : [255,0,0,128],
        "progress_completed" : [128,255,128,128],
    ]
    
//    let _colors = [
//        "progress" : [128,128,255,255],
//        "progress_half" : [255,164,0,255],
//        "progress_few_left" : [255,80,80,255],
//        "progress_completed" : [60,200,60,255],
//    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        println("awakeFromNib()")
        
        setupView()
        initializeTimer()
        showProgressBar()
    }
    
    func setupView() {
        opaque = false // 透過ON
        ignoresMouseEvents = true
        collectionBehavior = NSWindowCollectionBehavior.CanJoinAllSpaces

        _mainScreenRect = getMainScreenFrameRect()
        
        println("level: \(level)")
        
        level = 24
        
        println("level: \(level)")
        changeProgressBarColor()
        
        _progressBarHeight = _menuBarHeight
    }
    
    
//    func drawRect() {
//        showProgressBar()
////        println("draw count:\(_timerCount)")
//
//    }
    
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
        
        var progressBarWidth = CGFloat(_timerCount) * _mainScreenRect.size.width / CGFloat(_timerMaxCount)
        
//        var myScreenRect = NSMakeRect(0.0, _mainScreenRect.size.height - menuBarHeight, progressWidth, menuBarHeight)
//        let progressHeight = menuBarHeight
        
        var myScreenRect = NSMakeRect(0.0, _mainScreenRect.size.height - _menuBarHeight, progressBarWidth, _progressBarHeight)
        
        self.setFrame(myScreenRect, display: true, animate: false)
        
        if (_reverseCount) {
            _timerCount -= _timeInterval
            
            if (_timerCount < 0) {
                _reverseCount = false
            }
        } else {
            _timerCount += _timeInterval

            if (_timerCount > _timerMaxCount) {
                _reverseCount = true
            }

        }
    }
    
    func changeProgressBarColor() {
        var percent = Int(_timerCount * 100.0 / _timerMaxCount)
        
        if (_reverseCount) {
            percent = (100 - percent)
        }
        
//        println("percent: \(percent)")
        
        if (percent < 50) {
            backgroundColor = colors("progress")
        } else if (percent < 80){
            backgroundColor = colors("progress_half")
        } else if (percent < 100){
            backgroundColor = colors("progress_few_left")
        } else if (percent >= 100){
            backgroundColor = colors("progress_completed")
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
        resetTimer()
    }
    
    @IBAction func setGoal(sender: AnyObject) {
        println("setGoal!")
    }
    
    func initializeTimer() {

        _mainScreenRect = getMainScreenFrameRect()
        _pomodoroTimer = NSTimer(timeInterval: _timeInterval, target: self, selector: Selector("showProgressBar"), userInfo: false, repeats: true)
//        _timerCount = 0.0
    }
    
    func startTimer() {
        if (_pomodoroTimer == nil ) {
            initializeTimer()
        }
        
        if (_pomodoroTimer.valid) {
            NSRunLoop.currentRunLoop().addTimer(_pomodoroTimer, forMode: NSRunLoopCommonModes)

//            _pomodoroTimer.fire()
//            showProgressAnimation()
            
            startMenuItem.hidden = true
            pauseMenuItem.hidden = false
            stopMenuItem.hidden = false
            timerTextMenuItem.hidden = false
            timerSeparatorMenuItem.hidden = false
        }
    }
    
    func stopTimer() {
        resetTimer()
        showProgressBar()
        pauseTimer()
    }
    
    func resetTimer() {
        _timerCount = 0.0
    }
    
    @IBAction func pauseTimer(sender: AnyObject) {
        pauseTimer()
    }
    
    func pauseTimer() {
        if (_pomodoroTimer.valid) {
            _pomodoroTimer.invalidate()
            
            stopMenuItem.hidden = true
            pauseMenuItem.hidden = true
            startMenuItem.hidden = false
            timerTextMenuItem.hidden = true
            timerSeparatorMenuItem.hidden = true
        }
        _pomodoroTimer = nil
    }
    
//    func showProgressAnimation() {
//        let menuBarHeight = CGFloat(22.0)
//        let progressWidth = CGFloat(0.0)
//        let progressHeight = CGFloat(22.0)
//        let progressOriginX = CGFloat(0.0)
//        
//        let progressOriginY = _mainScreenRect.size.height - menuBarHeight
//        
//        var progressStartRect = CGRectMake(progressOriginX, progressOriginY, progressWidth, progressHeight)
//        var progressEndRect = CGRectMake(progressOriginX, progressOriginY, _mainScreenRect.size.width, progressHeight)
//        
//        var animationDict = [
//            NSViewAnimationTargetKey: self,
////            NSViewAnimationEffectKey: NSViewAnimationFadeInEffect,
//            NSViewAnimationStartFrameKey: NSValue(rect: progressStartRect),
//            NSViewAnimationEndFrameKey: NSValue(rect: progressEndRect),
//            ]
//        
//        var viewAnimation = NSViewAnimation(viewAnimations: [animationDict])
//        viewAnimation.animationCurve = NSAnimationCurve.Linear
//
//        
//        viewAnimation.duration = 60.0
//        viewAnimation.startAnimation()
//        
//    }
    
    func colors(colorName: String) -> (NSColor) {
        let rgba10:[Int] = _colors[colorName]!
        let r = CGFloat(Float(rgba10[0]) / 255.0)
        let g = CGFloat(Float(rgba10[1]) / 255.0)
        let b = CGFloat(Float(rgba10[2]) / 255.0)
        let a = CGFloat(Float(rgba10[3]) / 255.0)
        
        let color = NSColor(red: r, green: g, blue: b, alpha: a)
        return color
    }
    
    
}
