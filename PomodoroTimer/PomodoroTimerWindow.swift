//
//  PomodoroTimerWindow.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/27.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PomodoroTimerWindow: NSWindow, NSUserNotificationCenterDelegate {
    
//    var _timerProgress = 0.0
//    var _timerMaxCount = 1500.0 // 1500 seconds = 25 minutes
//    var _timeInterval = 1.0 / 10.0
//    var _isReverse = false
//    var _reverseTimerMaxCount = 300.0 // 300 seconds = 5 minitues
    
    var _pomodoroTotalCount: Int = 0
    
    
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

    var _pomodoroTimerModel: PomodoroTimerModel!
    var _timer: NSTimer!
    var _mainScreenRect: NSRect!
    
    let _windowLevel = 24
    
    let _colors = [
        "progress" : [128,128,255,128],
        "progress2" : [13,159,203,128],
//        "progress3" : [255,164,0,128],
        "progress3" : [253,230,60,128],
        "progress_few_left" : [255,0,0,128],
        "progress_completed" : [128,255,128,128],
    ]
    
    
//    let _colors = [
//        "progress" : [128,128,255,255],
//        "progress_half" : [255,164,0,255],
//        "progress_few_left" : [255,80,80,255],
//        "progress_completed" : [60,200,60,255],
//    ]
    
    var isReverse: Bool {
        get {
            return _pomodoroTimerModel.isReverse
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _pomodoroTimerModel = PomodoroTimerModel()
        
        setupView()
        initializeTimer()
        showProgressBar()
        startTimer()
    }
    
    func setupView() {
        opaque = false // 透過ON
        ignoresMouseEvents = true
        collectionBehavior = NSWindowCollectionBehavior.CanJoinAllSpaces
        _mainScreenRect = getMainScreenFrameRect()
        level = _windowLevel
        changeProgressBarColor()
        _progressBarHeight = _menuBarHeight
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
        
        var maxCount = _pomodoroTimerModel.maxCount
        var timerProgress = _pomodoroTimerModel.timerProgress
        
        var progressBarWidth = CGFloat(timerProgress) * _mainScreenRect.size.width / CGFloat(maxCount)
        
        if (isReverse) {
            progressBarWidth = _mainScreenRect.size.width - progressBarWidth
        }
        
        var myScreenRect = NSMakeRect(0.0, _mainScreenRect.size.height - _menuBarHeight, progressBarWidth, _progressBarHeight)
        self.setFrame(myScreenRect, display: true, animate: false)
        
        // Count Up (or Count Down) Timer
        _pomodoroTimerModel.countUp()
        updateTimerText()

        if (timerProgress >= maxCount) {
            if (isReverse) {
                _pomodoroTimerModel.isReverse = false
                playSound("Submarine")
            } else {
                _pomodoroTimerModel.isReverse = true
                _pomodoroTimerModel.pomodoroTotalCount += 1
                println("Pomodoro: \(_pomodoroTimerModel.pomodoroTotalCount)")
                playSound("Hero")
                sendNotification("PomodoroTimer", subtitle:"Finished!", body:"Total Pomodoro: \(_pomodoroTimerModel.pomodoroTotalCount)")
            }
            
            _pomodoroTimerModel.timerProgress = 0.0
        }
    }


    
    func changeProgressBarColor() {
        
        var percent = _pomodoroTimerModel.progressPercent

        if (percent < 0) {
            backgroundColor = colors("progress_completed")
        } else if (percent < 30) {
            backgroundColor = colors("progress")
        } else if (percent < 60) {
            backgroundColor = colors("progress2")
        } else if (percent < 90){
            backgroundColor = colors("progress3")
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
        setGoal("ゴールを設定！")
    }
    
    func initializeTimer() {
        _mainScreenRect = getMainScreenFrameRect()
        _timer = NSTimer(timeInterval: _pomodoroTimerModel.timeInterval, target: self, selector: Selector("showProgressBar"), userInfo: false, repeats: true)
    }
    
    func startTimer() {
        if (_timer == nil) {
            initializeTimer()
        }
        
        if (_timer.valid) {
            NSRunLoop.currentRunLoop().addTimer(_timer, forMode: NSRunLoopCommonModes)
            
            startMenuItem.hidden = true
            pauseMenuItem.hidden = false
            stopMenuItem.hidden = false
            resetMenuItem.hidden = false
            timerTextMenuItem.hidden = false
            timerSeparatorMenuItem.hidden = false
        }
    }
    
    func stopTimer() {
        resetTimer()
        pauseTimer()
        stopMenuItem.hidden = true
        resetMenuItem.hidden = true
        timerTextMenuItem.hidden = true
        timerSeparatorMenuItem.hidden = true
    }
    
    func resetTimer() {
        _pomodoroTimerModel.timerProgress = 0.0
        _pomodoroTimerModel.pomodoroTotalCount = 0
        _pomodoroTimerModel.isReverse = false
        showProgressBar()
    }
    
    @IBAction func pauseTimer(sender: AnyObject) {
        pauseTimer()
    }
    
    func pauseTimer() {
        if (_timer != nil && _timer.valid) {
            _timer.invalidate()
            
            pauseMenuItem.hidden = true
            startMenuItem.hidden = false
        }
        _timer = nil
    }
    
    func colors(colorName: String) -> (NSColor) {
        let rgba10:[Int] = _colors[colorName]!
        let r = CGFloat(Float(rgba10[0]) / 255.0)
        let g = CGFloat(Float(rgba10[1]) / 255.0)
        let b = CGFloat(Float(rgba10[2]) / 255.0)
        let a = CGFloat(Float(rgba10[3]) / 255.0)
        
        let color = NSColor(red: r, green: g, blue: b, alpha: a)
        return color
    }
    
    func playSound(soundName: NSString) {
//        var sound = NSSound(contentsOfFile: "", byReference: true)
        var sound = NSSound(named: soundName)
        if (!sound.playing) {
            sound.play()
        }
    }
    
    func sendNotification(title: NSString, subtitle: NSString, body: NSString) {
        var userNotification = NSUserNotification()
        userNotification.title = title
        userNotification.subtitle = subtitle
        userNotification.informativeText = body
        
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(userNotification)
        
        println("sended Notification!")
        
    }
    
    func setGoal(goalString: NSString) {
        goalTextMenuItem.title = goalString
    }
    
    func updateTimerText() {
        timerTextMenuItem.title = "Remaining: \(_pomodoroTimerModel.remainingTimeString)"
    }
}
