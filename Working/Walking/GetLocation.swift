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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        print("位置情報が更新されましたViewController")
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
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
                    delegate.archievePerTime(perTime, totalTime: time)
                }
            }
        }
        //消費カロリーのビューコントローラーから取得する
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)) as? PedometerElementCell{
            //確認して前回のアップデートからperCalorieを超えていたときの処理
            if let perCalorie = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)).per as? Double,
                let calorie = cell.checkCellUpdateValue(IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)).total as? Double{
                if let delegate = delegate{
                    delegate.archievePerCalorie(perCalorie, totalCalorie: calorie)
                }
            }
        }
    }
}
