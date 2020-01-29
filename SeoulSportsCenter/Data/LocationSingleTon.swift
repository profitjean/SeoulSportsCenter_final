//
//  LocationSingleTone.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 09/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSingleTon : NSObject, CLLocationManagerDelegate {
    
    var appDelegate:AppDelegate!
    var locationMgr:CLLocationManager!
    
    static let sharedInstance = LocationSingleTon()
   
    private lazy var latitude: Float = 0
    private lazy var longtitude: Float = 0
   
    private override init() {
        super.init()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationMgr = appDelegate.locationMgr
        self.locationMgr.delegate = self
    }
    
    func startUpdatingLocation() {
        self.locationMgr.startUpdatingLocation()
    }
   
    func getProperty() -> (Double, Double){
        guard let coordinate = self.locationMgr.location?.coordinate else {
            return (0,0)
        }
        return (coordinate.latitude, coordinate.longitude)
    }
}
