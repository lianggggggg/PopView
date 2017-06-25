//
//  PopView.swift
//  PopView
//
//  Created by MrLiang on 2017/6/23.
//  Copyright © 2017年 MrLiang. All rights reserved.
//

import UIKit

typealias ItemsClickBlock = (IndexPath) -> ()


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

private let PopView_tag:Int = 9999
private let backView_tag:Int = 11111
private let iPhone6_screen:CGFloat = 375.0

private let margin:CGFloat = 15 //边缘距离

class PopSourceModel: NSObject {
    var title:String?
    var img:String?
}

enum Seat {
    case UpLeft
    case UpCenter
    case UpRight
    
    case DownLeft
    case DownCenter
    case DownRight
    
    case LeftUp
    case LeftCenter
    case LeftDown
    
    case RightUp
    case RightCenter
    case RightDOWN
}


class PopView: UIView,UITableViewDelegate,UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var block:ItemsClickBlock?
    
    var target:UIViewController? //展示所在的控制器
    var dataSource:[PopSourceModel]? //数据源
    
    
    var maxItemsCount:Int = 6 //显示几格  确定tableview的大小
    var cellRowHeight:CGFloat = 40 //cell的高度
    
    private var imageView:UIImageView?
    private var tableView:UITableView?
    private var backView:UIView?
    
    private var isShow:Bool = true
    
    static let share:PopView = {
        let view = PopView()
        view.tag = PopView_tag
        view.imageView = UIImageView()
        
        view.tableView = UITableView()
        view.tableView?.dataSource = view
        view.tableView?.delegate = view
        view.tableView?.backgroundColor = .clear
        view.tableView?.separatorStyle = .none
        
        view.tableView?.register(UINib.init(nibName: "PopViewCell", bundle: nil), forCellReuseIdentifier: "PopViewCell")
        
        view.backView = UIView()
        return view
    }()
    
    
    open func createPopView(frame:CGRect = .zero,target:UIViewController,dataSource:[PopSourceModel],seat:Seat,itemsClickBlock:@escaping ItemsClickBlock){
        
        var popViewFrame = CGRect.zero
        
        let foctor:CGFloat = UIScreen.main.bounds.width < iPhone6_screen ? 0.36 : 0.3
        let width:CGFloat = frame.size.width > 0 ? frame.size.width : SCREEN_WIDTH*foctor
        let height:CGFloat = dataSource.count > maxItemsCount ? (CGFloat(maxItemsCount) * cellRowHeight) : (CGFloat(dataSource.count) * cellRowHeight)
        let x:CGFloat = frame.origin.x > 0 ? frame.origin.x : SCREEN_WIDTH - width - margin/2
        let y:CGFloat = frame.origin.y > 0 ? frame.origin.y : 64 - margin/2
        
        var rect:CGRect = CGRect.init(x: x, y: y, width: width, height: height) //tableview的frame的宽高
        popViewFrame = CGRect.init(x: x, y: y, width: width, height: height+margin) //popView的frame
        
        
        PopView.share.frame = popViewFrame
        
        //MARK:位置↓↓↓↓↓↓↓
        
        PopView.share.layer.anchorPoint = CGPoint.init(x: 0.9, y: 0) //锚点 为长宽的比例值 0~1 移动后形成移动效果  以0.9 0 为锚点 会形成向左弹出 0.1 0 向右弹出
        PopView.share.layer.position = CGPoint.init(x: popViewFrame.origin.x + popViewFrame.size.width - margin, y: popViewFrame.origin.y)//运动后的位置
        //MARK:位置↑↑↑↑↑↑↑
        
//        PopView.share.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        PopView.share.target = target
        PopView.share.dataSource = dataSource
        
        maxItemsCount = dataSource.count > maxItemsCount ? maxItemsCount : dataSource.count
        
        PopView.share.block = {(indexPatch:IndexPath?) -> () in
            if indexPatch != nil {
                itemsClickBlock(indexPatch!)
            }
        }

        PopView.share.createUI(frame: rect)
        
        target.view.addSubview(PopView.share)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.bounds = bounds
    }
    
    
    private func createUI(frame:CGRect){
        var imageView = UIImageView()
        imageView.frame = self.bounds
        imageView.image = UIImage.init(named: "pop_black_backGround")
        //MARK:位置↓↓↓↓↓↓↓
        
        //可以不写
        imageView.layer.anchorPoint = CGPoint.init(x: 1, y: 0)
        imageView.layer.position = CGPoint.init(x: self.bounds.width, y: 0)
        //MARK:位置↑↑↑↑↑↑↑
        self.imageView = imageView
        
    
        
        self.tableView?.frame = CGRect.init(x: 0, y: 15, width: frame.size.width, height: frame.size.height)
        
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 64, width: (self.target?.view.bounds.width)!, height: (self.target?.view.bounds.height)!))
        backView.backgroundColor = .black
        backView.alpha = 0.0
        backView.tag = backView_tag
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backView.addGestureRecognizer(tap)
        self.backView = backView
        self.target?.view.addSubview(self.backView!)
        
        self.addSubview(self.imageView!)
        self.addSubview(self.tableView!)
        
        self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01) //整个缩小
        
    }
    
    func tapClick(){
        
        //隐藏整个视图
        showPopWithAnimation()
    }

    
    //MARK:tableviewdelegate/rableviewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellRowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = self.tableView!.dequeueReusableCell(withIdentifier: "PopViewCell", for: indexPath) as? PopViewCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PopViewCell", owner: nil, options: nil)?.first as! PopViewCell
        }
        
        cell?.initCell(model: self.dataSource![indexPath.row])
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.block != nil {
            block!(indexPath)
        }
        
    }
    
    //MARK:animation
    open func showPopWithAnimation(){
//    open func showPopWithAnimation(isShow:Bool){
    
        let popView = UIApplication.shared.keyWindow?.viewWithTag(PopView_tag) as! PopView
        let backView = UIApplication.shared.keyWindow?.viewWithTag(backView_tag) as! UIView
        popView.tableView?.contentOffset = CGPoint.zero
        
        UIView.animate(withDuration: 0.3) {
            
            if self.isShow {
                popView.alpha = 1
                backView.alpha = 0.3
                popView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.isShow = false
            }else{
                popView.alpha = 0
                backView.alpha = 0
                popView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                self.isShow = true
            }
            
            
            
        }
        
        
    }
    
    
    
    
}
