//
//  NotificationSettingViewController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

///ポップアップで表示して通知のタイミングを設定するためのビューコントローラー
class NotificationSettingViewController: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    ///歩数に関する設定を行うためのセッティング
    public func stepsSetting(){
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
        picker.selectRow(2, inComponent: 0, animated: false)
        unitLabelSetting("歩")
        settingLabelSetting("通知歩数設定")
        explainLabel("\(stepValue!)歩経過するたびに1度通知します")
    }
    ///距離に関する設定を行うためのセッティング
    public func distanceSetting(){
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
        picker.selectRow(1, inComponent: 0, animated: false)
        unitLabelSetting("m")
        settingLabelSetting("通知距離設定")
        explainLabel("\(distanceValue!)m経過するたびに1度通知します")
    }
    ///時間に関する設定を行うためのセッティング
    public func timeSetting(){
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
        timeValue = 60
        pickerSetting()
        picker.selectRow(3, inComponent: 0, animated: false)
        unitLabelSetting("分")
        settingLabelSetting("通知時間設定")
        explainLabel("\(timeValue!)分経過するたびに1度通知します")
    }
    ///消費カロリーに関する設定を行うためのセッティング
    public func calorieSetting(){
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
        picker.selectRow(2, inComponent: 0, animated: false)
        unitLabelSetting("kcal")
        settingLabelSetting("通知消費カロリー設定")
        explainLabel("消費カロリーが\(calorieValue!)kcal経過するたびに1度通知します")
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
