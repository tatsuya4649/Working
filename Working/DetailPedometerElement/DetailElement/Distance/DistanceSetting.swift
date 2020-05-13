//
//  DistanceSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension PedometerElementViewController{
    ///歩いた距離に関するセッティングを行うメソッド
    public func distanceSetting(){
        distanceLabel = UILabel()
        distanceLabel.text = "\(distance != nil ? distance! : 0)"
        distanceLabel.font = .systemFont(ofSize: 40, weight: .bold)
        distanceLabel.textColor = .white
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x:self.view.frame.size.width/2,y:pedoElementLalbel.frame.maxY + 10 + distanceLabel.frame.size.height/2)
        self.view.addSubview(distanceLabel)
        distanceUnitLabel = UILabel()
        distanceUnitLabel.text = "m"
        distanceUnitLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        distanceUnitLabel.textColor = .white
        distanceUnitLabel.sizeToFit()
        distanceUnitLabel.center = CGPoint(x:distanceLabel.frame.maxX + 5 + distanceUnitLabel.frame.size.width/2,y:distanceLabel.frame.maxY - distanceUnitLabel.frame.size.height/2)
        self.view.addSubview(distanceUnitLabel)
    }
    public func resetDistance(){
        distance = nil
        updateDistanceLabel()
    }
    private func updateDistanceLabel(){
        distanceLabel.text = "\(distance != nil ? distance! : 0)"
        distanceLabel.font = .systemFont(ofSize: 40, weight: .bold)
        distanceLabel.textColor = .white
        distanceLabel.sizeToFit()
        distanceLabel.center = CGPoint(x:self.view.frame.size.width/2,y:pedoElementLalbel.frame.maxY + 10 + distanceLabel.frame.size.height/2)
        distanceUnitLabel.center = CGPoint(x:distanceLabel.frame.maxX + 5 + distanceUnitLabel.frame.size.width/2,y:distanceLabel.frame.maxY - distanceUnitLabel.frame.size.height/2)
    }
    ///万歩計が更新されたときに呼び出されるメソッド
    public func updateDistance(_ distance:NSNumber?){
        guard let distance = distance else{return}
        self.distance = Float(distance)
        //小数点第２位で四捨五入
        self.distance = round(self.distance*10)/10
        updateDistanceLabel()
    }
}
