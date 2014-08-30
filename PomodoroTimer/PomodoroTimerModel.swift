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
    var timerMaxCount: Double = 1500.0 // 1500 seconds = 25 minutes
    var reverseTimerMaxCount: Double = 300.0 // 300 seconds = 5 minitues
    var timeInterval: Double = 1.0 / 2.0

    var pomodoroTotalCount: Int = 0
    var isReverse: Bool = false
    var isThinMode: Bool = false
    
    
    let defaultColors = [
        "progress" : [128,128,255,128],
        "progress2" : [13,159,203,128],
        //        "progress3" : [255,164,0,128],
        "progress3" : [253,230,60,128],
        "progress_few_left" : [255,0,0,128],
        "progress_completed" : [128,255,128,128],
    ]
    
    let thinModeColors = [
        "progress" : [128,128,255,255],
        "progress2" : [13,159,203,255],
        "progress3" : [255,164,0,255],
        "progress_few_left" : [255,80,80,255],
        "progress_completed" : [60,200,60,255],
    ]

    
    var colors: NSDictionary {
        get {
            if (isThinMode) {
                return thinModeColors
            } else {
                return defaultColors
            }
        }
    }
    

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
