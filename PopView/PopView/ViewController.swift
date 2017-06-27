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
        
        PopView.share.createPopView(target: self, dataSource: [model1,model2,model3]) { (indexPatch) in
            
            print(indexPatch)
            
        }
        
        let sModel1 = centerSourceModel()
        sModel1.isSelected = true
        sModel1.title = "1"
        let sModel2 = centerSourceModel()
        sModel2.isSelected = false
        sModel2.title = "2"
        let sModel3 = centerSourceModel()
        sModel3.isSelected = false
        sModel3.title = "3"
        
        
        CenterPopView.share.createCenterPopView(width: 100, height: 140, target: self, dataSource: [sModel1,sModel2,sModel3]) { (indexPath) in
            
        }
        
        
        
    }
    @IBAction func btnClick(_ sender: Any) {
        PopView.share.showPopWithAnimation()
    }
    @IBAction func buttonClick(_ sender: UIButton) {
        CenterPopView.share.showPopWithAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

