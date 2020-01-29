//
//  ProgramListViewController.swift
//  SeoulSportsCenter
//
//  Created by 이윤진 on 2020/01/09.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import XMLParsing
import Alamofire

class ProgramListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var programTableView: UITableView!
    
    
    let secret_key = "6f5256507a616c69313134674978796b"
    
    // 기본 데이터 중에서 검색어를 포함한 일부분의 데이터
    var filtered_data:[Row] = []
    //var new_filtered_data:[Row] = []
    
    // 테이블 뷰에 보여질 기본 데이터
    var data:ListProgramByPublicSportsFacilitiesService?
    //var data2:ListProgramByPublicSportsFacilitiesService?
    
    // 전 페이지에서 받아온 클릭된 체육관 이름
    var selectedGym_data:String? // 기존에는 String?
    
    // 해당 뷰컨트롤러에 출력해야하는 프로그램 리스트
    var program_name_data:[String] = []
    // 다음 페이지에 넘겨야하는 해당 프로그램에 대한 모든 데이터
    var selectedProgram_data:[Row] = []
    
    //
    var selectedGym_data_row:[Row] = []
    // 메인페이지에서 클릭한 종목 명
    
    var eventName:String?
    // 전 페이지에서 받아온 해당 종목에 대한 모든 데이터 (쓸모없음)
    
    var selectedEvent_data:[Row] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        programTableView.dataSource = self
        self.filtered_data = self.data?.row ?? [Row]()
        setDefaultData()
        //debugPrint(selectedProgram_data)
    }
    
    func setDefaultData() {
        // alamofire 로 api 를 이용해 데이터 받아오기
        let url_string = "http://openAPI.seoul.go.kr:8088/\(self.secret_key)/xml/ListProgramByPublicSportsFacilitiesService/1/254/\(self.eventName!)/"
        let url:URL = URL(string: url_string.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        
        AF.request(url).responseData{(response) in
            let decoder = XMLDecoder()
            do {
                self.data = try decoder.decode(ListProgramByPublicSportsFacilitiesService.self, from: response.data!)
                
                self.filtered_data = self.data?.row ?? [Row]()
                
                self.selectedGym_data_row = self.data?.row ?? [Row]() // 종목명
                
                //NSLog("test","\(self.selectedGym_data)")
                
               //NSLog("\(self.selectedGym_data)")
                var j  = 0
                NSLog("\(self.selectedGym_data)")
                
                for i in 0 ... (self.filtered_data.count-1) { // 종목이 수영인 배열 모두를 도는 동안 반복
                    
                    
                    if(self.filtered_data[i].CENTER_NAME! == self.selectedGym_data!) { // selectedGym_data가 종목명...? 아님. 선택한 체육관 맞음 (만약 센터네임이 전 센터네임과 같다면
                        
                        self.selectedGym_data_row[j] = self.filtered_data[i]
                        //NSLog("\(self.selectedGym_data_row[j])")
                        j = j + 1
                        
                        
                    } // if문 끝
                }
                
                //NSLog("\(self.selectedGym_data_row[14].PROGRAM_NAME)")
                
                var program_list = self.selectedGym_data_row.map { (row) -> String in
                   
                    if(row.CENTER_NAME == self.selectedGym_data){
                        return row.PROGRAM_NAME! ?? row.CLASS_NAME!
                    }
                  
                    return ""
                }
                NSLog("\(program_list)")
                self.program_name_data = program_list
                self.programTableView.reloadData()
                
            }
             catch {
                NSLog(error.localizedDescription)
            }
            self.programTableView.reloadData()
        }
        // 데이터 셋팅
        // 테이블 뷰 리로드
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return program_name_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = programTableView.dequeueReusableCell(withIdentifier: "programDataCell", for: indexPath)
        let name = self.program_name_data[indexPath.row]
        cell.textLabel?.text = "\(name)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SearchDetailViewController else {
            return
        }
        let index = self.programTableView.indexPathForSelectedRow!.row
        destination.selected_program = [self.selectedGym_data_row[index]]
    }
    
}
