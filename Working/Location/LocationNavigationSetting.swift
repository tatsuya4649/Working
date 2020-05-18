//
//  NavigationSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/18.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension LocationViewController{
    ///地図画面のナビゲーションバーのセッティングを行う関数
    public func navigationSetting(){
        guard let navi = self.navigationController else{return}
        navi.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:defaultColor]
        navi.navigationBar.barTintColor = .black
        navi.navigationBar.tintColor = defaultColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonClick))
    }
    @objc func shareButtonClick(_ sender:UIBarButtonItem){
        print("シェアボタンがクリックされました")
        var activityItems : Array<Any> = ["#マイペース","#万歩計"]
        imageFromView = ImageFromView(map)
        //地図を画像に変換する
        if let mapImage = imageFromView.toImage(){
            activityItems.append(mapImage)
        }
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: {[weak self] in
            guard let _ = self else{return}
            self!.imageFromView = nil
        })
    }
}
