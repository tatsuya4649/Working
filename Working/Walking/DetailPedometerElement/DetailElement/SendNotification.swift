//
//  SendNotification.swift
//  Working
//
//  Created by 下川達也 on 2020/05/16.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum pedoElementNotification : String{
    case step = "step"
    case distance = "distance"
    case time = "time"
    case calorie = "calorie"
}

extension PedometerElementViewController{
    ///通知を送信するための関数
    public func sendNotificationSteps(_ title:String?,_ body:String){
        let content = UNMutableNotificationContent()
        // 通知のメッセージセット
        if let title = title{
            content.title = title
        }
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: stepsAudioFile))
        let request = UNNotificationRequest(identifier: pedoElementNotification.step.rawValue, content: content, trigger: nil)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print()
    }
    public func sendNotificationDistance(_ title:String?,_ body:String){
        let content = UNMutableNotificationContent()
        // 通知のメッセージセット
        if let title = title{
            content.title = title
        }
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: distanceAudioFile))
        let request = UNNotificationRequest(identifier: pedoElementNotification.distance.rawValue, content: content, trigger: nil)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    public func sendNotificationTimer(_ title:String?,_ body:String){
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(exactly: Double(perTime!))!, repeats: true)
        // 通知のメッセージセット
        if let title = title{
            content.title = title
        }
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: timeAudioFile))
        let request = UNNotificationRequest(identifier: pedoElementNotification.time.rawValue, content: content, trigger: trigger)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    public func sendNotificationTimer(_ title:String?,_ body:String,_ delay:Double){
        if workItem != nil{
            print("すでに通知設定されているものがあったので、そっちを削除して更新します。")
            workItem.cancel()
            workItem = nil
        }
        print("\(delay)秒後に1度通知し、その後\(self.perTime/60)分ごとに1度通知する設定が完了しました")
        workItem = DispatchWorkItem() { [weak self] in
            guard let _ = self else{return}
            let content = UNMutableNotificationContent()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(exactly: Double(self!.perTime!))!, repeats: true)
            // 通知のメッセージセット
            if let title = title{
                content.title = title
            }
            content.body = body
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: timeAudioFile))
            ///すぐに通知する用
            let request = UNNotificationRequest(identifier: pedoElementNotification.time.rawValue, content: content, trigger: nil)
            ///その後10分おきに通知する用
            let requestRepeat = UNNotificationRequest(identifier: pedoElementNotification.time.rawValue, content: content, trigger: trigger)
            // 通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            UNUserNotificationCenter.current().add(requestRepeat, withCompletionHandler: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay,execute: workItem)
    }
    public func sendNotificationCalorie(_ title:String?,_ body:String){
        let timer = (perCalorie != nil ? perCalorie! : DEFAULT_PERCALORIE) / (3*(weight != nil ? weight! : DEFAULT_WEIGHT))
        let perSec = 60*60*timer
        
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(exactly: Double(perSec))!, repeats: true)
        // 通知のメッセージセット
        if let title = title{
            content.title = title
        }
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: calorieAudioFile))
        let request = UNNotificationRequest(identifier: pedoElementNotification.calorie.rawValue, content: content, trigger: trigger)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    public func sendNotificationCalorie(_ title:String?,_ body:String,_ delay:Double){
        let timer = (self.perCalorie != nil ? self.perCalorie! : DEFAULT_PERCALORIE) / (3*(self.weight != nil ? self.weight! : DEFAULT_WEIGHT))
        let perSec = 60*60*timer
        print(perSec)
        if workItem != nil{
            print("すでに通知設定されているものがあったので、そっちを削除して更新します。")
            workItem.cancel()
            workItem = nil
        }
        print("\(delay/60)分後に1度通知し、その後\(perSec/60)分ごとに1度通知する設定が完了しました")
        workItem = DispatchWorkItem() {[weak self] in
            guard let _ = self else{return}
            let timer = (self!.perCalorie != nil ? self!.perCalorie! : DEFAULT_PERCALORIE) / (3*(self!.weight != nil ? self!.weight! : DEFAULT_WEIGHT))
            let perSec = 60*60*timer
            let content = UNMutableNotificationContent()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(exactly: Double(perSec))!, repeats: true)
            // 通知のメッセージセット
            if let title = title{
                content.title = title
            }
            content.body = body
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: calorieAudioFile))
            let request = UNNotificationRequest(identifier: pedoElementNotification.calorie.rawValue, content: content, trigger: nil)
            let requestRepeat = UNNotificationRequest(identifier: pedoElementNotification.time.rawValue, content: content, trigger: trigger)
            // 通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            UNUserNotificationCenter.current().add(requestRepeat, withCompletionHandler: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay,execute: workItem)
    }
    
}
