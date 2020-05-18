//
//  PedometerSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import CoreLocation

protocol ViewControllerDelegate : AnyObject {
    ///万歩計がリセットされたときに呼び出されるデリゲートメソッド
    func resetPedometer()
    ///万歩計がスタートしたときに呼び出されるデリゲートメソッド
    func startPedometer()
    ///現在位置が更新されたときに呼び出されるデリゲートメソッド
    func updataLocation(_ location:CLLocationCoordinate2D)
    ///基準の歩数を超えたときに呼び出されるデリゲートメソッド
    func archievePerSteps(_ perStepCount:Int,_ stepCount:Int)
    ///基準の距離を超えたときに呼び出されるデリゲートメソッド
    func archievePerDistance(_ perDistance:Float,_ totalDistance:Float)
    ///基準の時間を超えたときに呼び出されるデリゲートメソッド
    func archievePerTime(_ perTime:Int,totalTime:Int,locationManagerDic:Dictionary<Double,CLLocationCoordinate2D>?)
    ///基準の消費カロリーを超えたときに呼び出されるデリゲートメソッド
    func archievePerCalorie(_ perCalorie:Double,totalCalorie:Double,locationManagerDic:Dictionary<Double,CLLocationCoordinate2D>?)
}
extension ViewController{
    ///万歩計のセッティング
    public func pedometerSetting(){
        guard pedometer == nil else{return}
        pedometer = CMPedometer()
        pedometer.startUpdates(from: Date(), withHandler: { [weak self] (pedometerData,error) in
            
            DispatchQueue.main.async {
                print("歩数が更新されました")
                guard let _ = self else{return}
                guard error == nil else{
                    print(error!.localizedDescription)
                    return
                }
                guard let data = pedometerData else{return}
                print(data)
                if let cell = self!.pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0)) as? PedometerElementCell{
                    cell.updataSteps(data.numberOfSteps)
                }
                if let cell = self!.pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0)) as? PedometerElementCell{
                    cell.updateDistance(data.distance)
                }
            }
        })
    }
    ///万歩計をリセットするための関数
    public func resetPedometer(){
        if pedometer != nil{
            pedometer.stopUpdates()
            pedometer = nil
        }
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0)) as? PedometerElementCell{
            cell.resetValue(IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0))
        }
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0)) as? PedometerElementCell{
            cell.resetValue(IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0))
        }
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.time.rawValue, section: 0)) as? PedometerElementCell{
            cell.resetValue(IndexPath(item: PedometerElementNumber.time.rawValue, section: 0))
        }
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)) as? PedometerElementCell{
            cell.resetValue(IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0))
        }
    }
    ///万歩計をストップさせるための関数
    public func stopPedometer(){
        if pedometer != nil{
            pedometer.stopUpdates()
            pedometer = nil
        }
        if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.time.rawValue, section: 0)) as? PedometerElementCell{
            cell.stopTimer()
        }
    }
}
