//
//  MyPageViewController.swift
//  SeoulSportsCenter
//
//  Created by 김소연 on 2020/01/14.
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

class MyPageViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 이미지 레이아웃 원으로 변경하기
        myImage.layer.masksToBounds = true
        myImage.layer.cornerRadius = myImage.bounds.width / 5
        
        Auth.auth().addStateDidChangeListener {(auth, user) in
            // 로그인 상태 -> 로그아웃으로 표시, 로그아웃 상태 -> 로그인으로 표시
            if let user = user {
                self.navigationItem.rightBarButtonItem?.title = "로그아웃"
            } else {
                self.navigationItem.rightBarButtonItem?.title = "로그인"
            }
        }
        setContent()
    }
    
    
    // 사용자 계정 정보 (이름, 메일)
    func setContent() {
        
        // -> kakao 로그인 정보
        KOSessionTask.userMeTask { (error, me) in
            if ((me) != nil) {
                if ((me?.account?.profile) != nil) {
                    self.nameLabel.text = me?.account?.profile?.nickname
                    
                    let processor = DownsamplingImageProcessor(size: self.myImage.frame.size) >> RoundCornerImageProcessor(cornerRadius: 0)
                    self.myImage.kf.indicatorType = .activity
                    self.myImage.kf.setImage(with: me?.account?.profile?.profileImageURL) {
                        result in
                        switch result { case .success(let value) :
                            print("Task doen for~")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    
                } else if ((me?.account!.profileNeedsAgreement)!) {
                    KOSession.shared()?.updateScopes(["profile"], completionHandler: { (error) in
                        if ((error) != nil) {
                            /*
                            if (error.code == KOErrorCancelled) {
                                // 동의 안함

                            } else {
                                // 기타 에러
                            }
                            */
                        } else {
                            // 동의함
                            // userMe를 다시 요청 시, 프로필 획득 가능
                        }
                    })
                } else {
                    
                }
            } else {
                NSLog("사용자 정보 요청 실패")
            }
        }
        
        // self.nameLabel.text = Auth.auth().currentUser?.displayName
        self.emailLabel.text = Auth.auth().currentUser?.email
               
    }
    
    // 로그인, 로그아웃
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let current_user = Auth.auth().currentUser{
            self.navigationItem.rightBarButtonItem?.title = "로그아웃"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "로그인"
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        if let current_user = Auth.auth().currentUser {
            try! Auth.auth().signOut()
            self.navigationItem.leftBarButtonItem?.title = "로그인"
        } else {
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self
            let providers:[FUIAuthProvider] = [
                FUIGoogleAuth(),
                FUIKakaoAuth()
            ]
            authUI?.providers = providers
            let authViewController = customViewController(authUI: authUI!)
            
            let nvc = UINavigationController(rootViewController: authViewController)
            authViewController.modalPresentationStyle = .fullScreen
            self.present(nvc, animated: true, completion: nil)
            }
    }
    
}
