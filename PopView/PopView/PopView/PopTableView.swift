//
//  PopTableView.swift
//  PopView
//
//  Created by MrLiang on 2017/6/26.
//  Copyright © 2017年 MrLiang. All rights reserved.
//

import UIKit

class PopTableView: UITableView,UITableViewDelegate,UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var heightForRow:CGFloat = 40
    
    private var source:NSArray = []
    
    private var itemsBlock:ItemsClickBlock?
    
    private var cellType:AnyClass?
    private var cellIdens:String?

    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = .clear
        self.rowHeight = heightForRow

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func configTableView(isNib:Bool,nibName:String?,cellType:AnyClass,cellIdens:String,dataSource:NSArray,cellBlock:@escaping ItemsClickBlock){
        
        if isNib {
            self.register(UINib.init(nibName: nibName!, bundle: nil), forCellReuseIdentifier: cellIdens)
        }else{
            self.register(cellType, forCellReuseIdentifier: cellIdens)
        }
        
        self.cellType = cellType
        self.cellIdens = cellIdens
        self.source = dataSource
        
        self.itemsBlock = {(indexPath:IndexPath?) -> () in
            if indexPath != nil {
                cellBlock(indexPath!)
            }
        }

        self.reloadData()
    }
    
    
//    MARK:UITableViewDelegate/UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.source.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.dequeueReusableCell(withIdentifier: self.cellIdens!, for: indexPath) 
        
        if cell is PopViewCell {
            (cell as! PopViewCell).initCell(model: self.source[indexPath.row] as! PopSourceModel)
        }
        
        if cell is PopCenterCell {
            (cell as! PopCenterCell).initCell(model: self.source[indexPath.row] as! centerSourceModel)
        }
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.itemsBlock != nil {
            self.itemsBlock!(indexPath)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
}











