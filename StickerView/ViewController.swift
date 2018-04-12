//
//  ViewController.swift
//  StickerView
//
//  Created by 刘业臻 on 16/6/15.
//  Copyright © 2016年 luiyezheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var stickerView = JLStickerImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickerView.frame = view.frame
        stickerView.backgroundColor = .orange
        view.addSubview(stickerView)
        
        stickerView.addLabel(defaultText: "有り難うございました")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}