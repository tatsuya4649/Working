//
//  LocationViewController.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    var map : MKMapView!
    var locationManager : CLLocationManager!
    var latitude : Double!
    var longitude : Double!
    var polyLine : MKPolyline!
    var userCoordinates : Array<CLLocationCoordinate2D>!
    var annotationList : Array<MapAnnotation>!
    var customAnnotationView : MapAnnotationView!
    var stopBool : Bool!
    var imageFromView : ImageFromView!
    var locationManagerDic : Dictionary<Double,CLLocationCoordinate2D>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "記録マップ"
        navigationSetting()
        mapSetting()
        locationSetting()
        polyLineSetting()
        addAnnotation()
        setUserCenter()
        // Do any additional setup after loading the view.
    }
    ///万歩計がスタートしたときに呼び出される
    public func startPedometer(){
        print("万歩計の計測が始まったことをロケーションに通知しました")
        if map != nil{
            if map.overlays.count > 0{
                map.removeOverlays(map.overlays)
            }
            if map.annotations.count > 0{
                map.removeAnnotations(map.annotations)
            }
        }
        if annotationList != nil{
            annotationList.removeAll()
            annotationList = nil
        }
        if userCoordinates != nil{
            userCoordinates.removeAll()
            userCoordinates = nil
        }
        if polyLine != nil{
            polyLine = nil
        }
        if stopBool != nil{
            stopBool = nil
        }
        locationSetting()
    }
    ///万歩計がリセットされたときに呼び出される
    public func resetPedometer(){
        print("万歩計の計測が終了したことをロケーションに通知しました")
        stopBool = true
        locationRemove()
    }
    ///Locationボタンがクリックされた瞬間に呼び出されるメソッド
    ///やることとしては、現在地に地図の中心を持ってくる
    public func setUserCenter(){
        guard let latitude = latitude else{return}
        guard let longitude = longitude else{return}
        guard let map = map else{return}
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
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
