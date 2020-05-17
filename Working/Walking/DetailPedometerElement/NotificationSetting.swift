//
//  NotificationSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension PedometerElementViewController:UIPopoverPresentationControllerDelegate,NotificationSettingViewControllerDelegate{
    func changeStepsSettingValue(_ steps: Int) {
        //この項目が歩数であることを確認する
        guard let pedoElement = pedoElement else{return}
        guard pedoElement == .steps else{return}
        checkPerStepsCount += (steps-perStepsCount)
        perStepsCount = steps
    }
    
    func changeDistanceSettingValue(_ distance: Double) {
        //この項目が距離であることを確認する
        guard let pedoElement = pedoElement else{return}
        guard pedoElement == .distance else{return}
        checkPerDistance += (Float(distance)-checkPerDistance)
        perDistance = Float(distance)
    }
    
    func changeTimeSettingValue(_ time: Double) {
        //この項目が時間であることを確認する
        guard let pedoElement = pedoElement else{return}
        guard pedoElement == .time else{return}
        checkPerTime += (Int(time)-checkPerTime)
        perTime = Int(perTime)
    }
    
    func changeCalorieSettingValue(_ calorie: Double) {
        //この項目が消費カロリーであることを確認する
        guard let pedoElement = pedoElement else{return}
        guard pedoElement == .calorie else{return}
        checkPerCalorie += (calorie-checkPerCalorie)
        perCalorie = calorie
    }
    
    ///通知機能に関するセッティング
    public func notificationSetting(){
        notificationSwitch = UISwitch()
        notificationSwitch.isOn = true
        notificationBool = true
        notificationSwitch.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        notificationSwitch.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        notificationSwitch.sizeToFit()
        notificationSwitch.layer.cornerRadius = notificationSwitch.frame.size.height/2
        notificationSwitch.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height - 20 - notificationSwitch.frame.size.height/2)
        self.view.addSubview(notificationSwitch)
        notificationLabel = UILabel()
        notificationLabel.text = "通知"
        notificationLabel.font = .systemFont(ofSize: 12, weight: .regular)
        notificationLabel.textColor = defaultColor
        notificationLabel.sizeToFit()
        notificationLabel.center = CGPoint(x: self.view.frame.size.width/2, y: notificationSwitch.frame.minY - 10 - notificationLabel.frame.size.height/2)
        self.view.addSubview(notificationLabel)
        notificationButton = UIButton()
        notificationButton.setTitle(String.fontAwesomeIcon(name: .infoCircle), for: .normal)
        notificationButton.setTitleColor(defaultColor, for: .normal)
        notificationButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        notificationButton.sizeToFit()
        notificationButton.titleLabel?.sizeToFit()
        notificationButton.center = CGPoint(x: notificationLabel.frame.maxX + notificationButton.frame.size.width/2, y: notificationLabel.center.y)
        notificationButton.addTarget(self, action: #selector(notificationInfoClick), for: .touchUpInside)
        self.view.addSubview(notificationButton)
    }
    @objc func changeSwitch(_ sender:UISwitch){
        print("スイッチが\(sender.isOn)に切り替わりました")
        notificationBool = sender.isOn
        guard pedoElement == .time || pedoElement == .calorie else{return}
        print("通知の設定を変更します")
        ///スイッチがオフになったときの処理(送信ずみの通知を全て削除する)
        if sender.isOn == false{
            if pedoElement == .time{
                removeTimerNotification()
            }else if pedoElement == .calorie{
                removeCalorieNotification()
            }
            ///スイッチがオンになったときの処理(次の時間:checkPerTime)からperTime感覚で通知を送信する
        }else{
            //ただしスタートボタンがオンになっていない場合は無視する
            if pedoElement == .time{
                restartTimerNotification()
            }else if pedoElement == .calorie{
                restartCalorieNotification()
            }
        }
    }
    @objc func notificationInfoClick(_ sender:UIButton){
        print("情報ボタンがクリックされました")
        notificationViewController = NotificationSettingViewController()
        notificationViewController.delegate = self
        notificationViewController.modalPresentationStyle = .popover
        notificationViewController.preferredContentSize = CGSize(width: 200, height: 300)
        notificationViewController.popoverPresentationController?.sourceView = sender.superview
        notificationViewController.popoverPresentationController?.sourceRect = sender.frame
        notificationViewController.popoverPresentationController?.delegate = self
        switch pedoElement {
        case .steps:
            notificationViewController.popoverPresentationController?.permittedArrowDirections = .up
            notificationViewController.stepsSetting()
        case .distance:
            notificationViewController.popoverPresentationController?.permittedArrowDirections = .up
            notificationViewController.distanceSetting()
        case .time:
            notificationViewController.popoverPresentationController?.permittedArrowDirections = .down
            notificationViewController.timeSetting()
        case .calorie:
            notificationViewController.popoverPresentationController?.permittedArrowDirections = .down
            notificationViewController.weight = weight
            notificationViewController.calorieSetting()
        default:break
        }
        present(notificationViewController,animated: true)
    }
    
    //iPhoneで表示させるために必要なデリゲートメソッド
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
