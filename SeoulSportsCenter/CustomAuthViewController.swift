//
//  CustomAuthViewController.swift
//  SeoulSportsCenter
//
//  Created by swuad_12 on 03/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import FirebaseUI

class customViewController:FUIAuthPickerViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth){
        super.init(nibName: "FUIAuthPickerViewController", bundle: nibBundleOrNil,authUI:authUI)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let backgroundImageView = UIImageView(frame: CGRect(x:0, y: 0, width: width, height: height))
        backgroundImageView.image = UIImage(named: "backGround")
        backgroundImageView.contentMode = .scaleAspectFill
        
        self.view.insertSubview(backgroundImageView, at: 0)
        self.view.subviews[1].backgroundColor = UIColor.clear
        self.view.subviews[1].subviews[0].backgroundColor = UIColor.clear
    }
    
}

