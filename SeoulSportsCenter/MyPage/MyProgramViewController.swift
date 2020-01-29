//
//  MyProgramViewController.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 10/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

import Eureka
import UIKit
import XMLParsing
import Alamofire
import SafariServices

class MyProgramViewController: UIViewController {
    var myProgram:MyProgram? // 전달 받은 프로그램 객체
    let storage = Storage.storage()
    var dbRef:DatabaseReference!
    
    
    
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var center_nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let detail = self.myProgram else {return}
        // 굳이 ??...dbRef = Database.database().reference()
        //programLabel.text = myProgram.program
        programLabel.text = detail.program ?? ""
        center_nameLabel.text = detail.center ?? ""
        subjectLabel.text = detail.subject ?? ""
        targetLabel.text = detail.target ?? ""
        weekLabel.text = detail.week ?? ""
        timeLabel.text = detail.time ?? ""
        addressLabel.text = detail.address ?? ""
    }
    // 전화 걸기 함수
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
        guard let detail = self.myProgram else {return}
        makePhoneCall(phoneNumber: detail.tel ?? "")
    }
    @IBAction func openSafari(_ sender: Any) {
        
        guard let detail = self.myProgram else {return}
        guard let url = URL(string: detail.homepage ?? "") else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}
