//
//  AppDelegate.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    
    var locationMgr:CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        locationMgr = CLLocationManager()
        locationMgr.requestAlwaysAuthorization()
        return true
    }
    
    func getAlertView() -> UIAlertController{
        let alertController = UIAlertController(title: "권한 없음", message: "위치 정보 권한이 필요합니다. \n설정 -> 개인정보보호 -> 위치 정보 \n설정에 가서 허용해 주세요", preferredStyle: .alert)
        let action_ok = UIAlertAction(title: "설정", style: .default){
            (action) in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsURL){
                UIApplication.shared.open(settingsURL, completionHandler: {(success) in})
            }
        }
        let action_cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(action_ok)
        alertController.addAction(action_cancel)
        
        return alertController
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

