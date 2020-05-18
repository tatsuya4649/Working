//
//  PedometerElementSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/12.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,PedometerElementCellDelegate{
    func archievePerSteps(_ perStepCount: Int, _ stepCount: Int) {
        guard let delegate = delegate else{return}
        delegate.archievePerSteps(perStepCount, stepCount)
    }
    
    func archievePerDistance(_ perDistance: Float, _ totalDistance: Float) {
        guard let delegate = delegate else{return}
        delegate.archievePerDistance(perDistance, totalDistance)
    }
    
    func archievePerTime(_ perTime: Int, totalTime: Int) {
        guard let delegate = delegate else{return}
        delegate.archievePerTime(perTime, totalTime: totalTime)
    }
    
    func archievePerCalorie(_ perCalorie: Double, totalCalorie: Double) {
        guard let delegate = delegate else{return}
        delegate.archievePerCalorie(perCalorie, totalCalorie: totalCalorie)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pedometerElement", for: indexPath) as! PedometerElementCell
        for i in cell.contentView.subviews{
            i.removeFromSuperview()
        }
        cell.setUpCell(indexPath)
        cell.delegate = self
        return cell
    }
    
    ///万歩計に必要な要素をビューコントローラにしてsettingViewに配置する関数
    public func pedometerElementSetting(){
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        pedometerCollectionLayout = UICollectionViewFlowLayout()
        pedometerCollectionLayout.minimumInteritemSpacing = 20
        pedometerCollectionLayout.minimumLineSpacing = 20
        let cellWidth = (self.view.frame.size.width - 20*2 - 20)/2
        let cellHeight = (settingView.frame.size.height - 20*3)/2
        pedometerCollectionLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        pedometerCollectionLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        pedometerCollection = UICollectionView(frame:CGRect(x:0,y:0,width:self.view.frame.size.width,height:settingView.frame.size.height),collectionViewLayout: pedometerCollectionLayout)
        pedometerCollection.delegate = self
        pedometerCollection.dataSource = self
        pedometerCollection.register(PedometerElementCell.self, forCellWithReuseIdentifier: "pedometerElement")
        pedometerCollection.backgroundColor = .clear
        settingView.addSubview(pedometerCollection)
    }
    
    ///タイマーが更新されたことを知らせるデリゲートメソッド(1秒に1度だけ更新)
    func updateTimer(_ time:Int){
        DispatchQueue.main.async {[weak self] in
            guard let _ = self else{return}
            if let cell = self!.pedometerCollection.cellForItem(at: IndexPath(item: PedometerElementNumber.calorie.rawValue, section: 0)) as? PedometerElementCell{
                cell.updateCalorie(time)
            }
        }
    }
}
