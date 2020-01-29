//
//  MapDetailViewController.swift
//  SeoulSportsCenter
//
//  Created by 이윤진 on 2020/01/18.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import GoogleMaps
import XMLParsing
import Alamofire
import SafariServices

class MapDetailViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var googleMapView: UIView!
    var mapView:GMSMapView!
    
    var centerName = String()
    var centerAdd = String()
    var subjectName = String()
    var parking = String()
    var enterWay = String()
    var enterTerm = String()
    
    var centerURL = String()
    var centerNum = String()
    
    var centerLat:Double!
    var centerLon:Double!
    
    @IBOutlet weak var centerNameLabel: UILabel!
    @IBOutlet weak var centerAddLabel: UILabel!
    
    @IBOutlet weak var enterWayLabel: UILabel!
    @IBOutlet weak var enterTermLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 설정
        let cameraCenter = GMSCameraPosition.camera(withLatitude: centerLat, longitude: centerLon, zoom: 15.0)
        let rect = CGRect(x:0,y:0,width:googleMapView.frame.width,height: googleMapView.frame.height)
        mapView = GMSMapView.map(withFrame: rect, camera: cameraCenter)
        mapView.delegate = self
        googleMapView.addSubview(mapView)
        
        // 지도의 마커 설정
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.centerLat, longitude: self.centerLon)
        marker.title = self.centerName
        marker.snippet = self.subjectName
        marker.map = self.mapView
        
        // 텍스트 정보 표시
        self.centerNameLabel.text = self.centerName
        self.centerAddLabel.text = self.centerAdd
        self.enterWayLabel.text = self.enterWay
        self.enterTermLabel.text = self.enterTerm
        self.parkingLabel.text = self.parking
    }
    
    @IBAction func showAndCall(_ sender: Any) {
        makePhoneCall(phoneNumber: centerNum ?? "")
    }
    
    func makePhoneCall(phoneNumber: String) {

        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: (phoneNumber), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openSarfari(_ sender: Any) {
        guard let url = URL(string: centerURL) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    
}
