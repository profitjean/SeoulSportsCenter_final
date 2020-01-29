//
//  SubIntroPageViewController.swift
//  SeoulSportsCenter
//
//  Created by 김지현 on 20/01/2020.
//  Copyright © 2020 swuad_12. All rights reserved.
//

import UIKit
import PageControls

class subIntroPageViewController: UIViewController {
    let image_titles = ["title1", "title2", "title3"]
    let pageControls = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        // 화면에 추가할 이미지 사이즈를 16:9로 설정하기 위해 계산
        let width = Double(screenSize.width)
        let height = Double(screenSize.height)
        
        
        for (index, imageName) in self.image_titles.enumerated() {
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: Double(index)*width, y: 0, width: Double(width), height: height)
            self.view.addSubview(imageView)
            
        }
        
        self.view.frame = CGRect(x: 0, y: 0, width: width*Double(self.image_titles.count), height: height)
        
    }
}
