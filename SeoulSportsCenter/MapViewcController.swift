//
//  MapViewcController.swift
//  SeoulSportsCenter
//
//  Created by 김소연 on 2020/01/15.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import AddressBook

class MapViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMapView: UIView!
    var mapView:GMSMapView!
    
    var centerAdd = String()
    var centerName = String()
    var subjectName = String()
    var parking = String()
    var enterWay = String()
    var enterTerm = String()
    
    var centerURL = String()
    var centerNum = String()
    
    var search_lat: Double = 0.0
    var search_lon: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = LocationSingleTon.sharedInstance.getProperty()
        let cameraCenter = GMSCameraPosition.camera(withLatitude: location.0, longitude: location.1, zoom: 15.0)
        
        print("싱글톤 데이터",location)
        let rect = CGRect(x:0,y:0,width:googleMapView.frame.width,height: googleMapView.frame.height)
        mapView = GMSMapView.map(withFrame: rect, camera: cameraCenter)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        googleMapView.addSubview(mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker clicked")
        
        // marker 선택 -> 상세 페이지로 이동
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MapDetailVC") as? MapDetailViewController
        detailVC?.centerName = self.centerName
        detailVC?.centerAdd = self.centerAdd
        detailVC?.subjectName = self.subjectName
        detailVC?.centerNum = self.centerNum
        detailVC?.parking = self.parking
        detailVC?.enterWay = self.enterWay
        detailVC?.enterTerm = self.enterTerm
        detailVC?.centerURL = self.centerURL
        
        detailVC?.centerLat = self.search_lat
        detailVC?.centerLon = self.search_lon
        
        self.navigationController?.pushViewController(detailVC!, animated: true)
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        // 검색 창에서 가져온 정보를 지도에 다시 표시
        self.convertAdd()
    }
    
    func convertAdd() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(centerAdd) { (placemarks, error) in
            if (error != nil){
                return
            }
            if let placemark = placemarks?[0] {
                
                self.search_lat = Double(placemark.location?.coordinate.latitude ?? 0.0)
                self.search_lon = Double(placemark.location?.coordinate.longitude ?? 0.0)
                
                print("\(self.search_lat),\(self.search_lon),\(self.centerName)")
                let cameraCenter = GMSCameraPosition.camera(withLatitude: self.search_lat, longitude: self.search_lon, zoom: 15.0)
                let rect = CGRect(x:0,y:0,width:self.googleMapView.frame.width,height: self.googleMapView.frame.height)
                self.mapView = GMSMapView.map(withFrame: rect, camera: cameraCenter)
                self.googleMapView.addSubview(self.mapView)
                
                // 마커 설정
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: self.search_lat, longitude: self.search_lon)
                marker.title = self.centerName
                marker.snippet = self.subjectName
                marker.map = self.mapView
                
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.googleMapView.addSubview(self.mapView)
            }
        }
    }
   
}
