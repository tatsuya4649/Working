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

extension ViewController{
    ///万歩計のセッティング
    public func pedometerSetting(){
        pedometer = CMPedometer()
        pedometer.startUpdates(from: Date(), withHandler: { [weak self] (pedometerData,error) in
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
        })
    }
    ///万歩計をリセットするための関数
    public func resetPedometer(){
        guard let _ = pedometer else{return}
        pedometer.stopUpdates()
        pedometer = nil
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
}
