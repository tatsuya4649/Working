//
//  UISetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

public enum PedoSaveElement : String{
    case perSteps = "perSteps"
    case stepsCount = "stepsCount"
    case perDistance = "perDistance"
    case distance = "distance"
    case perTime = "perTime"
    case startTime = "startTime"
    case perCalorie = "perCalorie"
}

extension ViewController{
    ///読み込んだときにUIパーツをセットするための関数
    public func uiSetting(){
        let tabHeight = self.tabBarController != nil ? self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height : self.view.frame.size.height
        
        settingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.8*tabHeight))
        settingView.backgroundColor = .white
        settingView.layer.cornerRadius = 20
        settingView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        self.view.addSubview(settingView)
        settingViewGrad = CAGradientLayer()
        settingViewGrad.colors = [UIColor(red: 255/255, green: 235/255, blue: 54/255, alpha: 1).cgColor,UIColor(red: 255/255, green: 239/255, blue: 99/255, alpha: 1).cgColor]
        settingViewGrad.frame = settingView.bounds
        settingViewGrad.cornerRadius = settingView.layer.cornerRadius
        settingViewGrad.maskedCorners = settingView.layer.maskedCorners
        settingView.layer.insertSublayer(settingViewGrad, at: 0)
        
        let startHeight = (tabHeight - settingView.frame.maxY)/2
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: startHeight, height: startHeight))
        startButton.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        setButton()
        startButton.isSelected = false
        startButton.addTarget(self, action: #selector(startButtonClick), for: .touchUpInside)
        self.view.addSubview(startButton)
    }
    ///スタートボタンが押されたときの処理
    @objc func startButtonClick(_ sedner:UIButton){
        print("スタートボタンがクリックされました")
        switch startButton.isSelected{
        case false:
            startButton.setTitle(String.fontAwesomeIcon(name: .stop), for: .normal)
            startButton.isSelected = true
            if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.time.rawValue, section: 0)) as? PedometerElementCell{
                cell.startTimer()
            }
            if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)) as? PedometerElementCell{
                cell.startCalorie()
            }
            if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.steps.rawValue, section: 0)) as? PedometerElementCell{
                cell.startSteps()
            }
            if let cell = pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.distance.rawValue, section: 0)) as? PedometerElementCell{
                cell.startDistance()
            }
            setButton()
            pedometerSetting()
            guard let delegate = delegate else{return}
            delegate.startPedometer()
            saveTimerStartButton()
        case true:
            startButton.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
            startButton.isSelected = false
            setButton()
            resetPedometer()
            guard let delegate = delegate else {return}
            delegate.resetPedometer()
        default:break
        }
    }
    public func setButton(){
        let tabHeight = self.tabBarController != nil ? self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height : self.view.frame.size.height
        let startHeight = (tabHeight - settingView.frame.maxY)/2
        startButton.sizeToFit()
        startButton.titleLabel?.sizeToFit()
        startButton.frame = CGRect(x: 0, y: 0, width: startHeight, height: startHeight)
        startButton.layer.cornerRadius = startButton.frame.size.height/2
        startButton.backgroundColor = .white
        startButton.center = CGPoint(x: self.view.frame.size.width/2, y: settingView.frame.maxY + (tabHeight - settingView.frame.maxY)/2)
    }
    private func saveTimerStartButton(){
        UserDefaults.standard.setValue(Date(), forKey: PedoSaveElement.startTime.rawValue)
    }
    private func removeTimerStartButton(){
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.startTime.rawValue)
    }
}
