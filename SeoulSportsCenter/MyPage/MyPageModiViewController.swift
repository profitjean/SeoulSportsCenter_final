//
//  MyPageModiViewController.swift
//  SeoulSportsCenter
//
//  Created by 김소연 on 2020/01/14.
//  Copyright © 2020 swuad_12. All rights reserved.
//
/*삭제 예정*/


import UIKit
import Eureka

import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import CodableFirebase

class MyPageModiController: FormViewController {
    var dbRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "닉네임 수정하기"
        
        form +++ Section("")
            <<< TextRow() { row in
                row.tag = "nickName"
                row.title = "닉네임"
                row.placeholder = "닉네임을 입력하세요."
        }
    }
    
    @IBAction func doSave(_ sender: Any) {
        if let nickName_row = form.rowBy(tag: "nickName") as? TextRow{
            
            guard let userID = Auth.auth().currentUser?.uid else {
                return // -> id 없으면 저장x
            }
            guard let key = dbRef.child("users/\(userID)").childByAutoId().key else {
                return
            }
            
            let path = "/users/\(userID)/\(key)"
            
            var post:[String:Any] = [
                "uid" : userID,
                "nickname" : nickName_row.value ?? ""
                                       ]
            
            dbRef.child(path).setValue(post) {
            (error, ref) in
                if let error = error {
                    NSLog(error.localizedDescription)
                    return
                }
            }
            
            /* -> firebase에 저장하지 않고 이름 수정
            print(nickName_row.value ?? "")
            
            guard let current_user = Auth.auth().currentUser else { return }
            
            let request = current_user.createProfileChangeRequest()
            request.displayName = nickName_row.value ?? ""
            request.commitChanges { (error) in
                guard let error = error else {return}
                NSLog(error.localizedDescription)
            }
            */
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}


