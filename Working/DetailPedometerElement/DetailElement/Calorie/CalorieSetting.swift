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
        calorieLabel = UILabel()
        calorieLabel.text = "\(calorie != nil ? calorie! : 0)"
        calorieLabel.font = .systemFont(ofSize: 40, weight: .bold)
        calorieLabel.textColor = .white
        calorieLabel.sizeToFit()
        calorieLabel.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + calorieLabel.frame.size.height/2)
        self.view.addSubview(calorieLabel)
        calorieUnitLabel = UILabel()
        calorieUnitLabel.text = "kcal"
        calorieUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        calorieUnitLabel.textColor = .white
        calorieUnitLabel.sizeToFit()
        calorieUnitLabel.center = CGPoint(x: calorieLabel.frame.maxX + 5 + calorieUnitLabel.frame.size.width/2, y: calorieLabel.frame.maxY - calorieUnitLabel.frame.size.height/2)
        self.view.addSubview(calorieUnitLabel)
        
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
        calorie = nil
        updateCalorieLabel()
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
        calorieLabel.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + calorieLabel.frame.size.height/2)
        calorieUnitLabel.center = CGPoint(x: calorieLabel.frame.maxX + 5 + calorieUnitLabel.frame.size.width/2, y: calorieLabel.frame.maxY - calorieUnitLabel.frame.size.height/2)
    }
    public func updateCalorie(_ time:Int){
        let hours : Double = Double(Double(time)/(60*60))
        //消費カロリーの計算式(3[MET] x ウォーキングの時間[時間] x 体重[kg])にそれぞれの値を代入して算出
        calorie = 3*hours*(weight != nil ? weight!:60)
        calorie = round(calorie*10)/10
        updateCalorieLabel()
    }
}
