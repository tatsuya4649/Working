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

extension PedometerElementViewController:UIPopoverPresentationControllerDelegate{
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
    }
    @objc func notificationInfoClick(_ sender:UIButton){
        print("情報ボタンがクリックされました")
        notificationViewController = NotificationSettingViewController()
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
