//
//  TimeSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

protocol PedometerElementViewControllerDelegate:AnyObject {
    func updateTimer(_ time:Int)
}

extension PedometerElementViewController{
    ///歩いた時間に関するUIパーツのセッティングを行うメソッド
    public func timeSetting(){
        timeLabel = UILabel()
        timeLabel.text = "\(time != nil ? time! : 0)"
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 40, weight: .bold)
        timeLabel.sizeToFit()
        timeLabel.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeLabel.frame.size.height/2)
        self.view.addSubview(timeLabel)
        timeUnitLabel = UILabel()
        timeUnitLabel.text = "秒"
        timeUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        timeUnitLabel.textColor = .white
        timeUnitLabel.sizeToFit()
        timeUnitLabel.center = CGPoint(x: timeLabel.frame.maxX + 5 + timeUnitLabel.frame.size.width/2, y: timeLabel.frame.maxY - timeUnitLabel.frame.size.height/2)
        self.view.addSubview(timeUnitLabel)
        time = Int(0)
    }
    public func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    public func resetTime(){
        timer.invalidate()
        timer = nil
        time = Int(0)
        updateTimeLabel()
    }
    private func updateTimeLabel(){
        if time > 60*60*24{
            let day = time/(60*60*24)
            let hour = (time%(60*60*24))/3600
            let min = (time%3600)/60
            let sec = time % 60
            timeLabel.text = "\(day)日\(hour)時間\(min)分\(sec)秒"
        }else if time > 60*60 {
            let hour = (time%(60*60*24))/3600
            let min = (time%3600)/60
            let sec = time % 60
            timeLabel.text = "\(hour)時間\(min)分\(sec)秒"
        }else if time > 60{
            let min = (time%3600)/60
            let sec = time % 60
            timeLabel.text = "\(min)分\(sec)秒"
        }else{
            timeLabel.text = "\(time != nil ? time! : 0)"
        }
        
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 40, weight: .bold)
        timeLabel.sizeToFit()
        timeLabel.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeLabel.frame.size.height/2)
        timeUnitLabel.center = CGPoint(x: timeLabel.frame.maxX + 5 + timeUnitLabel.frame.size.width/2, y: timeLabel.frame.maxY - timeUnitLabel.frame.size.height/2)
    }
    @objc func updateTimer(_ sender:Timer){
        time += Int(sender.timeInterval)
        updateTimeLabel()
        guard let delegate = delegate else{return}
        delegate.updateTimer(time)
    }
}
