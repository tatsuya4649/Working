//
//  GetLocation.swift
//  Working
//
//  Created by 下川達也 on 2020/05/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreLocation

extension ViewController:CLLocationManagerDelegate{
    public func settingLocationManager(){
        locationManager = CLLocationManager()
        locationManagerDic = Dictionary<Double,CLLocationCoordinate2D>()
        guard let locationManager = locationManager else{return}
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.showsBackgroundLocationIndicator = false
            locationManager.startUpdatingLocation()
        }
    }
    ///万歩計が終了したときに現在地の更新も終了させる
    public func locationRemove(){
        guard let _ = locationManager else{return}
        locationManager.stopUpdatingLocation()
        locationManager = nil
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        print("位置情報が更新されましたViewController")
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        startTimeLocation(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        ///スタートしていなければ現在地をデリゲートメソッドに通知する必要はない
        guard startButton.isSelected else{return}
        checkCellUpdateValue()
        guard let delegate = delegate else{return}
        delegate.updataLocation(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }

    ///前回の位置情報の更新からPedoElementの各項目に閾値が超えたものがないかどうかを探す関数
    private func checkCellUpdateValue(){
        //歩数のビューコントローラーから取得する
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0)) as? PedometerElementCell{
            //確認して前回のアップデートからperStepを超えていたときの処理
            if let perStep = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0)).per as? Int,
                let stepsCount = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0)).total as? Int{
                
            }
        }
        //距離のビューコントローラーから取得する
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0)) as? PedometerElementCell{
            //確認して前回のアップデートからperDistanceを超えていたときの処理
            if let perDistance = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0)).per as? Float,
                let distance = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0)).total as? Float{
                
            }
        }
        //時間のビューコントローラーから取得する
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.time.rawValue, section: 0)) as? PedometerElementCell{
            //確認して前回のアップデートからperTimeを超えていたときの処理
            if let perTime = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.time.rawValue, section: 0)).per as? Int,
                let time = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.time.rawValue, section: 0)).total as? Int{
                if let delegate = delegate{
                    delegate.archievePerTime(perTime, totalTime: time, locationManagerDic: locationManagerDic)
                }
            }
        }
        //消費カロリーのビューコントローラーから取得する
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)) as? PedometerElementCell{
            //確認して前回のアップデートからperCalorieを超えていたときの処理
            if let perCalorie = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)).per as? Double,
                let calorie = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)).total as? Double{
                if let delegate = delegate{
                    delegate.archievePerCalorie(perCalorie, totalCalorie: calorie, locationManagerDic: locationManagerDic)
                }
            }
        }
    }
    ///スタートした時刻から今までの時間を秒で取得して、座標と共にlocationManagerDicに格納する関数
    private func startTimeLocation(_ location:CLLocationCoordinate2D){
        guard let startTime = UserDefaults.standard.value(forKey: PedoSaveElement.startTime.rawValue) as? Date else{return}
        //スタートした時間から今までの合計秒数を取得する
        let nowFromStartTime = Date().timeIntervalSince(startTime)
        let doubleNowFromStartTime = Double(nowFromStartTime)
        //キー:スタート時刻からの秒数,値:座標
        locationManagerDic[doubleNowFromStartTime] = location
    }
    ///閉じた時間から開いた時間までの差とパータイムを使用して閉じていた間に何回パータイムがすぎたのかどうかを調べる関数
    public func fromCloseTimeToOpenTimeTime(){
        //スタートボタンが押された時間を調べる
        guard let startTime = UserDefaults.standard.value(forKey: PedoSaveElement.startTime.rawValue) as? Date else{return}
        //アプリを閉じた時間を取得する
        guard let closeTime =  UserDefaults.standard.value(forKey: PedoSaveElement.closeTime.rawValue) as? Date else{return}
        //保存してあるパータイムを取得する
        guard let perTime = UserDefaults.standard.value(forKey: PedoSaveElement.perTime.rawValue) as? Int else{return}
        //現在時刻
        let now = Date()
        //スタートから今までの時間を秒で取得
        let nowFromStartSec = now.timeIntervalSince(startTime)
        //スタートからクローズまでの時間を秒で取得
        let closeFromStartSec = closeTime.timeIntervalSince(startTime)
        //スタートから今までのパータイムがすぎた回数を取得
        let totalTimes = Int(nowFromStartSec/Double(perTime))
        //スタートからクローズまでのパータイムがすぎた回数を取得
        let closeFromStartTimes = Int(closeFromStartSec/Double(perTime))
        //クローズしてから今までのパータイムがすぎた回数を取得
        let nowFromCloseTimes = totalTimes - closeFromStartTimes
        //1回以上すぎていた場合のみ地図にピンする
        guard nowFromCloseTimes > 0 else{return}
        for i in 0..<nowFromCloseTimes{
            //スタートしてからiまでの合計回数を取得
            let iTotalTimes =  closeFromStartTimes + i
            //スタートしてからiまでの合計時間を取得
            let iFromStartTime = iTotalTimes * perTime
            guard let delegate = delegate else{return}
            delegate.archievePerTime(perTime, totalTime: iFromStartTime, locationManagerDic: locationManagerDic)
        }
    }
    //閉じた時間から開いた時間までの差とパーカロリーを使用して閉じていた間に何回パーカロリーがすぎたのかを調べる関数
    public func fromCloseTimeToOpenTimeCalorie(){
        //スタートボタンを押されたときの時間を取得する
        guard let startTime = UserDefaults.standard.value(forKey: PedoSaveElement.startTime.rawValue) as? Date else{return}
        //アプリを閉じたとkいの時間を取得する
        guard let closeTime = UserDefaults.standard.value(forKey: PedoSaveElement.closeTime.rawValue) as? Date else{return}
        //保存してあるパーカロリーを取得する
        guard let perCalorie = UserDefaults.standard.value(forKey: PedoSaveElement.perCalorie.rawValue) as? Double else{return}
        //保存してある体重を取得する
        guard let weight = UserDefaults.standard.value(forKey: PedoSaveElement.weight.rawValue) as? Double else{return}
        //現在時刻を取得する
        let now = Date()
        //スタートから今までの時間を秒で取得
        let nowFromStartSec = now.timeIntervalSince(startTime)
        //スタートからクローズまでの時間を秒で取得
        let closeFromStartSec = closeTime.timeIntervalSince(startTime)
        //パーカロリーを消費するのにかかる時間パーカロリータイムを取得
        let perCaloriePerTime = perCalorie/(3*weight)
        let perCaloriePerTimeSec = perCaloriePerTime * 60 * 60
        //スタートから今までのパーカロリータイムがすぎた回数を取得
        let totalPerCalorieTimes = Int(nowFromStartSec/Double(perCaloriePerTimeSec))
        //スタートからクローズまでのパーカロリータイムがすぎた回数を取得
        let closeFromStartPerCalorieTimes = Int(closeFromStartSec/Double(perCaloriePerTimeSec))
        //クローズしてから今までのパーカロリータイムがすぎた回数を取得
        let nowFromClosePerCalorieTimes = totalPerCalorieTimes - closeFromStartPerCalorieTimes
        //1回以上すぎていた場合のみ地図にピンする
        guard nowFromClosePerCalorieTimes > 0 else{return}
        for i in 0..<nowFromClosePerCalorieTimes{
            //スタートしてからiまでの合計回数を取得
            let iTotalPerCalorieTimes = closeFromStartPerCalorieTimes + i
            //スタートしてからiまでの合計時間を取得
            let iFromStartTime = iTotalPerCalorieTimes + i
            //スタートしてからiまでの合計時間を時間(hour)に変換
            let iFromStartTimeHour = Double(iFromStartTime)/(Double(60*60))
            //スタートしてからiまでの合計消費カロリーを取得
            let iFromStartTotalCalorie = 3*weight*Double(iFromStartTimeHour)
            //デリゲートに渡して地図上にピンをする
            guard let delegate = delegate else{return}
            delegate.archievePerCalorie(perCalorie, totalCalorie: iFromStartTotalCalorie, locationManagerDic: locationManagerDic)
        }
    }
}
