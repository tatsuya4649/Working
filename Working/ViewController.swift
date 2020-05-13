//
//  ViewController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/07.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import CoreMotion

var defaultColor = UIColor(red: 255/255, green: 235/255, blue: 54/255, alpha: 1)

class ViewController: UIViewController {
    var settingView : UIView!
    var settingViewGrad : CAGradientLayer!
    var startButton : UIButton!
    var pedometerCollection : UICollectionView!
    var pedometerCollectionLayout : UICollectionViewFlowLayout!
    var walkingCountViewController : PedometerElementViewController!
    var pedometer : CMPedometer!
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetting()
        pedometerElementSetting()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setButton()
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
