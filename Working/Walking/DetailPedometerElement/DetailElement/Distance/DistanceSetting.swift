//
//  DistanceSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension PedometerElementViewController{
    ///歩いた距離に関するセッティングを行うメソッド
    public func distanceSetting(){
        distanceViewSetting()
        distance = Float(0)
        distanceLabel = UILabel()
        distanceLabel.text = "\(distance != nil ? distance! : 0)"
        distanceLabel.font = .systemFont(ofSize: 40, weight: .bold)
        distanceLabel.textColor = .white
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x:distanceLabel.frame.size.width/2,y:distanceLabel.frame.size.height/2)
        distanceView.addSubview(distanceLabel)
        distanceUnitLabel = UILabel()
        distanceUnitLabel.text = "m"
        distanceUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        distanceUnitLabel.textColor = .white
        distanceUnitLabel.sizeToFit()
        distanceUnitLabel.center = CGPoint(x:distanceLabel.frame.maxX + 5 + distanceUnitLabel.frame.size.width/2,y:distanceLabel.frame.maxY - distanceUnitLabel.frame.size.height/2)
        distanceView.addSubview(distanceUnitLabel)
        distanceView.frame = CGRect(x: 0, y: 0, width: distanceUnitLabel.frame.maxX, height: max(distanceLabel.frame.maxY,distanceUnitLabel.frame.maxY))
        distanceView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + distanceView.frame.size.height/2)
        distance = Float(0)
    }
    private func distanceViewSetting(){
        if distanceView == nil{
            distanceView = UIView()
            self.view.addSubview(distanceView)
        }
    }
    public func resetDistance(){
        distance = nil
        updateDistanceLabel()
    }
    private func updateDistanceLabel(){
        distanceLabel.text = "\(distance != nil ? distance! : 0)"
        distanceLabel.font = .systemFont(ofSize: 40, weight: .bold)
        distanceLabel.textColor = .white
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x:distanceLabel.frame.size.width/2,y:distanceLabel.frame.size.height/2)
        distanceUnitLabel.center = CGPoint(x:distanceLabel.frame.maxX + 5 + distanceUnitLabel.frame.size.width/2,y:distanceLabel.frame.maxY - distanceUnitLabel.frame.size.height/2)
        distanceView.frame = CGRect(x: 0, y: 0, width: distanceUnitLabel.frame.maxX, height: max(distanceLabel.frame.maxY,distanceUnitLabel.frame.maxY))
        distanceView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + distanceView.frame.size.height/2)
        checkDistanceFontSize()
    }
    ///万歩計が更新されたときに呼び出されるメソッド
    public func updateDistance(_ distance:NSNumber?){
        guard let distance = distance else{return}
        //self.distance = Float(distance)
        //小数点第２位で四捨五入
        //self.distance = round(self.distance*10)/10
        checkArchibePerDistance(round(Float(distance)*10)/10)
        updateDistanceLabel()
    }
    ///距離が基準に達したかどうかを確認するためのメソッド
    private func checkArchibePerDistance(_ distance:Float){
        guard let _ = checkPerDistance else{return}
        if self.distance == nil{
            self.distance = Float(0)
        }
        ///引数であるdistanceはスタートしてからの合計距離を渡してくるので、前回の合計距離と今回の合計距離の引き算をパー距離に反映させる
        checkPerDistance -= (distance - self.distance)
        print("距離の基準まで後\(checkPerDistance!)")
        guard let _ = self.distance else{return}
        self.distance = distance
        guard checkPerDistance <= 0 else{return}
        print("距離が基準を超えました~~~")
        checkPerDistance = perDistance
        //通知のスイッチがオンになっているときだけ
        guard let notificationSwitch = notificationSwitch else{return}
        if notificationSwitch.isOn{
            if let delegate = delegate{
                delegate.archievePerDistance(perDistance,self.distance)
            }
            sendNotificationDistance("\(perDistance != nil ? perDistance! : 0)mを超えました。","現在の合計距離は\(self.distance != nil ? self.distance! : 0)mです。")
            //通知が終了してから10秒後に次の通知の準備をする
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {[weak self] in
                guard let _ = self else{return}
                self!.reading = Reading("距離が基準の\(self!.perDistance != nil ? Int(self!.perDistance!) : 0)メートルを超えました。現在の合計距離は\(Int(distance+self!.perDistance))メートルです。", .distance)
                self!.reading.readingToAudioFile()
            }
        }
    }
    private func distanceUpdate(){
        distanceLabel.center = CGPoint(x:distanceLabel.frame.size.width/2,y:distanceLabel.frame.size.height/2)
        distanceUnitLabel.center = CGPoint(x:distanceLabel.frame.maxX + 5 + distanceUnitLabel.frame.size.width/2,y:distanceLabel.frame.maxY - distanceUnitLabel.frame.size.height/2)
        distanceView.frame = CGRect(x: 0, y: 0, width: distanceUnitLabel.frame.maxX, height: max(distanceLabel.frame.maxY,distanceUnitLabel.frame.maxY))
        distanceView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + distanceView.frame.size.height/2)
    }
    ///開始と同時に呼ばれる関数(通知の前に通知するであろう読み上げ文をオーディオファイルに変換しておく)
    public func startDistance(){
        reading = Reading("距離が基準の\(perDistance != nil ? Int(perDistance!) : 0)メートルを超えました。現在の合計距離は\(Int(distance+perDistance))メートルです。", .distance)
        reading.readingToAudioFile()
    }
    private func checkDistanceFontSize(){
        distanceUpdate()
        while(self.view.frame.size.width*0.9<distanceView.frame.size.width){
            let size = distanceLabel.font.pointSize - 1
            distanceLabel.font = .systemFont(ofSize: size, weight: .bold)
            distanceLabel.sizeToFit()
            distanceUpdate()
        }
    }
    public func checkDistanceLocationUpdate() -> (Float?,Float?){
        //前回の位置情報更新のときよりもカウントが大きかったら・・・
        if locationUpdatePerDistance < checkPerDistance{
            //パー歩数と合計歩数を返す
            return (perDistance,distance)
        }else{
            return (nil,nil)
        }
    }
}
