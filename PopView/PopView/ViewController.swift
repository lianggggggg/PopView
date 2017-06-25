//
//  ViewController.swift
//  PopView
//
//  Created by MrLiang on 2017/6/23.
//  Copyright © 2017年 MrLiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let model1 = PopSourceModel()
        model1.img = "1"
        model1.title = "1"
        let model2 = PopSourceModel()
        model2.img = "2"
        model2.title = "2"
        let model3 = PopSourceModel()
        model3.img = "3"
        model3.title = "3"
        
        PopView.share.createPopView(target: self, dataSource: [model1,model2,model3], seat: .UpRight) { (indexPatch) in
            
            print(indexPatch)
            
        }

        
    }
    @IBAction func btnClick(_ sender: Any) {
//        PopView.share.showPopWithAnimation(isShow: true)
        PopView.share.showPopWithAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

