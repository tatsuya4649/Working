//
//  CalorieWeightSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension NotificationSettingViewController:UITextFieldDelegate{
    ///カロリー消費通知のところに体重設定欄を記載しておく
    public func settingCalorieWeight(){
        settingLabel.center = CGPoint(x: self.preferredContentSize.width/2, y: 10 + settingLabel.frame.size.height/2)
        picker.center = CGPoint(x: self.preferredContentSize.width/2, y: settingLabel.frame.maxY + 10 + picker.frame.size.height/2)
        explainLabel.center = CGPoint(x:self.preferredContentSize.width/2,y:picker.frame.maxY + 10 + explainLabel.frame.size.height/2)
        calorieWeightLabel = UILabel()
        calorieWeightLabel.text = "設定体重"
        calorieWeightLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        calorieWeightLabel.textColor = .black
        calorieWeightLabel.sizeToFit()
        calorieWeightLabel.center = CGPoint(x: 20 + calorieWeightLabel.frame.size.width/2, y: explainLabel.frame.maxY + 20 + calorieWeightLabel.frame.size.height/2)
        self.view.addSubview(calorieWeightLabel)
        calorieWeightUnitLabel = UILabel()
        calorieWeightUnitLabel.text = "kg"
        calorieWeightUnitLabel.font = .systemFont(ofSize: 15, weight: .regular)
        calorieWeightUnitLabel.textColor = .black
        calorieWeightUnitLabel.sizeToFit()
        calorieWeightUnitLabel.center = CGPoint(x: self.preferredContentSize.width - 20 - calorieWeightUnitLabel.frame.size.width/2, y: calorieWeightLabel.center.y)
        self.view.addSubview(calorieWeightUnitLabel)
        calorieWeightTextField = UITextField(frame:CGRect(x: 0, y: 0, width: 0.7*(calorieWeightUnitLabel.frame.minX - calorieWeightLabel.frame.maxX), height: calorieWeightLabel.frame.size.height*1.5))
        calorieWeightTextField.text = "\(weight != nil ? weight! : 60)"
        calorieWeightTextField.font = .systemFont(ofSize: 15, weight: .semibold)
        calorieWeightTextField.keyboardType = .decimalPad
        calorieWeightTextField.delegate = self
        calorieWeightTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        calorieWeightTextField.textAlignment = .center
        calorieWeightTextField.layer.cornerRadius = 3
        calorieWeightTextField.layer.borderWidth = 0.5
        calorieWeightTextField.layer.borderColor = UIColor.gray.cgColor
        calorieWeightTextField.addTarget(self, action: #selector(changeTextFieldValue), for: .editingChanged)
        calorieWeightTextField.center = CGPoint(x: calorieWeightUnitLabel.frame.minX - 5 - calorieWeightTextField.frame.size.width/2, y: calorieWeightLabel.center.y)
        self.view.addSubview(calorieWeightTextField)
        calorieWeightExplain = UILabel()
        calorieWeightExplain.text = "体重によって消費カロリーは変わるので、より正確な体重を入力してください。"
        calorieWeightExplain.font = .systemFont(ofSize: 12, weight: .regular)
        calorieWeightExplain.textColor = .black
        calorieWeightExplain.sizeToFit()
        calorieWeightExplain.numberOfLines = 0
        calorieWeightExplain.lineBreakMode = .byWordWrapping
        let size = calorieWeightExplain.sizeThatFits(CGSize(width: self.preferredContentSize.width*0.8, height: CGFloat.greatestFiniteMagnitude))
        calorieWeightExplain.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        calorieWeightExplain.center = CGPoint(x: self.preferredContentSize.width/2, y: calorieWeightTextField.frame.maxY + 10 + calorieWeightExplain.frame.size.height/2)
        self.view.addSubview(calorieWeightExplain)
    }
    @objc func changeTextFieldValue(_ sender:UITextField){
        print("消費カロリーで使用するための体重が変化しました")
        if let string = sender.text{
            if let weight = Double(string){
                guard let delegate = delegate else{return}
                delegate.changeWeightSettingValue(weight)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0{
            return true
        }else{
            let resultText: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if let number = Float(resultText){
                if resultText.count <= 5 && number < 300{
                    return true
                }
            }
            return false
        }
    }
}
