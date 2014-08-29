//
//  PomodoroTimerModel.swift
//  PomodoroTimer
//
//  Created by Nobutaka OSHIRO on 2014/08/29.
//  Copyright (c) 2014年 Nekojarashi Inc. All rights reserved.
//

import Cocoa

class PomodoroTimerModel: NSObject {
    
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
    
    func countUp() {
        timerProgress += countInterval
    }
}
