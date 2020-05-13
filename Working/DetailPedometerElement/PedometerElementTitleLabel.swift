//
//  PedometerElementTitleLabel.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

public enum PedometerElement{
    case steps
    case distance
    case time
    case calorie
}

extension PedometerElementViewController{
    ///受け取ったタイトルを元に各項目のメニュー名をラベルで表示するためのメソッド
    public func pedometerElementTitleLabel(_ title:String){
        pedoElementLalbel = UILabel()
        pedoElementLalbel.text = title
        pedoElementLalbel.font = .systemFont(ofSize: 15, weight: .semibold)
        pedoElementLalbel.textColor = defaultColor
        pedoElementLalbel.sizeToFit()
        pedoElementLalbel.center = CGPoint(x: self.view.frame.size.width/2, y: 10 + pedoElementLalbel.frame.size.height/2)
        self.view.addSubview(pedoElementLalbel)
    }
}
