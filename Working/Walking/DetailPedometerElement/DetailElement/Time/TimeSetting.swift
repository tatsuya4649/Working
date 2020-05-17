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
    ///基準の歩数を超えたときに呼び出されるデリゲートメソッド
    func archievePerSteps(_ perStepCount:Int,_ stepCount:Int)
    ///基準の距離を超えたときに呼び出されるデリゲートメソッド
    func archievePerDistance(_ perDistance:Float,_ totalDistance:Float)
    ///基準の時間を超えたときに呼び出されるデリゲートメソッド
    func archievePerTime(_ perTime:Int,totalTime:Int)
    ///基準の消費カロリーを超えたときに呼び出されるデリゲートメソッド
    func archievePerCalorie(_ perCalorie:Double,totalCalorie:Double)
}

extension PedometerElementViewController{
    ///歩いた時間に関するUIパーツのセッティングを行うメソッド
    public func timeSetting(){
        timeViewSetting()
        secLabel = UILabel()
        secLabel.text = "\(time != nil ? time! : 0)"
        secLabel.textColor = .white
        secLabel.font = .systemFont(ofSize: 40, weight: .bold)
        secLabel.sizeToFit()
        secLabel.center = CGPoint(x: secLabel.frame.size.width/2, y:  secLabel.frame.size.height/2)
        timeView.addSubview(secLabel)
        secUnitLabel = UILabel()
        secUnitLabel.text = "秒"
        secUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        secUnitLabel.textColor = .white
        secUnitLabel.sizeToFit()
        secUnitLabel.center = CGPoint(x: secLabel.frame.maxX + 5 + secUnitLabel.frame.size.width/2, y: secLabel.frame.maxY - secUnitLabel.frame.size.height/2)
        timeView.addSubview(secUnitLabel)
        timeView.frame = CGRect(x: 0, y: 0, width: secUnitLabel.frame.maxX, height: max(secLabel.frame.maxY,secUnitLabel.frame.maxY))
        timeView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeView.frame.size.height/2)
        time = Int(0)
    }
    public func startTimer(){
        //timer = DispatchSource.makeTimerSource()
        //timer.schedule(deadline: .now(), repeating: 1.0)
        //timer.setEventHandler(handler: {[weak self] in
            //guard let _ = self else{return}
            //self!.dispathTimeUpdate()
        //})
        //timer.resume()
        startButtonOn = true
        print("タイマーをスタートさせます")
        startTimerOnly()
        //通知のスイッチがオンになっているときだけ
        guard let notificationSwitch = notificationSwitch else{return}
        DispatchQueue.main.async {[weak self] in
            guard let _ = self else{return}
            if notificationSwitch.isOn{
                self!.sendNotificationTimer(nil,"\(self!.perTime != nil ? Int(self!.perTime!/60) : 0)分を超えました。")
                //self!.sendNotificationCalorie(nil, "\(self!.perCalorie != nil ? Int(self!.perCalorie) : 0)kcalを超えました。")
                self!.reading = Reading("時間が基準の\(self!.perTime != nil ? Int(self!.perTime!/60) : 0)分を超えました。", .time)
                self!.reading.readingToAudioFile()
                //if let delegate = self!.delegate{
                    //delegate.archievePerTime(self!.perTime, totalTime: self!.time)
                //}
            }
        }
    }
    public func resetTimer(){
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
    }
    public func startTimerOnly(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(_ sender:Timer){
        time += Int(sender.timeInterval)
        DispatchQueue.main.async {
            self.updateTimeLabel()
        }
        checkArchievePerTime(Int(sender.timeInterval))
        guard let delegate = delegate else{return}
        delegate.updateTimer(time)
    }
    private func dispathTimeUpdate(){
        print("タイマーが更新されましたよ")
        time += Int(1.0)
        DispatchQueue.main.async {[weak self] in
            guard let _ = self else{return}
            self!.updateTimeLabel()
        }
        checkArchievePerTime(Int(1.0))
        guard let delegate = delegate else{return}
        delegate.updateTimer(time)
    }
    public func resetTime(){
        if startButtonOn != nil{
            startButtonOn = nil
        }
        timer.invalidate()
        //timer.cancel()
        timer = nil
        time = Int(0)
        updateTimeLabel()
        checkPerTime = perTime
        removeTimerNotification()
    }
    private func updateTimeLabel(){
        if time >= 60*60*24{
            let day = time/(60*60*24)
            let hour = (time%(60*60*24))/3600
            let min = (time%3600)/60
            let sec = time % 60
            updateSecLabel(sec)
            updateMinLabel(min)
            updateHourLabel(hour)
            updateDayLabel(day)
            dayFontSizeCheck()
        }else if time >= 60*60 {
            let hour = (time%(60*60*24))/3600
            let min = (time%3600)/60
            let sec = time % 60
            updateSecLabel(sec)
            updateMinLabel(min)
            updateHourLabel(hour)
            hourFontSizeCheck()
            resetDayLabel()
        }else if time >= 60{
            let min = (time%3600)/60
            let sec = time % 60
            updateSecLabel(sec)
            updateMinLabel(min)
            minFontSizeCheck()
            resetHourLabel()
        }else{
            updateSecLabel(time != nil ? time! : 0)
            secFontSizeCheck()
            resetMinLabel()
        }
    }
    private func resetDayLabel(){
        if dayLabel != nil{
            dayLabel.removeFromSuperview()
            dayLabel = nil
        }
        if dayUnitLabel != nil{
            dayUnitLabel.removeFromSuperview()
            dayUnitLabel = nil
        }
    }
    private func resetHourLabel(){
        resetDayLabel()
        if hourLabel != nil{
            hourLabel.removeFromSuperview()
            hourLabel = nil
        }
        if hourUnitLabel != nil{
            hourUnitLabel.removeFromSuperview()
            hourUnitLabel = nil
        }
    }
    private func resetMinLabel(){
        resetHourLabel()
        if minLabel != nil{
            minLabel.removeFromSuperview()
            minLabel = nil
        }
        if minUnitLabel != nil{
            minUnitLabel.removeFromSuperview()
            minUnitLabel = nil
        }
    }
    private func timeViewSetting(){
        if timeView == nil{
            timeView = UIView()
            self.view.addSubview(timeView)
        }
    }
    private func daySizeUpdate(){
        dayLabel.center = CGPoint(x: dayLabel.frame.size.width/2, y: dayLabel.frame.size.height/2)
        dayUnitLabel.center = CGPoint(x: dayLabel.frame.maxX + 2 + dayUnitLabel.frame.size.width/2, y: dayLabel.frame.maxY - dayUnitLabel.frame.size.height/2)
        hourLabel.center = CGPoint(x: dayUnitLabel.frame.maxX + 5 + hourLabel.frame.size.width/2, y:  hourLabel.frame.size.height/2)
        hourUnitLabel.center = CGPoint(x: hourLabel.frame.maxX + 2 + hourUnitLabel.frame.size.width/2, y: hourLabel.frame.maxY - hourUnitLabel.frame.size.height/2)
        minLabel.center = CGPoint(x: hourUnitLabel.frame.maxX + 5 + minLabel.frame.size.width/2, y:  minLabel.frame.size.height/2)
        minUnitLabel.center = CGPoint(x: minLabel.frame.maxX + 2 + minUnitLabel.frame.size.width/2, y: minLabel.frame.maxY - minUnitLabel.frame.size.height/2)
        secLabel.center = CGPoint(x: minUnitLabel.frame.maxX + 5 + secLabel.frame.size.width/2, y:  secLabel.frame.size.height/2)
        secUnitLabel.center = CGPoint(x: secLabel.frame.maxX + 2 + secUnitLabel.frame.size.width/2, y: secLabel.frame.maxY - secUnitLabel.frame.size.height/2)
        timeView.frame = CGRect(x:0,y:0,width:secUnitLabel.frame.maxX - dayLabel.frame.minX,height:max(dayLabel.frame.maxY,dayUnitLabel.frame.maxY,hourLabel.frame.maxY,hourUnitLabel.frame.maxY,minLabel.frame.maxY,minUnitLabel.frame.maxY,secLabel.frame.maxY,secUnitLabel.frame.maxY))
        timeView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeView.frame.size.height/2)
    }
    private func dayFontSizeCheck(){
        daySizeUpdate()
        while(self.view.frame.size.width*0.9<timeView.frame.size.width){
            let size = secLabel.font.pointSize - 1
            
            secLabel.font = .systemFont(ofSize: size, weight: .bold)
            minLabel.font = .systemFont(ofSize: size, weight: .bold)
            hourLabel.font = .systemFont(ofSize: size, weight: .bold)
            dayLabel.font = .systemFont(ofSize: size, weight: .bold)
            secLabel.sizeToFit()
            minLabel.sizeToFit()
            hourLabel.sizeToFit()
            dayLabel.sizeToFit()
            daySizeUpdate()
        }
    }
    private func hourSizeUpdate(){
        hourLabel.center = CGPoint(x: hourLabel.frame.size.width/2, y:  hourLabel.frame.size.height/2)
        hourUnitLabel.center = CGPoint(x: hourLabel.frame.maxX + 2 + hourUnitLabel.frame.size.width/2, y: hourLabel.frame.maxY - hourUnitLabel.frame.size.height/2)
        minLabel.center = CGPoint(x: hourUnitLabel.frame.maxX + 5 + minLabel.frame.size.width/2, y:  minLabel.frame.size.height/2)
        minUnitLabel.center = CGPoint(x: minLabel.frame.maxX + 2 + minUnitLabel.frame.size.width/2, y: minLabel.frame.maxY - minUnitLabel.frame.size.height/2)
        secLabel.center = CGPoint(x: minUnitLabel.frame.maxX + 5 + secLabel.frame.size.width/2, y:  secLabel.frame.size.height/2)
        secUnitLabel.center = CGPoint(x: secLabel.frame.maxX + 2 + secUnitLabel.frame.size.width/2, y: secLabel.frame.maxY - secUnitLabel.frame.size.height/2)
        timeView.frame = CGRect(x:0,y:0,width:secUnitLabel.frame.maxX - hourLabel.frame.minX,height:max(hourLabel.frame.maxY,hourUnitLabel.frame.maxY,minLabel.frame.maxY,minUnitLabel.frame.maxY,secLabel.frame.maxY,secUnitLabel.frame.maxY))
        timeView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeView.frame.size.height/2)
    }
    private func hourFontSizeCheck(){
        hourSizeUpdate()
        while(self.view.frame.size.width*0.9<timeView.frame.size.width){
            let size = secLabel.font.pointSize - 1
            
            secLabel.font = .systemFont(ofSize: size, weight: .bold)
            minLabel.font = .systemFont(ofSize: size, weight: .bold)
            hourLabel.font = .systemFont(ofSize: size, weight: .bold)
            secLabel.sizeToFit()
            minLabel.sizeToFit()
            hourLabel.sizeToFit()
            hourSizeUpdate()
        }
    }
    private func minSizeUpdate(){
        minLabel.center = CGPoint(x: minLabel.frame.size.width/2, y:  minLabel.frame.size.height/2)
        minUnitLabel.center = CGPoint(x: minLabel.frame.maxX + 5 + minUnitLabel.frame.size.width/2, y: minLabel.frame.maxY - minUnitLabel.frame.size.height/2)
        secLabel.center = CGPoint(x: minUnitLabel.frame.maxX + 10 + secLabel.frame.size.width/2, y:  secLabel.frame.size.height/2)
        secUnitLabel.center = CGPoint(x: secLabel.frame.maxX + 5 + secUnitLabel.frame.size.width/2, y: secLabel.frame.maxY - secUnitLabel.frame.size.height/2)
        timeView.frame = CGRect(x:0,y:0,width:secUnitLabel.frame.maxX - minLabel.frame.minX,height:max(minLabel.frame.maxY,minUnitLabel.frame.maxY,secLabel.frame.maxY,secUnitLabel.frame.maxY))
        timeView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeView.frame.size.height/2)
    }
    private func minFontSizeCheck(){
        minSizeUpdate()
        while(self.view.frame.size.width*0.9<timeView.frame.size.width){
            let size = secLabel.font.pointSize - 1
            print(size)
            secLabel.font = .systemFont(ofSize: size, weight: .bold)
            minLabel.font = .systemFont(ofSize: size, weight: .bold)
            minLabel.sizeToFit()
            secLabel.sizeToFit()
            minSizeUpdate()
        }
    }
    private func updateSecLabel(_ sec:Int){
        secLabel.text = "\(sec)"
        secLabel.textColor = .white
        secLabel.font = .systemFont(ofSize: 40, weight: .bold)
        secLabel.sizeToFit()
        secLabel.center = CGPoint(x: secLabel.frame.size.width/2, y: secLabel.frame.size.height/2)
        secUnitLabel.center = CGPoint(x: secLabel.frame.maxX + 5 + secUnitLabel.frame.size.width/2, y: secLabel.frame.maxY - secUnitLabel.frame.size.height/2)
    }
    private func secSizeUpdate(){
        secLabel.center = CGPoint(x: secLabel.frame.size.width/2, y: secLabel.frame.size.height/2)
        secUnitLabel.center = CGPoint(x: secLabel.frame.maxX + 5 + secUnitLabel.frame.size.width/2, y: secLabel.frame.maxY - secUnitLabel.frame.size.height/2)
        timeView.frame = CGRect(x:0,y:0,width:secUnitLabel.frame.maxX - secLabel.frame.minX,height:max(secLabel.frame.maxY,secUnitLabel.frame.maxY))
        timeView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + timeView.frame.size.height/2)
    }
    private func secFontSizeCheck(){
        secSizeUpdate()
        while(self.view.frame.size.width*0.9<timeView.frame.size.width){
            let size = secLabel.font.pointSize - 1
            
            secLabel.font = .systemFont(ofSize: size, weight: .bold)
            secLabel.sizeToFit()
            secSizeUpdate()
        }
    }
    private func updateMinLabel(_ min:Int){
        if minLabel == nil{
            minLabel = UILabel()
            timeView.addSubview(minLabel)
        }
        if minUnitLabel == nil{
            minUnitLabel = UILabel()
            minUnitLabel.text = "分"
            minUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            minUnitLabel.textColor = .white
            minUnitLabel.sizeToFit()
            timeView.addSubview(minUnitLabel)
        }
        minLabel.text = "\(min)"
        minLabel.textColor = .white
        minLabel.font = .systemFont(ofSize: 40, weight: .bold)
        minLabel.sizeToFit()
    }
    private func updateHourLabel(_ hour:Int){
        if hourLabel == nil{
            hourLabel = UILabel()
            timeView.addSubview(hourLabel)
        }
        if hourUnitLabel == nil{
            hourUnitLabel = UILabel()
            hourUnitLabel.text = "時間"
            hourUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            hourUnitLabel.textColor = .white
            hourUnitLabel.sizeToFit()
            timeView.addSubview(hourUnitLabel)
        }
        hourLabel.text = "\(hour)"
        hourLabel.textColor = .white
        hourLabel.font = .systemFont(ofSize: 40, weight: .bold)
        hourLabel.sizeToFit()
    }
    private func updateDayLabel(_ day:Int){
        if dayLabel == nil{
            dayLabel = UILabel()
            timeView.addSubview(dayLabel)
        }
        if dayUnitLabel == nil{
            dayUnitLabel = UILabel()
            dayUnitLabel.text = "日"
            dayUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            dayUnitLabel.textColor = .white
            dayUnitLabel.sizeToFit()
            timeView.addSubview(dayUnitLabel)
        }
        dayLabel.text = "\(day)"
        dayLabel.textColor = .white
        dayLabel.font = .systemFont(ofSize: 40, weight: .bold)
        dayLabel.sizeToFit()
        
    }
    ///時間が基準に達成したかどうかを確認するメソッド
    private func checkArchievePerTime(_ time:Int){
        guard let _ = checkPerTime else{return}
        checkPerTime -= time
        print("時間の基準まで後\(checkPerTime!)")
        guard checkPerTime <= 0 else{return}
        print("時間が基準を超えました")
        //通知のスイッチがオンになっているときだけ
        //guard let notificationSwitch = notificationSwitch else{return}
        //DispatchQueue.main.async {[weak self] in
            //guard let _ = self else{return}
            //if notificationSwitch.isOn{
                //self!.sendNotification("\(self!.perTime != nil ? Int(self!.perTime!/60) : 0)分を超えました。","現在の合計時間は\(self!.time != nil ? Int(self!.time!/60) : 0)分です。")
                //self!.reading = Reading("時間が基準の\(self!.perTime != nil ? Int(self!.perTime!/60) : 0)分を超えました。現在の合計時間は\(self!.time != nil ? Int(self!.time!/60) : 0)分です。", .time)
                //self!.reading.readingSentences()
                //if let delegate = self!.delegate{
                    //delegate.archievePerTime(self!.perTime, totalTime: self!.time)
                //}
            //}
        //}
        checkPerTime = perTime
    }
    ///時間の登録済みの通知を全て削除するための関数
    public func removeTimerNotification(){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
            print(request)
        })
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { request in
            print(request)
        })
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [pedoElementNotification.time.rawValue])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pedoElementNotification.time.rawValue])
        print("タイマー通知の削除に成功しました")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
            print(request)
        })
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { request in
            print(request)
        })
    }
    ///時間の通知を改めて作成するための関数
    public func restartTimerNotification(){
        //スタートボタンがオンじゃないとき(万歩計が動いていないとき)は通知を作成しない
        guard let _ = startButtonOn else{return}
        guard let perTime = perTime else{return}
        sendNotificationTimer(nil,"\(self.perTime != nil ? Int(self.perTime!/60) : 0)分を超えました。",Double(checkPerTime != nil ? checkPerTime! : 0))
    }
    public func checkTimeLocationUpdate() -> (Int?,Int?){
        //前回の位置情報更新のときよりもカウントが大きかったら・・・
        if locationUpdatePerTime < checkPerTime{
            //パー歩数と合計歩数を返す
            return (perTime,time)
        }else{
            return (nil,nil)
        }
    }
}
