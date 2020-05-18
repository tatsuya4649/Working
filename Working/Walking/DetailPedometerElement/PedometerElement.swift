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

    var startButtonOn : Bool!
    var pedoElement : PedometerElement!
    var pedoElementTitle : String!
    var pedoElementLalbel : UILabel!
    var notificationLabel : UILabel!
    var notificationSwitch : UISwitch!
    var notificationBool : Bool!
    var notificationButton : UIButton!
    var notificationViewController : NotificationSettingViewController!
    var reading : Reading!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        NotificationCenter.default.addObserver(self, selector: #selector(activeApp(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notActiveApp(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    //以下は全てトップページのコレクションビュー内のセルから呼び出される
    ///歩数に関するセッティングを行うメソッド
    var stepsLabel : UILabel!
    var stepsUnitLabel : UILabel!
    var stepsCount : Int!
    var checkPerStepsCount : Int!
    var locationUpdatePerStepsCount : Int!
    var perStepsCount : Int!
    var stepsView : UIView!
    public func stepsCountSetting(_ title:String){
        pedoElement = PedometerElement.steps
        pedometerElementTitleLabel(title)
        stepsSetting()
        notificationSetting()
        perStepsCount = 1000
        checkPerStepsCount = perStepsCount
        locationUpdatePerStepsCount = checkPerStepsCount
    }
    ///歩いた距離に関するセッティングを行うメソッド
    var distanceLabel : UILabel!
    var distanceUnitLabel : UILabel!
    var distance : Float!
    var checkPerDistance : Float!
    var locationUpdatePerDistance : Float!
    var perDistance : Float!
    var distanceView : UIView!
    public func distanceCountSetting(_ title:String){
        pedoElement = PedometerElement.distance
        pedometerElementTitleLabel(title)
        distanceSetting()
        notificationSetting()
        perDistance = 1000.0
        checkPerDistance = perDistance
        locationUpdatePerDistance = checkPerDistance
    }
    ///歩いた時間に関するセッティングを行うメソッド
    var timeView : UIView!
    var secLabel : UILabel!
    var secUnitLabel : UILabel!
    var minLabel : UILabel!
    var minUnitLabel : UILabel!
    var hourLabel : UILabel!
    var hourUnitLabel : UILabel!
    var dayLabel : UILabel!
    var dayUnitLabel : UILabel!
    var timer : Timer!
    var time : Int!
    var checkPerTime : Int!
    var locationUpdatePerTime : Int!
    var perTime : Int!
    weak var delegate : PedometerElementViewControllerDelegate!
    var workItem : DispatchWorkItem!
    public func timeCountSetting(_ title:String){
        pedoElement = PedometerElement.time
        pedometerElementTitleLabel(title)
        timeSetting()
        notificationSetting()
        perTime = 60*60
        checkPerTime = perTime
        locationUpdatePerTime = checkPerTime
    }
    ///歩いて消費したカロリーに関するセッティングを行うメソッド
    var calorieLabel : UILabel!
    var calorieUnitLabel : UILabel!
    var healthStore : HKHealthStore!
    var weight : Double!
    var calorie : Double!
    var checkPerCalorie : Double!
    var locationUpdatePerCalorie : Double!
    var perCalorie : Double!
    var calorieView : UIView!
    public func calorieSetting(_ title:String){
        pedoElement = PedometerElement.calorie
        pedometerElementTitleLabel(title)
        calorieSetting()
        notificationSetting()
        perCalorie = 150.0
        checkPerCalorie = perCalorie
        locationUpdatePerCalorie = checkPerCalorie
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func notActiveApp(_ sender:Notification){
        print("バックグラウンドに戻ります")
        guard let pedoElement = pedoElement else{return}
        switch pedoElement {
        case .steps:
            UserDefaults.standard.setValue(perStepsCount, forKey: PedoSaveElement.perSteps.rawValue)
            UserDefaults.standard.setValue(stepsCount, forKey: PedoSaveElement.stepsCount.rawValue)
        case .distance:
            UserDefaults.standard.setValue(perDistance, forKey: PedoSaveElement.perDistance.rawValue)
            UserDefaults.standard.setValue(distance, forKey: PedoSaveElement.distance.rawValue)
        case .time:
            UserDefaults.standard.setValue(perTime, forKey: PedoSaveElement.perTime.rawValue)
            resetTimer()
        case .calorie:
            UserDefaults.standard.setValue(perCalorie, forKey: PedoSaveElement.perCalorie.rawValue)
        default:break
        }
    }
    @objc func activeApp(_ sender:Notification){
        ///スタートタイムが保存してあったら・・・現在進行中！！！
        if pedoElement != nil{
            guard let startTime = UserDefaults.standard.object(forKey: PedoSaveElement.startTime.rawValue) as? Date else{return}
            switch pedoElement {
            case .steps:
                if let perStepsCount = UserDefaults.standard.object(forKey: PedoSaveElement.perSteps.rawValue) as? Int{
                    self.perStepsCount = perStepsCount
                }
                if let stepsCount = UserDefaults.standard.object(forKey: PedoSaveElement.stepsCount.rawValue) as? Int{
                    self.stepsCount = stepsCount
                }
            case .distance:
                if let perDistance = UserDefaults.standard.object(forKey: PedoSaveElement.perDistance.rawValue) as? Float{
                    self.perDistance = perDistance
                }
                if let distance = UserDefaults.standard.object(forKey: PedoSaveElement.perSteps.rawValue) as? Float{
                    self.distance = distance
                }
            case .time:
                let minusTime = Date().timeIntervalSince(startTime)
                self.time = Int(minusTime)
                if let perTime = UserDefaults.standard.object(forKey: PedoSaveElement.perTime.rawValue) as? Int{
                    self.perTime = perTime
                    self.checkPerTime = self.perTime - self.time % self.perTime
                    print(Int(minusTime/60))
                    print(minusTime.truncatingRemainder(dividingBy: 60))
                    print(self.perTime)
                    print(self.checkPerTime)
                    
                }
                
                self.startButtonOn = true
                resetTimer()
                startTimerOnly()
            case .calorie:
                let minusTime = Date().timeIntervalSince(startTime)
                let hourMinusTime = minusTime/(60*60)
                if let perCalorie = UserDefaults.standard.object(forKey: PedoSaveElement.perCalorie.rawValue) as? Double{
                    self.perCalorie = 5.0
                }
                //print(minusTime)
                //print(hourMinusTime)
                //print(self.checkPerCalorie)
                //print(self.perCalorie)
                self.checkPerCalorie = self.perCalorie - (3*(self.weight != nil ? self.weight! : 60)*hourMinusTime).truncatingRemainder(dividingBy: self.perCalorie)
                //print(self.checkPerCalorie)
                self.startButtonOn = true
            default:
                break
            }
        }
    }
    

}
