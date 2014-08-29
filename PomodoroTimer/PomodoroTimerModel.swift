//
//  PomodoroTimerModel.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/29.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

@objc(PomodoroTimerModel)
class PomodoroTimerModel: NSObject {
    
    class var sharedInstance: PomodoroTimerModel {
        struct Singleton {
            static let instance : PomodoroTimerModel = PomodoroTimerModel()
        }
        return Singleton.instance
    }
    
    var timerProgress: Double = 0.0
    var timerMaxCount: Double = 60.0 // 1500 seconds = 25 minutes
    var reverseTimerMaxCount: Double = 20.0 // 300 seconds = 5 minitues
    var timeInterval: Double = 1.0 / 2.0

    var isReverse = false
    var pomodoroTotalCount: Int = 0

    var maxCount: Double {
        get {
            return isReverse ? reverseTimerMaxCount : timerMaxCount
        }
    }
    
    var progressPercent: Int {
        get {
            return Int(timerProgress * 100.0 / maxCount)
        }
    }

    
    var countInterval: Double {
        get {
            // return timeInterval * timerMaxCount / maxCount
            return timeInterval
        }
    }
    
    var timeString: NSString {
        get {
            var time = Int(timerProgress)
            
            var seconds = time % 60
            var minutes = (time / 60) % 60
            return NSString(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var remainingTimeString: NSString {
        get {
            var time = Int(timerProgress)
            var remainingTime = Int(maxCount) - time
            var seconds = remainingTime % 60
            var minutes = (remainingTime / 60) % 60
            return NSString(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func countUp() {
        timerProgress += countInterval
    }
    
}
