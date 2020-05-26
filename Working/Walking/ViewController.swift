//
//  ViewController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/07.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

var defaultColor = UIColor(red: 255/255, green: 235/255, blue: 54/255, alpha: 1)
var DEFAULT_PERCALORIE = 150.0
var DEFAULT_PERTIME = 60*60
var DEFAULT_PERDISTANCE : Float = 1000.0
var DEFAULT_PERSTEPS = 1000
var DEFAULT_WEIGHT : Double = 60
var stepsAudioFile = "steps.caf"
var distanceAudioFile = "distance.caf"
var timeAudioFile = "time.caf"
var calorieAudioFile = "calorie.caf"

class ViewController: UIViewController {
    var settingView : UIView!
    var settingViewGrad : CAGradientLayer!
    var startButton : UIButton!
    var pedometerCollection : UICollectionView!
    var pedometerCollectionLayout : UICollectionViewFlowLayout!
    var walkingCountViewController : PedometerElementViewController!
    var pedometer : CMPedometer!
    weak var delegate : ViewControllerDelegate!
    var locationManager : CLLocationManager!
    var latitude : Double!
    var longitude : Double!
    var imageFromView : ImageFromView!
    var locationManagerDic : Dictionary<Double,CLLocationCoordinate2D>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "万歩計"
        navigationSetting()
        uiSetting()
        pedometerElementSetting()
        NotificationCenter.default.addObserver(self, selector: #selector(activeApp), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(unActionApp(_:)), name: UIApplication.willTerminateNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setButton()
    }

    @objc func activeApp(_ sender:Notification){
        ///スタートタイムが保存してあったら・・・現在進行中！！！
        if let _ = UserDefaults.standard.object(forKey: PedoSaveElement.startTime.rawValue) as? Date{
            startButton.setTitle(String.fontAwesomeIcon(name: .stop), for: .normal)
            startButton.isSelected = true
            //すぐに万歩計をオンにsuru
            pedometerSetting()
            //位置情報を作動させる
            settingLocationManager()
            //閉じた時間と開いた時間,perTimeを使用して閉じている間に超えた基準時間について調べて地図上にピンをする
            fromCloseTimeToOpenTimeTime()
            //閉じた時間と開いた時間,perCalorieを使用して閉じている間に超えた消費カロリーについて調べて地図上にピンをする
            fromCloseTimeToOpenTimeCalorie()
        }
    }
    
    @objc func unActionApp(_ sender:Notification){
        guard let startButton = startButton else{return}
        guard startButton.isSelected == false else{return}
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.startTime.rawValue)
        removeNotification()
    }
    public func removeNotification(){
        print("全ての通知を削除します")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    //万歩計に使用するUserDefaultsに保存してある値を全て削除する
    public func removePedometerUserDefaults(){
        print("万歩計に使用するUserDefaultsに保存してある値を全て削除します。")
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.distance.rawValue)
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.perDistance.rawValue)
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.perSteps.rawValue)
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.stepsCount.rawValue)
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.perCalorie.rawValue)
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.perTime.rawValue)
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
