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
    public func archievePerTime(_ perTime:Int,totalTime:Int){
        print("時間が基準\(perTime)に達したことをLocationに通知しました")
        annotationListStting()
        guard let latitude = latitude,let longitude = longitude else{return}
        let timeAnnotation = MapAnnotation()
        timeAnnotation.pedoElement = .time
        timeAnnotation.perValue = Double(perTime)
        timeAnnotation.totalValue = Double(totalTime)
        timeAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotationList.append(timeAnnotation)
        guard let map = map else{return}
        map.addAnnotation(timeAnnotation)
    }
    ///消費カロリーが基準を達したときに呼び出されるメソッド
    public func archievePerCalorie(_ perCalorie:Double,totalCalorie:Double){
        print("消費カロリーが基準\(perCalorie)に達したことをLocationに通知しました")
        annotationListStting()
        guard let latitude = latitude,let longitude = longitude else{return}
        let calorieAnnotation = MapAnnotation()
        calorieAnnotation.pedoElement = .calorie
        calorieAnnotation.perValue = perCalorie
        calorieAnnotation.totalValue = totalCalorie
        calorieAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotationList.append(calorieAnnotation)
        guard let map = map else{return}
        map.addAnnotation(calorieAnnotation)
    }
    ///ピンを格納しておくための配列の初期化を行うメソッド
    private func annotationListStting(){
        guard annotationList == nil else{return}
        annotationList = Array<MapAnnotation>()
    }
}
