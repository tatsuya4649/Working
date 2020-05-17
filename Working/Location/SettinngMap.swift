//
//  SettinngMap.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension LocationViewController:MKMapViewDelegate{
    ///地図をセッティングするための関数
    public func mapSetting(){
        let height = self.tabBarController != nil ? self.tabBarController!.tabBar.frame.minY : self.view.frame.size.height
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height))
        map.mapType = .hybrid
        map.showsUserLocation = true
        map.delegate = self
        self.view.addSubview(map)
    }
    ///アノテーションをセッティングするための関数
    public func addAnnotation(){
        guard let annotationList = annotationList else{return}
        guard annotationList.count > 0 else{return}
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotationList)
    }
    
    public func polyLineSetting(){
        guard let userCoordinates = userCoordinates else{return}
        guard userCoordinates.count > 1 else{return}
        map.removeOverlays(map.overlays)
        polyLine = MKPolyline(coordinates: userCoordinates, count: userCoordinates.count)
        map.addOverlay(polyLine)
    }
    
    public func updatePolyLine(_ location:CLLocationCoordinate2D){
        if userCoordinates == nil{
            userCoordinates = Array<CLLocationCoordinate2D>()
        }
        if polyLine == nil{
            polyLine = MKPolyline()
        }
        userCoordinates.append(location)
        guard userCoordinates.count > 1 else{return}
        polyLine = MKPolyline(coordinates: userCoordinates, count: userCoordinates.count)
        if map != nil{
            map.removeOverlays(map.overlays)
            map.addOverlay(polyLine)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline{
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            polylineRenderer.strokeColor = defaultColor
            polylineRenderer.lineWidth = 10.0
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //ユーザー現在位置を示すアノテーションのときは無視をする
        if let _ = annotation as? MKUserLocation{
            return nil
        }
        guard let annotation = annotation as? MapAnnotation else {return MKAnnotationView()}
        customAnnotationView = MapAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        customAnnotationView.pedoElement = annotation.pedoElement
        customAnnotationView.perValue = annotation.perValue
        customAnnotationView.totalValue = annotation.totalValue
        customAnnotationView.setUp()
        return customAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let view = view as? MapAnnotationView{
            view.didSelect()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let view = view as? MapAnnotationView{
            view.didUnSelect()
        }
    }
}
