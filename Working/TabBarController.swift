//
//  TabBarController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import FontAwesome_swift
import CoreLocation

class TabBarController: UITabBarController,ViewControllerDelegate {
    func archievePerSteps(_ perStepCount: Int, _ stepCount: Int) {
        guard let locationViewController = locationViewController else{return}
        locationViewController.archievePerSteps(perStepCount, stepCount)
    }
    
    func archievePerDistance(_ perDistance: Float, _ totalDistance: Float) {
        guard let locationViewController = locationViewController else{return}
        locationViewController.archievePerDistance(perDistance, totalDistance)
    }
    
    func archievePerTime(_ perTime: Int, totalTime: Int) {
        guard let locationViewController = locationViewController else{return}
        locationViewController.archievePerTime(perTime, totalTime: totalTime)
    }
    
    func archievePerCalorie(_ perCalorie: Double, totalCalorie: Double) {
        guard let locationViewController = locationViewController else{return}
        locationViewController.archievePerCalorie(perCalorie, totalCalorie: totalCalorie)
    }
    
    ///万歩計がスタートしたときに呼び出されるデリゲートメソッド
    func startPedometer() {
        guard let locationViewController = locationViewController else{return}
        locationViewController.startPedometer()
    }
    
    ///万歩計がリセットされたときに呼び出されるデリゲートメソッド
    func resetPedometer() {
        guard let locationViewController = locationViewController else{return}
        locationViewController.resetPedometer()
    }
    
    ///万歩計が更新されたときに呼び出されるデリゲートメソッド
    func updataLocation(_ location:CLLocationCoordinate2D){
        guard let locationViewController = locationViewController else{return}
        locationViewController.updataLocation(location)
    }
    
    
    var settingViewController : ViewController!
    var locationViewController : LocationViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingViewController = ViewController()
        settingViewController.tabBarItem = UITabBarItem(title: "Walking", image: UIImage.fontAwesomeIcon(name: .walking, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 0)
        settingViewController.delegate = self
        locationViewController = LocationViewController()
        locationViewController.tabBarItem = UITabBarItem(title: "Location", image: UIImage.fontAwesomeIcon(name: .mapMarkedAlt, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 1)
        self.setViewControllers([settingViewController,locationViewController], animated: false)
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .clear
        
        settingNotification()
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1{
            locationViewController.setUserCenter()
        }
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
