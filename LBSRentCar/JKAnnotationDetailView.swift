//
//  JKAnnotationDetailView.swift
//  LBSRentCar
//
//  Created by 宋旭 on 16/4/14.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit

class JKAnnotationDetailView: UIView {
    
    /** 考虑到弹出视图里面所有控件都不大，使用固定值也能适配所有屏幕*/
    private lazy var carImageView = { UIImageView(frame: CGRectMake(0, 0, 100, 100)) }()
    private lazy var carNameLabel = { UILabel(frame: CGRectMake(115, 5, 100, 20)) }()
    private lazy var distanceLabel = { UILabel(frame: CGRectMake(115, 40, 50, 20)) }()
    private lazy var locationLabel = { UILabel(frame: CGRectMake(160, 40, 100, 20)) }()
    private lazy var informationLabel = { UILabel(frame: CGRectMake(115, 75, 100, 20)) }()
    private lazy var priceLabel = { UILabel(frame: CGRectMake(220, 5, 100, 20)) }()
    
    init(_ frame: CGRect, atIndex index: NSInteger) {
        super.init(frame: frame)
        self.frame = frame
        self.detailViewInit(index)
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     *  初始化详情视图
     */
    private func detailViewInit(index: NSInteger) {
        
        let contentArray = self.arrayForContent()
        let model = contentArray[index] as! JKModel
        
        carImageView.image = UIImage(named: model.picture!)
        carNameLabel.text = model.name
        distanceLabel.text = model.distance
        locationLabel.text = model.location
        informationLabel.text = model.information
        priceLabel.text = model.price
        priceLabel.textColor = UIColor.orangeColor()
        
        self.addSubview(carImageView)
        self.addSubview(carNameLabel)
        self.addSubview(distanceLabel)
        self.addSubview(locationLabel)
        self.addSubview(informationLabel)
        self.addSubview(priceLabel)
    }
    
    /**
     *  获取plist文件内容
     */
    private func arrayForContent() -> NSMutableArray {
        let path = NSBundle.mainBundle().pathForResource("JKRentCar", ofType: "plist")
        let tmpArray = NSArray.init(contentsOfFile: path!)
        let modelArray: NSMutableArray = []
        for item in tmpArray! {
            let dict = item as! [String : AnyObject]
            let model = JKModel(dict: dict)
            modelArray.addObject(model)
        }
        return modelArray
    }
    
}
