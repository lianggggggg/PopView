//
//  PopTableView.swift
//  PopView
//
//  Created by MrLiang on 2017/6/26.
//  Copyright © 2017年 MrLiang. All rights reserved.
//

import UIKit

class PopTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var heightForRow:CGFloat = 40
    
    var source:[PopSourceModel] = []
    
    var itemsBlock:ItemsClickBlock?
    

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
