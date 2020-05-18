//
//  ArchievePedometerElement.swift
//  Working
//
//  Created by 下川達也 on 2020/05/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import MapKit

extension LocationViewController{
    ///歩数が基準を達したときに呼び出されるメソッド
    public func archievePerSteps(_ perStepCount: Int, _ stepCount: Int){
        print("歩数が基準\(perStepCount)に達したことをLocationに通知しました")
        annotationListStting()
        guard let latitude = latitude,let longitude = longitude else{return}
        let stepAnnoation = MapAnnotation()
        stepAnnoation.pedoElement = .steps
        stepAnnoation.perValue = Double(perStepCount)
        stepAnnoation.totalValue = Double(stepCount)
        stepAnnoation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotationList.append(stepAnnoation)
        guard let map = map else{return}
        map.addAnnotation(stepAnnoation)
    }
    ///距離が基準を達したときに呼び出されるメソッド
    public func archievePerDistance(_ perDistance:Float,_ totalDistance:Float){
        print("距離が基準\(perDistance)に達したことをLocationに通知しました")
        annotationListStting()
        guard let latitude = latitude,let longitude = longitude else{return}
        let distanceAnnoation = MapAnnotation()
        distanceAnnoation.pedoElement = .distance
        distanceAnnoation.perValue = Double(perDistance)
        distanceAnnoation.totalValue = Double(totalDistance)
        distanceAnnoation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotationList.append(distanceAnnoation)
        guard let map = map else{return}
        map.addAnnotation(distanceAnnoation)
    }
    ///時間が基準を達したときに呼び出されるメソッド
    public func archievePerTime(_ perTime:Int,totalTime:Int,locationManagerDic:Dictionary<Double,CLLocationCoordinate2D>?){
        print("時間が基準\(perTime)に達したことをLocationに通知しました")
        annotationListStting()
        guard let locationManagerDic = locationManagerDic else{return}
        if self.locationManagerDic == nil{
            self.locationManagerDic = Dictionary<Double,CLLocationCoordinate2D>()
        }
        let timeAnnotation = MapAnnotation()
        timeAnnotation.pedoElement = .time
        timeAnnotation.perValue = Double(perTime)
        timeAnnotation.totalValue = Double(totalTime)
        timeAnnotation.coordinate = checkMostNearTimeCoordinate(totalTime,locationManagerDic)
        annotationList.append(timeAnnotation)
        guard let map = map else{return}
        map.addAnnotation(timeAnnotation)
    }
    ///消費カロリーが基準を達したときに呼び出されるメソッド
    public func archievePerCalorie(_ perCalorie:Double,totalCalorie:Double,locationManagerDic:Dictionary<Double,CLLocationCoordinate2D>?){
        print("消費カロリーが基準\(perCalorie)に達したことをLocationに通知しました")
        annotationListStting()
        guard let locationManagerDic = locationManagerDic else{return}
        guard let weight = UserDefaults.standard.value(forKey: PedoSaveElement.weight.rawValue) as? Double else{return}
        if self.locationManagerDic == nil{
            self.locationManagerDic = Dictionary<Double,CLLocationCoordinate2D>()
        }
        //消費カロリーをもとに何時間経っているかを計算する
        let totalTimeHour : Double =  totalCalorie/(3*weight)
        //秒に変換する
        let totalTime : Int = Int(totalTimeHour*60*60)
        let calorieAnnotation = MapAnnotation()
        calorieAnnotation.pedoElement = .calorie
        calorieAnnotation.perValue = perCalorie
        calorieAnnotation.totalValue = totalCalorie
        calorieAnnotation.coordinate = checkMostNearTimeCoordinate(totalTime,locationManagerDic)
        annotationList.append(calorieAnnotation)
        guard let map = map else{return}
        map.addAnnotation(calorieAnnotation)
    }
    private func checkMostNearTimeCoordinate(_ totalTime:Int,_ locationManagerDic:Dictionary<Double,CLLocationCoordinate2D>) -> CLLocationCoordinate2D{
        var minusTime = totalTime
        var location = CLLocationCoordinate2D()
        //キーを1つずつ取り出して一番近い確認する
        for key in locationManagerDic.keys{
            self.locationManagerDic[key] = locationManagerDic[key]
        }
        for key in self.locationManagerDic.keys{
            //現在最も近い時間よりも小さかったときの処理
            if Int(Double(totalTime) - key) < minusTime{
                minusTime = Int(Double(totalTime) - key)
                if let dicLocation = self.locationManagerDic[key]{
                    location = dicLocation
                }
            }
        }
        return location
    }
    ///ピンを格納しておくための配列の初期化を行うメソッド
    private func annotationListStting(){
        guard annotationList == nil else{return}
        annotationList = Array<MapAnnotation>()
    }
}
