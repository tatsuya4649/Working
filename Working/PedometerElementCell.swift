//
//  PedometerElementCell.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

protocol PedometerElementCellDelegate : AnyObject {
    func updateTimer(_ time:Int)
}
public enum PedometerElementNumber : Int{
    case steps = 0
    case distance = 1
    case time = 2
    case calorie = 3
}
class PedometerElementCell: UICollectionViewCell,PedometerElementViewControllerDelegate {
    weak var delegate : PedometerElementCellDelegate!
    var pedometerElementViewController : PedometerElementViewController!
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUpCell(_ indexPath:IndexPath){
        self.contentView.layer.cornerRadius = 20
        self.contentView.clipsToBounds = true
        pedometerElementViewController = PedometerElementViewController()
        pedometerElementViewController.view.frame = self.contentView.bounds
        self.contentView.addSubview(pedometerElementViewController.view)
        switch indexPath.item {
            //歩数に関するセッティングを行うメソッド
        case PedometerElementNumber.steps.rawValue:
            pedometerElementViewController.stepsCountSetting("歩数")
            //歩いた距離に関するセッティングを行うメソッド
        case PedometerElementNumber.distance.rawValue:
            pedometerElementViewController.distanceCountSetting("距離")
            //歩いた時間に関するセッティングを行うメソッド
        case PedometerElementNumber.time.rawValue:
            pedometerElementViewController.delegate = self
            pedometerElementViewController.timeCountSetting("時間")
            //歩いて消費したカロリーに関するセッティングを行うメソッド
        case PedometerElementNumber.calorie.rawValue:
            pedometerElementViewController.calorieSetting("カロリー")
        default:break
        }
    }
    ///ここで初めてタイマーをスタートさせる
    public func startTimer(){
        guard let pedometerelementViewController = pedometerElementViewController else{return}
        pedometerelementViewController.startTimer()
    }
    ///万歩計を更新するときに使用するための関数
    public func updataSteps(_ steps:NSNumber){
        guard let pedometerelementViewController = pedometerElementViewController else{return}
        pedometerelementViewController.updataSteps(steps)
    }
    public func updateDistance(_ distance:NSNumber?){
        guard let pedometerelementViewController = pedometerElementViewController else{return}
        pedometerelementViewController.updateDistance(distance)
    }
    func updateTimer(_ time: Int) {
        guard let delegate = delegate else{return}
        delegate.updateTimer(time)
    }
    ///消費カロリーを更新するときに呼び出されるメソッド
    func updateCalorie(_ time: Int){
        guard let pedometerelementViewController = pedometerElementViewController else{return}
        pedometerelementViewController.updateCalorie(time)
    }
    ///値を全てリセットするための関数
    public func resetValue(_ indexPath:IndexPath){
        switch indexPath.item {
            //歩数に関するセッティングを行うメソッド
        case PedometerElementNumber.steps.rawValue:
            pedometerElementViewController.resetStep()
            //歩いた距離に関するセッティングを行うメソッド
        case PedometerElementNumber.distance.rawValue:
            pedometerElementViewController.resetDistance()
            //歩いた時間に関するセッティングを行うメソッド
        case PedometerElementNumber.time.rawValue:
            pedometerElementViewController.resetTime()
            //歩いて消費したカロリーに関するセッティングを行うメソッド
        case PedometerElementNumber.calorie.rawValue:
            pedometerElementViewController.resetCalorie()
        default:break
        }
    }
}
