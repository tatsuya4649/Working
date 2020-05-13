//
//  PedometerElement.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import HealthKit

class PedometerElementViewController: UIViewController {

    var pedoElement : PedometerElement!
    var pedoElementTitle : String!
    var pedoElementLalbel : UILabel!
    var notificationLabel : UILabel!
    var notificationSwitch : UISwitch!
    var notificationBool : Bool!
    var notificationButton : UIButton!
    var notificationViewController : NotificationSettingViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    //以下は全てトップページのコレクションビュー内のセルから呼び出される
    ///歩数に関するセッティングを行うメソッド
    var stepsLabel : UILabel!
    var stepsUnitLabel : UILabel!
    var stepsCount : Int!
    public func stepsCountSetting(_ title:String){
        pedoElement = PedometerElement.steps
        pedometerElementTitleLabel(title)
        stepsSetting()
        notificationSetting()
    }
    ///歩いた距離に関するセッティングを行うメソッド
    var distanceLabel : UILabel!
    var distanceUnitLabel : UILabel!
    var distance : Float!
    public func distanceCountSetting(_ title:String){
        pedoElement = PedometerElement.distance
        pedometerElementTitleLabel(title)
        distanceSetting()
        notificationSetting()
    }
    ///歩いた時間に関するセッティングを行うメソッド
    var timeLabel : UILabel!
    var timeUnitLabel : UILabel!
    var timer : Timer!
    var time : Int!
    weak var delegate : PedometerElementViewControllerDelegate!
    public func timeCountSetting(_ title:String){
        pedoElement = PedometerElement.time
        pedometerElementTitleLabel(title)
        timeSetting()
        notificationSetting()
    }
    ///歩いて消費したカロリーに関するセッティングを行うメソッド
    var calorieLabel : UILabel!
    var calorieUnitLabel : UILabel!
    var healthStore : HKHealthStore!
    var weight : Double!
    var calorie : Double!
    public func calorieSetting(_ title:String){
        pedoElement = PedometerElement.calorie
        pedometerElementTitleLabel(title)
        calorieSetting()
        notificationSetting()
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
