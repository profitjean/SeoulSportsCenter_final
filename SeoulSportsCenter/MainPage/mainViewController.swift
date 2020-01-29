//
//  mainViewController.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase
import CoreLocation
import XMLParsing
import Alamofire

class mainViewController:UIViewController, FUIAuthDelegate, CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
   // @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    var appDelegate:AppDelegate!
    var locationMgr:CLLocationManager! //사용자 위치 대리자
    
    let events = ["수영", "헬스",
                  "댄스", "태권도", "축구", "농구", "테니스", "골프", "권투", "탁구", "당구", "배드민턴", "발레", "요가", "인라인 S", "스피드 S", "줄넘기", "체육수업"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //사용자의 위치 파악
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationMgr = appDelegate.locationMgr
        self.locationMgr.delegate = self
        
        //컬렉션뷰
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        
        let location = LocationSingleTon.sharedInstance.getProperty()
        print("싱글톤 정보",location)
        
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let backgroundImageView = UIImageView(frame: CGRect(x:0, y: 0, width: width, height: height))
        
        backgroundImageView.image = UIImage(named: "backGround")
        backgroundImageView.contentMode = .scaleAspectFill
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        
        print(coordinate .latitude, coordinate.longitude)
    }
    
    
    
    // 1.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 2.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    // 3. 셀 크기 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/4
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventList
        cell.eventImage.image = UIImage(named: events[indexPath.row])
        cell.eventTitle.text = events[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GymListViewController") as? GymListViewController
        vc?.eventName = events[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}

