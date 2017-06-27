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
private let CenterPopView_tag:Int = 22222
private let backView_tag:Int = 11111
private let centerBackView_tag:Int = 33333
private let iPhone6_screen:CGFloat = 375.0

private let margin:CGFloat = 15 //边缘距离


//MARK:popview


class PopSourceModel: NSObject {
    var title:String?
    var img:String?
}

@objc enum Seat:Int {
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


class PopView: UIView {

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
    private var backView:UIView?
    
    private var isShow:Bool = true
    
    
    lazy private var tableView:PopTableView = {
        let table = PopTableView.init(frame: CGRect.zero, style: .plain)
        return table
    }()
    
    
    
    
    static let share:PopView = {
        let view = PopView()
        view.tag = PopView_tag
        view.imageView = UIImageView()
        view.backView = UIView()
        return view
    }()
    
    
    open func createPopView(frame:CGRect = .zero,target:UIViewController,dataSource:[PopSourceModel],seat:Seat = .UpRight,itemsClickBlock:@escaping ItemsClickBlock){
        
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
        
    
        
        self.tableView.frame = CGRect.init(x: 0, y: 15, width: frame.size.width, height: frame.size.height)
        
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (self.target?.view.bounds.width)!, height: (self.target?.view.bounds.height)!))
        backView.backgroundColor = .black
        backView.alpha = 0.0
        backView.tag = backView_tag
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backView.addGestureRecognizer(tap)
        self.backView = backView
        self.target?.view.addSubview(self.backView!)
        
        self.addSubview(self.imageView!)
        self.addSubview(self.tableView)
        
        self.tableView.configTableView(isNib: true, nibName: "PopViewCell", cellType: object_getClass(PopViewCell), cellIdens: "PopViewCell", dataSource: self.dataSource as! NSArray) { (indexPath) in
            if self.block != nil {
                 self.block!(indexPath)
            }
        }
        
        self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01) //整个缩小
        
    }
    
    @objc private func tapClick(){
        
        //隐藏整个视图
        showPopWithAnimation()
    }

    //MARK:animation
    open func showPopWithAnimation(){
    
        let popView = UIApplication.shared.keyWindow?.viewWithTag(PopView_tag) as! PopView
        let backView = UIApplication.shared.keyWindow?.viewWithTag(backView_tag) as! UIView
        popView.tableView.contentOffset = CGPoint.zero
        
        self.target?.view.bringSubview(toFront: backView)
        self.target?.view.bringSubview(toFront: popView)
        
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
    

    deinit {
        self.removeFromSuperview()
    }
    
}

//MARK:centerPopView


class centerSourceModel: NSObject {
    var isSelected:Bool?
    var title:String?
}



class CenterPopView: UIView {
    
    var block:ItemsClickBlock?
    
    var target:UIViewController? //展示所在的控制器
    var dataSource:[centerSourceModel]? //数据源
    
    
    var maxItemsCount:Int = 6 //显示几格  确定tableview的大小
    var cellRowHeight:CGFloat = 40 //cell的高度
    
    private var imageView:UIImageView?
    private var backView:UIView?
    
    lazy private var tableView:PopTableView = {
        let table = PopTableView.init(frame: CGRect.zero, style: .plain)
        return table
    }()
    
    private var isShow:Bool = true
    
    static let share:CenterPopView = {
        let view = CenterPopView()
        view.tag = CenterPopView_tag
        view.imageView = UIImageView()
        view.backView = UIView()
        return view
    }()
    
    
    //MARK:中间弹出框
    
    
    open func createCenterPopView(width:CGFloat,height:CGFloat,color:UIColor = .white,target:UIViewController,dataSource:[centerSourceModel],itemsBlock:@escaping ItemsClickBlock){
        
        CenterPopView.share.dataSource = dataSource
        CenterPopView.share.frame.size = CGSize.init(width: width, height: height)

        CenterPopView.share.center = target.view.center
        
        CenterPopView.share.backgroundColor = color
        CenterPopView.share.target = target
        CenterPopView.share.layer.masksToBounds = true
        CenterPopView.share.layer.cornerRadius = 10
        
        CenterPopView.share.block = {(indexPath:IndexPath?) -> () in
            
            if indexPath != nil {
                itemsBlock(indexPath!)
            }
            
        }
        
        
        CenterPopView.share.createCenterUI(width: width, height: height)
        target.view.addSubview(CenterPopView.share)
        
    }
    
    private func createCenterUI(width:CGFloat,height:CGFloat){
        
        self.tableView.frame = CGRect.init(x: 0, y: 10, width: width, height: height-20)
        
        let backView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (self.target?.view.bounds.width)!, height: (self.target?.view.bounds.height)!))
        backView.backgroundColor = .black
        backView.alpha = 0.0
        backView.tag = centerBackView_tag
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backView.addGestureRecognizer(tap)
        self.backView = backView
        self.target?.view.addSubview(self.backView!)
        
        self.addSubview(self.tableView)
        
        
        self.tableView.configTableView(isNib: true, nibName: "PopCenterCell", cellType: object_getClass(PopCenterCell), cellIdens: "PopCenterCell", dataSource: self.dataSource as! NSArray) { (indexPath) in
            
        }
        
        
        self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01) //整个缩小
        
    }

    @objc private func tapClick(){
        
        //隐藏整个视图
        showPopWithAnimation()
    }
    
    
    open func showPopWithAnimation(){
    
        let centerPopView = UIApplication.shared.keyWindow?.viewWithTag(CenterPopView_tag) as! CenterPopView
        let backView = UIApplication.shared.keyWindow?.viewWithTag(centerBackView_tag) as! UIView
        centerPopView.tableView.contentOffset = CGPoint.zero
        
        self.target?.view.bringSubview(toFront: backView)
        self.target?.view.bringSubview(toFront: centerPopView)
        
        
        UIView.animate(withDuration: 0.3) {
            
            if self.isShow {
                centerPopView.alpha = 1
                backView.alpha = 0.3
                centerPopView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.isShow = false
            }else{
                centerPopView.alpha = 0
                backView.alpha = 0
                centerPopView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
                self.isShow = true
            }
            
        }
        
    }
    
    deinit {
        self.removeFromSuperview()
    }
    
}







