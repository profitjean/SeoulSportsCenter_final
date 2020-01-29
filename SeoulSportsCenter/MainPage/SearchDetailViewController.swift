//
//  ProgramDetail.swift
//  APItest
//
//  Created by 김소연 on 2020/01/15.
//  Copyright © 2020 김소연. All rights reserved.
//
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

import Eureka
import UIKit
import XMLParsing
import Alamofire
import SafariServices

class SearchDetailViewController:UIViewController {
  
    // 회원정보 데베에 연결하기
    var dbRef:DatabaseReference!
    let storage = Storage.storage()
    @IBOutlet weak var feeDetailLabel: UILabel!
    @IBOutlet weak var programDetailLabel: UILabel!
    @IBOutlet weak var centerDetailLabel: UILabel!
    @IBOutlet weak var subjectDetailLabel: UILabel! // 종목
    @IBOutlet weak var targetDetailLabel: UILabel!
    @IBOutlet weak var weekDetailLabel: UILabel!
    @IBOutlet weak var timeDetailLabel: UILabel!
    @IBOutlet weak var addressDetailLabel: UILabel!
    var programName = String()
    
    
    // 전 화면에서 전달 받은 데이터
    // var program_data:ListProgramByPublicSportsFacilitiesService?
    var selected_program :[Row] = []
    //mypageviewcontroller의 var data : [MyProgram] = []에 정보 옮기기?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        programDetailLabel.text = selected_program[0].PROGRAM_NAME ?? ""
        centerDetailLabel.text = selected_program[0].CENTER_NAME ?? ""
        subjectDetailLabel.text = selected_program[0].SUBJECT_NAME ?? ""
        targetDetailLabel.text = selected_program[0].TARGET ?? ""
        weekDetailLabel.text = selected_program[0].WEEK ?? ""
        timeDetailLabel.text = selected_program[0].CLASS_TIME ?? ""
        addressDetailLabel.text = selected_program[0].ADDRESS ?? ""
        feeDetailLabel.text = selected_program[0].FEE ?? ""
        
        //print(selected_program)
    }
    
    
    /*전화 걸기 기능*/
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
    
    @IBAction func showAndCall(_ sender: Any) {
      
        makePhoneCall(phoneNumber: selected_program[0].TEL ?? "")
        
    }
    
    /*사이트 연결 기능 */
    @IBAction func openSafari(_ sender: Any) {
        guard let url = URL(string: selected_program[0].HOMEPAGE ?? "") else { return }
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
    }
    
    /*찜 버튼_ 찜한 체육관 데이터베에스에 적재*/
    @IBAction func myFavorite(_ sender: Any) {
        
    //dbRef = Database.database().reference()
      //  data = [self.selected_program[Row]]
        guard let userID = Auth.auth().currentUser?.uid else {return}
        guard let key = dbRef.child("program/\(userID)/").childByAutoId().key else{return}
        let path = "/program/\(userID)/\(key)"
        
        var post:[String:Any] = [
            
            "program":selected_program[0].PROGRAM_NAME ?? "", // 프로그램 이름
            "center":selected_program[0].CENTER_NAME ?? "", // 센터 이름
            "subject":selected_program[0].SUBJECT_NAME ?? "", // 종목
            "target":selected_program[0].TARGET ?? "", // 수강 대상
            "week":selected_program[0].WEEK ?? "", // 요일
            "time":selected_program[0].CLASS_TIME ?? "", // 진행 요일
            "address":selected_program[0].ADDRESS ?? "", // 주소
            "tel":selected_program[0].TEL ?? "", // 센터 전화번호
            "homepage":selected_program[0].HOMEPAGE ?? "" // 홈페이지.url주소
        
        ]
        
        self.postUpload(path, post)
        
    }
    
    func postUpload(_ path:String, _ post:[String:Any]){
        dbRef.child(path).setValue(post){
            (error,ref) in
            if let error = error{
                NSLog(error.localizedDescription)
                return
            }
        }
    }
}
