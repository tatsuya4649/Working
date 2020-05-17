//
//  NotificationSettingPicker.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension NotificationSettingViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElementString != nil ? pickerElementString.count : 0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = pickerElementString[row]
        pickerLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        pickerLabel.sizeToFit()
        pickerLabel.frame = CGRect(x: 0, y: 0, width: pickerView.frame.size.width*0.5, height: pickerView.frame.size.height)
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElementString[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pedometerElement {
        case .steps:
            if let steps = Int(pickerElementString[row]){
                stepValue = steps
                updateExplainLabel("\(stepValue!)歩経過するたびに1度通知します")
                guard let delegate = delegate else {return}
                delegate.changeStepsSettingValue(steps)
            }
        case .distance:
            if let distance = Int(pickerElementString[row]){
                distanceValue = distance
                updateExplainLabel("\(distanceValue!)m経過するたびに1度通知します")
                guard let delegate = delegate else {return}
                delegate.changeDistanceSettingValue(Double(distance))
            }
        case .time:
            if let time = Int(pickerElementString[row]){
                timeValue = time
                updateExplainLabel("\(timeValue!)分経過するたびに1度通知します")
                guard let delegate = delegate else {return}
                delegate.changeTimeSettingValue(Double(time)*60)
            }
        case .calorie:
            if let calorie = Int(pickerElementString[row]){
                calorieValue = calorie
                updateExplainLabel("消費カロリーが\(calorieValue!)kcal経過するたびに1度通知します")
                guard let delegate = delegate else {return}
                delegate.changeCalorieSettingValue(Double(calorie))
            }
        default:
            break
        }
    }
    ///通知をする基準を選ぶピッカーを設定する関数
    public func pickerSetting(){
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0.7*self.preferredContentSize.width, height: 0.4*self.preferredContentSize.height))
        picker.center = CGPoint(x: self.preferredContentSize.width/2, y: self.preferredContentSize.height/2)
        picker.delegate = self
        picker.dataSource = self
        self.view.addSubview(picker)
        //初めに設定しておく行数を設定する
        picker.selectRow(2, inComponent: 0, animated: false)
    }
}
