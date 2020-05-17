//
//  NotificationSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/16.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension TabBarController:UNUserNotificationCenterDelegate{
    ///通知の設定をする関数
    public func settingNotification(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            if error != nil {
                return
            }
            if granted {
                print("通知許可")
                let center = UNUserNotificationCenter.current()
                center.delegate = self
            } else {
                print("通知拒否")
            }
        })
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])  // 通知バナー表示、通知音の再生を指定
    }
}
