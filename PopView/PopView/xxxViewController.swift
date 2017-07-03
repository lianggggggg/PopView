//
//  xxxViewController.swift
//  PopView
//
//  Created by MrLiang on 2017/7/3.
//  Copyright © 2017年 MrLiang. All rights reserved.
//

import UIKit

class xxxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        PopView.share.releasePopView()
        
        let model1 = PopSourceModel()
        model1.img = "1"
        model1.title = "1"
        let model2 = PopSourceModel()
        model2.img = "2"
        model2.title = "2"
        let model3 = PopSourceModel()
        model3.img = "3"
        model3.title = "3"
        
        PopView.share.createPopView(target: self.navigationController!, dataSource: [model1,model2,model3]) { (indexPatch) in
            
            print(indexPatch)
            
        }
        
    }
    @IBAction func btnClick(_ sender: Any) {
        
        PopView.share.showPopWithAnimation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
