//
//  PopViewCell.swift
//  PopView
//
//  Created by MrLiang on 2017/6/25.
//  Copyright © 2017年 MrLiang. All rights reserved.
//

import UIKit

class PopViewCell: UITableViewCell {

    
    @IBOutlet weak var lbl2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell(model:PopSourceModel){
        lbl2.text = model.title
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
