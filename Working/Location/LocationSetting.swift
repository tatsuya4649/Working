//
//  LocationSetting.swift
//  Working
//
//  Created by 下川達也 on 2020/05/13.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension LocationViewController:CLLocationManagerDelegate{
    ///現在地を管理するlocationmanagertのセッティングを行う関数
    public func locationSetting(){
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else{return}
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.showsBackgroundLocationIndicator = false
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        print("位置情報が更新されました")
        if latitude == nil || longitude == nil{
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            if map != nil{
                map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
            }
        }else{
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
        guard stopBool == nil else{return}
        updatePolyLine(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    public func updataLocation(_ location:CLLocationCoordinate2D){
        if userCoordinates == nil{
            userCoordinates = Array<CLLocationCoordinate2D>()
        }
        userCoordinates.append(location)
        latitude = location.latitude
        longitude = location.longitude
    }
}
