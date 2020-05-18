//
//  ImageFromView.swift
//  Working
//
//  Created by 下川達也 on 2020/05/18.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

final class ImageFromView{
    var view : UIView!
    ///初期化のときに渡すviewは画像化するview
    init(_ view:UIView) {
        self.view = view
    }
    ///初期化時に渡されたviewを画像に変換して返す
    public func toImage() -> UIImage?{
        // キャプチャする範囲を取得する
        let rect = view.bounds
        // ビットマップ画像のcontextを作成する
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        // view内の描画をcontextに複写する
        view.layer.render(in: context)
        // contextのビットマップをUIImageとして取得する
        if let image : UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            // contextを閉じる
            return image
        }else{
            UIGraphicsEndImageContext()
            return nil
        }
    }

}
