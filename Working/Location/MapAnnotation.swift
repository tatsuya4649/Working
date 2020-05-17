//
//  MapAnnotation.swift
//  Working
//
//  Created by 下川達也 on 2020/05/14.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: MKPointAnnotation {
    var pedoElement : PedometerElement!
    var perValue : Double!
    var totalValue : Double!
}

class MapAnnotationView : MKAnnotationView{
    var pedoElement : PedometerElement!
    ///基準値となる値
    var perValue : Double!
    ///今までの合計の値
    var totalValue : Double!
    var circle : UIView!
    var view : UIView!
    var viewTriangleLayer : CAShapeLayer!
    var label : UILabel!
    ///セットアップを行う関数
    public func setUp(){
        view = UIView()
        view.backgroundColor = .black
        label = UILabel()
        label.text = elementExplain()
        label.textColor = .white
        label.font = .monospacedSystemFont(ofSize: 12, weight: .semibold)
        label.sizeToFit()
        let size = label.sizeThatFits(CGSize(width: 100, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        view.frame = CGRect(x: 0, y: 0, width: size.width + 30, height: size.height + 15)
        label.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        view.addSubview(label)
        view.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - view.frame.size.height/2 - 17)
        view.layer.cornerRadius = 5
        viewAddingTriangleLayer()
        self.addSubview(view)
        circle = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        circle.layer.cornerRadius = circle.frame.size.height/2
        circle.backgroundColor = pedoElementColor()
        circle.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(circle)
    }
    private func viewAddingTriangleLayer(){
        var line = UIBezierPath()
        line.move(to: CGPoint(x: 0, y: 0))
        line.addLine(to: CGPoint(x: 15, y: 0))
        line.addLine(to: CGPoint(x: 7.5, y: 10))
        line.close()
        viewTriangleLayer = CAShapeLayer()
        viewTriangleLayer.path = line.cgPath
        viewTriangleLayer.position = CGPoint(x: view.frame.size.width/2 - 7.5, y: view.frame.size.height + viewTriangleLayer.frame.size.height/2)
        view.layer.addSublayer(viewTriangleLayer)
    }
    private func elementExplain()->String{
        var string = String()
        switch pedoElement {
        case .steps:
            string = "歩数\(Int(perValue != nil ? perValue! : 0))歩に到達。スタートから合計\(Int(totalValue != nil ? totalValue! : 0))歩"
        case .distance:
            string = "距離\(Int(perValue != nil ? perValue! : 0))mに到達。スタートから合計\(Int(totalValue != nil ? totalValue! : 0))m"
        case .time:
            string = "\(Int(perValue != nil ? perValue!/60 : 0))分に到達。スタートから合計\(Int(totalValue != nil ? totalValue!/60 : 0))分"
        case .calorie:
            string = "消費カロリー\(Int(perValue != nil ? perValue! : 0))kcalに到達。スタートから合計\(Int(totalValue != nil ? totalValue! : 0))kcal"
        default:break
        }
        return string
    }
    private func pedoElementColor()->UIColor{
        switch pedoElement {
        case .steps:
            return UIColor(red: 250/255, green: 88/255, blue: 130/255, alpha: 1)
        case .distance:
            return UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1)
        case .time:
            return UIColor(red: 58/255, green: 223/255, blue: 0/255, alpha: 1)
        case .calorie:
            return UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1)
        default:
            return .white
        }
    }
    ///アノテーションが選択されたときの処理
    public func didSelect(){
        print("アノテーションが選択されました")
        impact()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {[weak self] in
            guard let _ = self else{return}
            self!.view.alpha = 0
            self!.circle.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            self!.circle.center = CGPoint(x: self!.frame.size.width/2, y: self!.frame.size.height/2)
            self!.circle.layer.cornerRadius = self!.circle.frame.size.height/2
        }, completion: nil)
    }
    ///アノテーションの選択状態が解除されたときの処理
    public func didUnSelect(){
        print("アノテーションの選択状態が解除されました")
        impact()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {[weak self] in
            guard let _ = self else{return}
            self!.view.alpha = 1
            self!.circle.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            self!.circle.center = CGPoint(x: self!.frame.size.width/2, y: self!.frame.size.height/2)
            self!.circle.layer.cornerRadius = self!.circle.frame.size.height/2
        }, completion: nil)
    }
    private func impact(){
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
