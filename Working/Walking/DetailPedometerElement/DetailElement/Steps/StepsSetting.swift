//
//  StepsSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension PedometerElementViewController{
    ///歩数に関するUIパーツのセッティングを行うメソッド
    public func stepsSetting(){
        stepsViewSetting()
        stepsCount = Int(0)
        stepsLabel = UILabel()
        stepsLabel.text = "\(stepsCount != nil ? stepsCount! : 0)"
        stepsLabel.font = .systemFont(ofSize: 40, weight: .bold)
        stepsLabel.textColor = .white
        stepsLabel.sizeToFit()
        stepsLabel.center = CGPoint(x: stepsLabel.frame.size.width/2, y: stepsLabel.frame.size.height/2)
        stepsView.addSubview(stepsLabel)
        stepsUnitLabel = UILabel()
        stepsUnitLabel.text = "歩"
        stepsUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        stepsUnitLabel.textColor = .white
        stepsUnitLabel.sizeToFit()
        stepsUnitLabel.center = CGPoint(x: stepsLabel.frame.maxX + 5 + stepsUnitLabel.frame.size.width/2, y: stepsLabel.frame.maxY - stepsUnitLabel.frame.size.height/2)
        stepsView.addSubview(stepsUnitLabel)
        stepsView.frame = CGRect(x: 0, y: 0, width: stepsUnitLabel.frame.maxX, height: max(stepsLabel.frame.maxY,stepsUnitLabel.frame.maxY))
        stepsView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + stepsView.frame.size.height/2)
    }
    private func stepsViewSetting(){
        if stepsView == nil{
            stepsView = UIView()
            self.view.addSubview(stepsView)
        }
    }
    public func resetStep(){
        stepsCount = nil
        updateStepsLabel()
    }
    private func updateStepsLabel(){
        stepsLabel.text = "\(stepsCount != nil ? stepsCount! : 0)"
        stepsLabel.font = .systemFont(ofSize: 40, weight: .bold)
        stepsLabel.textColor = .white
        stepsLabel.sizeToFit()
        stepsLabel.center = CGPoint(x: stepsLabel.frame.size.width/2, y: stepsLabel.frame.size.height/2)
        stepsUnitLabel.center = CGPoint(x: stepsLabel.frame.maxX + 5 + stepsUnitLabel.frame.size.width/2, y: stepsLabel.frame.maxY - stepsUnitLabel.frame.size.height/2)
        stepsView.frame = CGRect(x: 0, y: 0, width: stepsUnitLabel.frame.maxX, height: max(stepsLabel.frame.maxY,stepsUnitLabel.frame.maxY))
        stepsView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + stepsView.frame.size.height/2)
        checkStepsFontSize()
    }
    private func stepsUpdate(){
        stepsLabel.center = CGPoint(x: stepsLabel.frame.size.width/2, y: stepsLabel.frame.size.height/2)
        stepsUnitLabel.center = CGPoint(x: stepsLabel.frame.maxX + 5 + stepsUnitLabel.frame.size.width/2, y: stepsLabel.frame.maxY - stepsUnitLabel.frame.size.height/2)
        stepsView.frame = CGRect(x: 0, y: 0, width: stepsUnitLabel.frame.maxX, height: max(stepsLabel.frame.maxY,stepsUnitLabel.frame.maxY))
        stepsView.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + stepsView.frame.size.height/2)
    }
    ///歩数が更新されたときに呼び出されるメソッド
    public func updataSteps(_ steps:NSNumber){
        //stepsCount = Int(steps)
        checkArchievePerSteps(Int(steps))
        updateStepsLabel()
    }
    ///開始と同時に呼ばれる関数(通知の前に通知するであろう読み上げ文をオーディオファイルに変換しておく)
    public func startSteps(){
        reading = Reading("歩数が基準の\(perStepsCount != nil ? perStepsCount! : 0)歩を超えました。現在の合計歩数は\(stepsCount+perStepsCount)歩です。", .steps)
        reading.readingToAudioFile()
    }
    ///歩数の基準値に達成したかどうかを確認するメソッド
    private func checkArchievePerSteps(_ steps:Int){
        guard let _ = checkPerStepsCount else{return}
        if stepsCount == nil{
            stepsCount = Int(0)
        }
        //引数であるstepsはスタートしてからの合計歩数を渡してくるので、前回イベントと今回イベントの引き算でパーステップカウントを引く
        checkPerStepsCount -= (steps - stepsCount)
        print("歩数の基準まで後\(checkPerStepsCount!)")
        guard let _ = stepsCount else{return}
        stepsCount = steps
        guard checkPerStepsCount <= 0 else{return}
        print("歩数が基準を超えました~~~")
        checkPerStepsCount = perStepsCount
        //通知のスイッチがオンになっているときだけ
        guard let notificationSwitch = notificationSwitch else{return}
        if notificationSwitch.isOn{
            if let delegate = delegate{
                print("地図にも基準を超えたことを知らせてあげる")
                delegate.archievePerSteps(perStepsCount,stepsCount)
            }
            DispatchQueue.main.async {[weak self] in
                guard let _ = self else{return}
                self!.sendNotificationSteps("\(self!.perStepsCount != nil ? self!.perStepsCount! : 0)歩を超えました。","現在の合計歩数は\(self!.stepsCount != nil ? self!.stepsCount! : 0)歩です。")
            }
            //通知が終了してから10秒後に次の通知の準備をする
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {[weak self] in
                guard let _ = self else{return}
                self!.reading = Reading("歩数が基準の\(self!.perStepsCount != nil ? self!.perStepsCount! : 0)歩を超えました。現在の合計歩数は\(steps+self!.perStepsCount)歩です。", .steps)
                self!.reading.readingToAudioFile()
            }
        }
    }
    private func checkStepsFontSize(){
        stepsUpdate()
        while(self.view.frame.size.width*0.9<stepsView.frame.maxX){
            let size = stepsLabel.font.pointSize - 1
            stepsLabel.font = .systemFont(ofSize: size, weight: .bold)
            stepsLabel.sizeToFit()
            stepsUpdate()
        }
    }
    public func checkStepsLocationUpdate() -> (Int?,Int?){
        //前回の位置情報更新のときよりもカウントが大きかったら・・・
        if locationUpdatePerStepsCount < checkPerStepsCount{
            //パー歩数と合計歩数を返す
            return (perStepsCount,stepsCount)
        }else{
            return (nil,nil)
        }
    }
}
