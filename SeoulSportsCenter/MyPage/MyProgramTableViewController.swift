//
//  MyProgramTableViewController.swift
//  SeoulSportsCenter
//
//  Created by 김지현 on 19/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import FirebaseStorage
import CodableFirebase
import Kingfisher



class MyProgramTableViewController: UIViewController, UITableViewDataSource, FUIAuthDelegate {
    
    @IBOutlet weak var programTable: UITableView!
    // 새로 만들어준 테이블뷰 아울렛 연결
       // 밑에 있는 tableview identifier 꼭 지정해주기~~~~~~
       // MyPageViewController는 uitableviewdatasource 삭제해주기
       // 새로 추가한 버튼 - 테이블뷰 추가한 새로운 컨트롤러 - 상세페이지 컨트롤러 show segue 연결
       // ** MyPageViewController코드에서  MyProgramTableViewController와 겹치는코드 삭제
       // tableview 관련 코드 삭제해주면 완료.
       
       
       var dbRef:DatabaseReference!
       var data:[MyProgram] = [] // program that i selected
       var data_keys:[String] = []
       let storage = Storage.storage()
       
       override func viewDidLoad() {
           
           super.viewDidLoad()
           dbRef = Database.database().reference()
           programTable.dataSource = self
           getData() // 데이터 받아오는 함수
          
       }
       
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.data.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "programCell", for : indexPath)
           var myData = self.data[indexPath.row]
           cell.textLabel?.text = "\(myData.center ?? "") - \(myData.program ?? "")"
           cell.detailTextLabel?.text = "\(myData.week ?? "") / \(myData.time ?? "")"
           
           return cell
       }
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete{
                if let userID = Auth.auth().currentUser?.uid {
                    let remove_key = self.data_keys[indexPath.row]
                    NSLog("1")
                    let removed_data = self.data[indexPath.row]
                    self.data.remove(at: indexPath.row) // 데이터 삭제
                    let postRef = dbRef.child("program").child("\(userID)/\(remove_key)")
                    postRef.removeValue { (error, dbRef) in
                        if let error = error {
                            NSLog(error.localizedDescription)
                            return
                        }
                        
                    }
                }
                
            }
        }
       
       func getData() {
           //program 정보 가져와서 tableView에 reload
           //dbRef = Database.database().reference()
           
           if let userID = Auth.auth().currentUser?.uid{
               let postRef = dbRef.child("program").child("\(userID)")
               
               let refHandle = postRef.queryOrdered(byChild: "center").observe(DataEventType.value){ (snapshot) in
                   self.data = []
                   self.data_keys = []
                   let snapshot_data = snapshot.children.allObjects as! [DataSnapshot]
                   for program in snapshot_data{
                       let myprogram = try! FirebaseDecoder().decode(MyProgram.self, from: program.value)
                       self.data_keys.append(program.key)
                       self.data.append(myprogram)
                   }
                  
                   self.programTable.reloadData()
               }
           }
           
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           guard let destination = segue.destination as? MyProgramViewController else {return}
           
           let index = self.programTable.indexPathForSelectedRow!.row
           destination.myProgram = self.data[index] // myprogram_viewcontroller로 이동
           
       }

}
