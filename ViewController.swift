//
//  ViewController.swift
//  ZQCodeTextField
//
//  Created by 张庆强 on 2018/3/2.
//  Copyright © 2018年 zhangqq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupUI() {
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 0, y: 100, width: screenWidth, height: 40)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = "输入验证码"
        self.view.addSubview(titleLabel)
        
        let codeView = ZQCodeTextField(frame: CGRect.init(x:20, y: 200, width: screenWidth - 40, height: 50))
        codeView.backgroundColor = UIColor.white
        self.view.addSubview(codeView)
        
        _ = codeView.becomeFirstResponder()
    }
}

