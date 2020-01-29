//
//  MapSearchViewController.swift
//  SeoulSportsCenter
//
//  Created by 이윤진 on 2020/01/18.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import XMLParsing
import Alamofire

class MapSearchViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let secret_key = "6f5256507a616c69313134674978796b"
    
    var filter_data :[Row] = [] // 검색어 포함 데이터
    var data:ListProgramByPublicSportsFacilitiesService? // 기본 데이터
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        var data = self.filter_data[indexPath.row]
        cell.textLabel?.text = "\(data.CENTER_NAME ?? "") - \(data.PROGRAM_NAME ?? "")"
        cell.detailTextLabel?.text = "\(data.WEEK ?? "") / \(data.CLASS_TIME ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // navigationController의 MapViewController -> 변수에 전달
        
        let n: Int! = self.navigationController?.viewControllers.count
        let mapView = self.navigationController?.viewControllers[n-2] as! MapViewController
        
        let index = self.tableView.indexPathForSelectedRow!.row
        mapView.centerAdd = filter_data[index].ADDRESS ?? " "
        mapView.centerName = filter_data[index].CENTER_NAME ?? "해당 정보 없음"
        mapView.subjectName = filter_data[index].SUBJECT_NAME ?? "해당 정보 없음"
        mapView.parking = filter_data[index].PARKING_SIDE ?? "홈페이지를 확인해주세요."
        mapView.enterWay = filter_data[index].ENTER_WAY ?? "홈페이지를 확인해주세요."
        mapView.enterTerm = filter_data[index].ENTER_TERM ?? "홈페이지를 확인해주세요."
        
        mapView.centerURL = filter_data[index].HOMEPAGE ?? ""
        mapView.centerNum = filter_data[index].TEL ?? ""
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        self.filter_data = self.data?.row ?? [Row]() // 데이터 있으면 셋팅하고 없으면 빈 Row로 설정
        
        setDefaultData()
    }
    
    func setDefaultData() {
        // alamofire로 api를 이용해 데이터 받아오기
        let url = "http://openAPI.seoul.go.kr:8088/\(self.secret_key)/xml/ListProgramByPublicSportsFacilitiesService/1/500/"
        AF.request(url).responseData { (response) in
            let decoder = XMLDecoder()
            do {
                self.data = try decoder.decode(ListProgramByPublicSportsFacilitiesService.self
                    , from: response.data!)
                
                self.filter_data = self.data?.row ?? [Row]()
                
                self.tableView.reloadData()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        // 데이터 셋팅
        
        //
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 사용자가 검색어를 입력했을 때, 원본 데이터에서 필터링한 결과를 적용하기
        NSLog(searchText)
        
        if searchText == "" {
            self.filter_data = self.data?.row ?? [Row]()
        } else {
            // 원본 데이터에서 검색어에 포함한 데이터만 filtered_data에 할당하기
            if let original_data = self.data?.row {
                self.filter_data = (original_data.filter({ (row) -> Bool in
                    // 검색
                    if row.CENTER_NAME?.contains(searchText) ?? false {
                        return true
                    } else if row.SUBJECT_NAME?.contains(searchText) ?? false {
                        return true
                    } else if row.CLASS_NAME?.contains(searchText) ?? false {
                        return true
                    } else if row.PROGRAM_NAME?.contains(searchText) ?? false {
                        return true
                    } else {
                        return false
                    }
                    
                }))
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 서치 바에 있는 취소 버튼을 눌렀을 때
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
