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
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetting()
        pedometerElementSetting()
        NotificationCenter.default.addObserver(self, selector: #selector(activeApp), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unActionApp), name: UIApplication.didEnterBackgroundNotification, object: nil)
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
        }
    }
    
    @objc func unActionApp(_ sender:Notification){
        guard let startButton = startButton else{return}
        guard startButton.isSelected == false else{return}
        UserDefaults.standard.removeObject(forKey: PedoSaveElement.startTime.rawValue)
        removeNotification()
    }
    public func removeNotification(){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
            print(request)
        })
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("消費カロリー通知の削除に成功しました")
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
