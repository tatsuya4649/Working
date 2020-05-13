//
//  NotificationUnitLabel.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension NotificationSettingViewController{
    ///ピッカーの横に単位ラベルを設定する
    public func unitLabelSetting(_ unit:String){
        unitLabel = UILabel()
        unitLabel.text =  unit
        unitLabel.font = .systemFont(ofSize: 12, weight: .regular)
        unitLabel.textColor = .black
        unitLabel.sizeToFit()
        unitLabel.center = CGPoint(x: picker.frame.size.width - 10 - unitLabel.frame.size.width/2, y: picker.frame.size.height/2)
        picker.addSubview(unitLabel)
    }
    public func settingLabelSetting(_ title:String){
        settingLabel = UILabel()
        settingLabel.text = title
        settingLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        settingLabel.textColor = .black
        settingLabel.sizeToFit()
        settingLabel.center = CGPoint(x: self.preferredContentSize.width/2, y: picker.frame.minY - 10 - settingLabel.frame.size.height/2)
        self.view.addSubview(settingLabel)
    }
    public func explainLabel(_ title:String){
        explainLabel = UILabel()
        explainLabel.text = title
        explainLabel.font = .systemFont(ofSize: 12, weight: .regular)
        explainLabel.textColor = .black
        explainLabel.sizeToFit()
        explainLabel.numberOfLines = 0
        explainLabel.lineBreakMode = .byWordWrapping
        let size = explainLabel.sizeThatFits(CGSize(width: 0.8*self.preferredContentSize.width, height: CGFloat.greatestFiniteMagnitude))
        explainLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        explainLabel.center = CGPoint(x:self.preferredContentSize.width/2,y:picker.frame.maxY + 10 + explainLabel.frame.size.height/2)
        self.view.addSubview(explainLabel)
    }
    public func updateExplainLabel(_ title:String){
        explainLabel.text = title
        explainLabel.font = .systemFont(ofSize: 12, weight: .regular)
        explainLabel.textColor = .black
        explainLabel.sizeToFit()
        explainLabel.numberOfLines = 0
        explainLabel.lineBreakMode = .byWordWrapping
        let size = explainLabel.sizeThatFits(CGSize(width: 0.8*self.preferredContentSize.width, height: CGFloat.greatestFiniteMagnitude))
        explainLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        explainLabel.center = CGPoint(x:self.preferredContentSize.width/2,y:picker.frame.maxY + 10 + explainLabel.frame.size.height/2)
    }
}
