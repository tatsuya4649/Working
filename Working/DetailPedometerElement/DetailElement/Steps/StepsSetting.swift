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
        stepsLabel = UILabel()
        stepsLabel.text = "\(stepsCount != nil ? stepsCount! : 0)"
        stepsLabel.font = .systemFont(ofSize: 40, weight: .bold)
        stepsLabel.textColor = .white
        stepsLabel.sizeToFit()
        stepsLabel.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + stepsLabel.frame.size.height/2)
        self.view.addSubview(stepsLabel)
        stepsUnitLabel = UILabel()
        stepsUnitLabel.text = "歩"
        stepsUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        stepsUnitLabel.textColor = .white
        stepsUnitLabel.sizeToFit()
        stepsUnitLabel.center = CGPoint(x: stepsLabel.frame.maxX + 5 + stepsUnitLabel.frame.size.width/2, y: stepsLabel.frame.maxY - stepsUnitLabel.frame.size.height/2)
        self.view.addSubview(stepsUnitLabel)
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
        stepsLabel.center = CGPoint(x: self.view.frame.size.width/2, y: pedoElementLalbel.frame.maxY + 10 + stepsLabel.frame.size.height/2)
        stepsUnitLabel.center = CGPoint(x: stepsLabel.frame.maxX + 5 + stepsUnitLabel.frame.size.width/2, y: stepsLabel.frame.maxY - stepsUnitLabel.frame.size.height/2)
    }
    ///歩数が更新されたときに呼び出されるメソッド
    public func updataSteps(_ steps:NSNumber){
        stepsCount = Int(steps)
        updateStepsLabel()
    }
}
