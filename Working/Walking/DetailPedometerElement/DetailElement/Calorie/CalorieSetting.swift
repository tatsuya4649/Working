//
//  CalorieSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

extension PedometerElementViewController{
    ///消費したカロリーに関するUIパーツのセッティングを行うメソッド
    ///ちなみに消費カロリーはウォーキングの時間に依存するので、更新はタイマーの方で行う
    public func calorieSetting(){
        if calorieView == nil{
            calorieView = UIView()
            self.view.addSubview(calorieView)
        }
        calorieLabel = UILabel()
        calorieLabel.text = "\(calorie != nil ? calorie! : 0)"
        calorieLabel.font = .systemFont(ofSize: 40, weight: .bold)
        calorieLabel.textColor = .white
        calorieLabel.sizeToFit()
        calorieLabel.center = CGPoint(x: calorieLabel.frame.size.width/2, y: calorieLabel.frame.size.height/2)
        calorieView.addSubview(calorieLabel)
        calorieUnitLabel = UILabel()
        calorieUnitLabel.text = "kcal"
        calorieUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        calorieUnitLabel.textColor = .white
        calorieUnitLabel.sizeToFit()
        calorieUnitLabel.center = CGPoint(x: calorieLabel.frame.maxX + 5 + calorieUnitLabel.frame.size.width/2, y: calorieLabel.frame.maxY - calorieUnitLabel.frame.size.height/2)
        calorieView.addSubview(calorieUnitLabel)
        
        calorieView.frame = CGRect(x: 0, y: 0, width: calorieUnitLabel.frame.maxX - calorieLabel.frame.minX, height: max(calorieUnitLabel.frame.maxY,calorieLabel.frame.maxY))
        calorieView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + calorieLabel.frame.size.height/2)
        let types = Set([
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        ])
        healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: nil, read: types as! Set<HKObjectType>, completion: {[weak self] (bool,error) in
            guard let _ = self else{return}
            guard error == nil else{
                print(error?.localizedDescription)
                return
            }
        })
        getWeight()
    }
    public func resetCalorie(){
        if startButtonOn != nil{
            startButtonOn = nil
        }
        calorie = nil
        updateCalorieLabel()
        calorieSizeUpdate()
        removeCalorieNotification()
    }
    ///ヘルスキットから体重を取得するための関数
    private func getWeight(){
        guard let healthStore = healthStore else {return}
        let type = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let query = HKSampleQuery(sampleType: type!, predicate: nil, limit: 10, sortDescriptors: nil, resultsHandler: {[weak self] query, data, error in
            guard let _ = self else{return}
            if let data = data?.first as? HKQuantitySample{
                print("Weight => \(data.quantity.doubleValue(for: HKUnit.gram())/1000)")
                self!.weight = Double(data.quantity.doubleValue(for: HKUnit.gram())/1000)
            }else{
                print("OOPS didnt get height \nResults => \(data), error => \(error)")
            }
        })
        healthStore.execute(query)
    }
    private func updateCalorieLabel(){
        calorieLabel.text = "\(calorie != nil ? calorie! : 0)"
        calorieLabel.font = .systemFont(ofSize: 40, weight: .bold)
        calorieLabel.textColor = .white
        calorieLabel.sizeToFit()
        calorieLabel.center = CGPoint(x: calorieLabel.frame.size.width/2, y: calorieLabel.frame.size.height/2)
        calorieUnitLabel.center = CGPoint(x: calorieLabel.frame.maxX + 5 + calorieUnitLabel.frame.size.width/2, y: calorieLabel.frame.maxY - calorieUnitLabel.frame.size.height/2)
    }
    private func calorieSizeUpdate(){
        calorieLabel.center = CGPoint(x: calorieLabel.frame.size.width/2, y: calorieLabel.frame.size.height/2)
        calorieUnitLabel.center = CGPoint(x: calorieLabel.frame.maxX + 5 + calorieUnitLabel.frame.size.width/2, y: calorieLabel.frame.maxY - calorieUnitLabel.frame.size.height/2)
        calorieView.frame = CGRect(x: 0, y: 0, width: calorieUnitLabel.frame.maxX - calorieLabel.frame.minX, height: max(calorieUnitLabel.frame.maxY,calorieLabel.frame.maxY))
        calorieView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + calorieLabel.frame.size.height/2)
    }
    private func calorieFontSizeCheck(){
        calorieSizeUpdate()
        while(self.view.frame.size.width*0.9<calorieView.frame.size.width){
            let size = calorieLabel.font.pointSize - 1
            calorieLabel.font = .systemFont(ofSize: size, weight: .bold)
            calorieLabel.sizeToFit()
            calorieSizeUpdate()
        }
    }
    public func updateCalorie(_ time:Int){
        let hours : Double = Double(Double(time)/(60*60))
        checkArchievePerCalorie(3*Double(Double(1)/(60*60))*(weight != nil ? weight!:60))
        //消費カロリーの計算式(3[MET] x ウォーキングの時間[時間] x 体重[kg])にそれぞれの値を代入して算出
        calorie = 3*hours*(weight != nil ? weight!:60)
        calorie = round(calorie*10)/10
        updateCalorieLabel()
        calorieFontSizeCheck()
    }
    ///消費カロリー量が基準に達成したかどうかを確認するメソッド
    private func checkArchievePerCalorie(_ calorie:Double){
        guard let _ = checkPerCalorie else{return}
        checkPerCalorie -= calorie
        print("消費カロリーの基準まで後\(checkPerCalorie!)")
        guard checkPerCalorie <= 0 else{return}
        print("消費カロリーが基準を超えました〜〜")
        //guard let notificationSwitch = notificationSwitch else{return}
        //if notificationSwitch.isOn{
            //sendNotificationCalorie("\(perTime != nil ? perTime! : 0)kcalを超えました。","現在の合計消費カロリーは\(self.time != nil ? self.time! : 0)kcalです。")
            //reading = Reading("消費カロリーが基準の\(perCalorie != nil ? Int(perCalorie!) : 0)キロカロリーを超えました。現在の合計消費カロリーは\(self.calorie != nil ? Int(self.calorie!) : 0)キロカロリーです。", .calorie)
            //reading.readingSentences()
            //if let delegate = delegate{
                //delegate.archievePerCalorie(perCalorie, totalCalorie: self.calorie)
            //}
        //}
        checkPerCalorie = perCalorie
    }
    ///スタートボタンがクリックされたらすぐに消費カロリーの通知の準備をする
    public func startCalorie(){
        print("消費カロリーがスタートしました")
        startButtonOn = true
        //通知のスイッチがオンになっているときだけ
        guard let notificationSwitch = notificationSwitch else{return}
        DispatchQueue.main.async {[weak self] in
            guard let _ = self else{return}
            if notificationSwitch.isOn{
                self!.sendNotificationCalorie(nil, "\(self!.perCalorie != nil ? Int(self!.perCalorie) : 0)kcalを超えました。")
                self!.reading = Reading("消費カロリーが基準の\(self!.perCalorie != nil ? Int(self!.perCalorie!) : 0)キロカロリーを超えました。", .calorie)
                self!.reading.readingToAudioFile()
                //if let delegate = self!.delegate{
                    //delegate.archievePerTime(self!.perTime, totalTime: self!.time)
                //}
            }
        }
    }
    ///消費カロリーの登録済みの通知を全て削除するための関数
    public func removeCalorieNotification(){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
            print(request)
        })
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { request in
            print(request)
        })
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [pedoElementNotification.calorie.rawValue])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pedoElementNotification.calorie.rawValue])
        print("消費カロリー通知の削除に成功しました")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
            print(request)
        })
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { request in
            print(request)
        })
    }
    ///消費カロリーの通知をあらためて作成するための関数
    public func restartCalorieNotification(){
        //スタートボタンがオンじゃないとき(万歩計が動いていないとき)は通知を作成しない
        guard let _ = startButtonOn else{return}
        let timer = (self.checkPerCalorie != nil ? self.checkPerCalorie! : 150.0) / (3*(self.weight != nil ? self.weight! : 60))
        let perSec = 60*60*timer
        sendNotificationCalorie(nil, "\(self.perCalorie != nil ? Int(self.perCalorie) : 0)kcalを超えました。", Double(perSec))
    }
    public func checkCalorieLocationUpdate() -> (Double?,Double?){
        //前回の位置情報更新のときよりもカウントが大きかったら・・・
        if locationUpdatePerCalorie < checkPerCalorie{
            //パー歩数と合計歩数を返す
            return (perCalorie,calorie)
        }else{
            return (nil,nil)
        }
    }
}
