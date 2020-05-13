//
//  TabBarController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TabBarController: UITabBarController {
    
    var settingViewController : ViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingViewController = ViewController()
        settingViewController.tabBarItem = UITabBarItem(title: "Walking", image: UIImage.fontAwesomeIcon(name: .walking, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 0)
        self.setViewControllers([settingViewController], animated: false)
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .clear
        // Do any additional setup after loading the view.
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
