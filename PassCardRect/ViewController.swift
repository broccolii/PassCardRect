//
//  ViewController.swift
//  PassCardRect
//
//  Created by Broccoli on 15/12/3.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let control = PassCardRect(center: CGPoint(x: 200, y: UIScreen.mainScreen().bounds.width / 2.0))
        view.addSubview(control)
        control.backgroundColor = UIColor.clearColor()
        control.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: 300)
        control.becomeFirstResponder()
        
        control.passwordChangeBlock = {
            passwordString in
            debugPrint(passwordString)
          
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

