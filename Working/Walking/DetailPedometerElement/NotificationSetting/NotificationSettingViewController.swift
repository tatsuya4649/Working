//
//  NotificationSettingViewController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

protocol NotificationSettingViewControllerDelegate:AnyObject {
    ///歩数の基準値が変更されたときに呼び出されるメソッド
    func changeStepsSettingValue(_ steps:Int)
    ///距離の基準値が変更されたときに呼び出されるメソッド
    func changeDistanceSettingValue(_ distance:Double)
    ///時間の基準値が変更されたときに呼び出されるメソッド
    func changeTimeSettingValue(_ time:Double)
    ///消費カロリーの基準値が変更されたときに呼び出されるメソッド
    func changeCalorieSettingValue(_ calorie:Double)
    ///消費カロリーに使用するための数値である体重が変更されたときに呼び出されるメソッド
    func changeWeightSettingValue(_ weight:Double)
}

///ポップアップで表示して通知のタイミングを設定するためのビューコントローラー
class NotificationSettingViewController: UIViewController {
    weak var delegate : NotificationSettingViewControllerDelegate!
    var settingLabel : UILabel!
    var explainLabel : UILabel!
    var pedometerElement : PedometerElement!
    var picker : UIPickerView!
    var unitLabel : UILabel!
    var pickerElementString : Array<String>!
    var stepValue : Int!
    var distanceValue : Int!
    var timeValue : Int!
    var calorieValue : Int!
    var weight : Double!
    var calorieWeightLabel : UILabel!
    var calorieWeightUnitLabel : UILabel!
    var calorieWeightTextField : UITextField!
    var calorieWeightExplain : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    ///歩数に関する設定を行うためのセッティング
    public func stepsSetting(_ perSteps:Int){
        pedometerElement = PedometerElement.steps
        pickerElementString = [
            "100",
            "500",
            "1000",
            "2000",
            "3000",
            "4000",
            "5000",
            "6000",
            "7000",
            "8000",
            "9000",
            "10000",
        ]
        stepValue = Int(1000)
        pickerSetting()
        if let number = checkPickerSelectRow(pickerElementString,perSteps){
            picker.selectRow(number, inComponent: 0, animated: false)
        }else{
            picker.selectRow(2, inComponent: 0, animated: false)
        }
        unitLabelSetting("歩")
        settingLabelSetting("通知歩数設定")
        explainLabel("\(stepValue!)歩経過するたびに1度通知します")
    }
    ///距離に関する設定を行うためのセッティング
    public func distanceSetting(_ perDistance:Float){
        pedometerElement = PedometerElement.distance
        pickerElementString = [
            "500",
            "1000",
            "2000",
            "3000",
            "4000",
            "5000",
            "6000",
            "7000",
            "8000",
            "9000",
            "10000",
            "20000"
        ]
        distanceValue = 1000
        pickerSetting()
        if let number = checkPickerSelectRow(pickerElementString,Int(perDistance)){
            picker.selectRow(number, inComponent: 0, animated: false)
        }else{
            picker.selectRow(1, inComponent: 0, animated: false)
        }
        unitLabelSetting("m")
        settingLabelSetting("通知距離設定")
        explainLabel("\(distanceValue!)m経過するたびに1度通知します")
    }
    ///時間に関する設定を行うためのセッティング
    public func timeSetting(_ perTime:Int){
        pedometerElement = PedometerElement.time
        pickerElementString = [
            "15",
            "30",
            "45",
            "60",
            "75",
            "90",
            "105",
            "120",
            "135",
            "150",
            "165",
            "180"
        ]
        timeValue = 60*60
        pickerSetting()
        if let number = checkPickerSelectRow(pickerElementString, Int(perTime/60)){
            picker.selectRow(number, inComponent: 0, animated: false)
        }else{
            picker.selectRow(3, inComponent: 0, animated: false)
        }
        unitLabelSetting("分")
        settingLabelSetting("通知時間設定")
        explainLabel("\(timeValue!)分経過するたびに1度通知します")
    }
    ///消費カロリーに関する設定を行うためのセッティング
    public func calorieSetting(_ calorie:Double){
        pedometerElement = PedometerElement.calorie
        pickerElementString = [
            "50",
            "100",
            "150",
            "200",
            "250",
            "300",
            "350",
            "400",
            "450",
            "500",
            "550",
            "680"
        ]
        calorieValue = 150
        pickerSetting()
        if let number = checkPickerSelectRow(pickerElementString, Int(calorie)){
            picker.selectRow(number, inComponent: 0, animated: false)
        }else{
            picker.selectRow(2, inComponent: 0, animated: false)
        }
        
        unitLabelSetting("kcal")
        settingLabelSetting("通知消費カロリー設定")
        explainLabel("消費カロリーが\(calorieValue!)kcal経過するたびに1度通知します")
        settingCalorieWeight()
        
    }
    ///ピッカーと被っている番号を返す(ピッカーセッティング用関数)
    private func checkPickerSelectRow(_ array:Array<String>,_ perValue:Int)->Int?{
        guard array.count > 0 else{fatalError()}
        for number in 0..<array.count{
            if let stringInt = Int(array[number]){
                if stringInt == perValue{
                    return number
                }
            }
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
