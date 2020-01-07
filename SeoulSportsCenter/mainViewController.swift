//
//  mainViewController.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase
import CoreLocation

class mainViewController:UIViewController, FUIAuthDelegate, CLLocationManagerDelegate {
    
    var appDelegate:AppDelegate!
    var locationMgr:CLLocationManager! //사용자 위치 대리자
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //사용자의 위치 파악
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationMgr = appDelegate.locationMgr
        self.locationMgr.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways { //사용자 위치
            let alertController = appDelegate.getAlertView()
            present(alertController, animated: true, completion: nil)
    
        } else {
            let locationMgr = CLLocationManager()
            locationMgr.desiredAccuracy = kCLLocationAccuracyBest
            locationMgr.delegate = self
            locationMgr.startUpdatingLocation()
            if let coordinate = locationMgr.location?.coordinate{
                print(coordinate.latitude, coordinate.longitude)
                
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation]) { //사용자 위치
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        
        print(coordinate .latitude, coordinate.longitude)
    }
    
}

