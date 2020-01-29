//
//  GymListViewController.swift
//  SeoulSportsCenter
//
//  Created by 이윤진 on 2020/01/09.
//  Copyright © 2020 swuad_12. All rights reserved.
//
import UIKit
import XMLParsing
import Alamofire

class GymListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var gymTableView: UITableView!
    
    let secret_key = "6f5256507a616c69313134674978796b"
    
    // 기본 데이터 중에서 검색어를 포함한 일부분의 데이터
    var filtered_data:[Row] = []
    // 중복을 제외한 체육관 string 리스트
    var gym_name_data:[String] = []
    // 테이블 뷰에 보여질 기본 데이터
    var data:ListProgramByPublicSportsFacilitiesService?
    // 메인페이지에서 클릭한 종목 명
    var eventName:String?
    // 다음 페이지로 넘어갈 데이터 (쓸모없음)-> 나중에 프로그램리스트뷰에서 데이터 다시 받지 않아도 되는 방법을 발견하면 그 때 다시 쓰기
    var selectedEvent_data:[Row] = []
    // 다음 페이지로 넘어갈 클릭된 체육관 이름
    var selectedGym_data:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gymTableView.dataSource = self
        self.filtered_data = self.data?.row ?? [Row]()
        setDefaultData()
    }
    
    func setDefaultData() {
        // alamofire 로 api 를 이용해 데이터 받아오기
        let url_string = "http://openAPI.seoul.go.kr:8088/\(self.secret_key)/xml/ListProgramByPublicSportsFacilitiesService/1/254/\(eventName!)/"
        let url:URL = URL(string: url_string.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        
        AF.request(url).responseData{(response) in
            let decoder = XMLDecoder()
            do {
                self.data = try decoder.decode(ListProgramByPublicSportsFacilitiesService.self, from: response.data!)
                self.filtered_data = self.data?.row ?? [Row]()
                
                // filtered_data 중 CENTER_NAME 만 map 을 이용하여 list에
                var center_list = self.filtered_data.map { (row) -> String in
                    return row.CENTER_NAME ?? ""
                }
                // map을 이용해 list에 넣은 것을 set에 넣으면 중복되는 체육관은 걸러짐
                var center_list_set = Set(center_list)
                // set을 이용해 걸러진 체육관들을 다시 list에
                center_list = Array<String>(center_list_set)
                
                self.gym_name_data = center_list
               // NSLog("\(self.gym_name_data)")
                self.gymTableView.reloadData()
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        // 데이터 셋팅
        
        // 테이블 뷰 리로드
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("returngymlistcount")
        return self.gym_name_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = gymTableView.dequeueReusableCell(withIdentifier: "gymDataCell", for: indexPath)
        let name = self.gym_name_data[indexPath.row]
       // self.selectedGym_data = name
        
        cell.textLabel?.text = "\(name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProgramListViewController") as? ProgramListViewController
        self.selectedGym_data = self.gym_name_data[indexPath.row]
        
        vc?.selectedGym_data = self.selectedGym_data
        vc?.eventName = self.eventName
        NSLog("\(self.eventName!)")
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ProgramListViewController else {
            return
        }
        let index = self.gymTableView.indexPathForSelectedRow!.row
        destination.selectedGym_data = self.gym_name_data[index]
        
    }
    
    
}
