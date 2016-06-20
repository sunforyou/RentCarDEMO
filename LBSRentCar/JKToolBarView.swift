//
//  JKToolBarView.swift
//  LBSRentCar
//
//  Created by 宋旭 on 16/4/13.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit

let kLabelWidth: CGFloat = 40
let kLabelHeight: CGFloat = 30
let kLabelCount: CGFloat = 4
var mySpacing: CGFloat = 0

let kRentByHourSelected: Float = 0
let kRentByDaySelected: Float = 36
let kRentForMuchTimeSelected: Float = 67
let kTestDriveSelected: Float = 100

class JKToolBarView: UIView {

    typealias JKCarTypeClosure = (() -> String)?
    
    private var mySlider: UISlider?
    var pictureName = "rentByHourCar.jpg"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func createJKRentCarView(frame: CGRect) -> (JKToolBarView) {
        
        let myView = JKToolBarView.init(frame: frame)
        myView.backgroundColor = UIColor.whiteColor()
        myView.setupMyLabel(frame)
        myView.mySliderInit(frame)
        
        return myView
    }
    
    /**
     *  setup labels in the toolBarView
     */
    private func setupMyLabel(mainViewFrame: CGRect) {
        let labelSpacing = (mainViewFrame.width - 20 - kLabelWidth * kLabelCount) / (kLabelCount - 1)
        mySpacing = labelSpacing
        
        let rentByHourRect = CGRectMake(10, 10, kLabelWidth, kLabelHeight)
        let rentByDayRect = CGRectMake(10 + kLabelWidth + labelSpacing, 10, kLabelWidth, kLabelHeight)
        let rentForMuchTimeRect = CGRectMake(10 + kLabelWidth * 2 + labelSpacing * 2, 10, kLabelWidth, kLabelHeight)
        let testDriveRect = CGRectMake(10 + kLabelWidth * 3 + labelSpacing * 3, 10, kLabelWidth, kLabelHeight)
        
        self.myLabelInit(rentByHourRect, title: "时租")
        self.myLabelInit(rentByDayRect, title: "日租")
        self.myLabelInit(rentForMuchTimeRect, title: "长租")
        self.myLabelInit(testDriveRect, title: "试驾")
    }
    
    //MARK: >>>>>>>>>>>>>>>>>>>>>>>> Custom Init <<<<<<<<<<<<<<<<<<<<<<<<<<
    private func myLabelInit(frame: CGRect, title: String) {
        let myLabel = UILabel.init(frame: frame)
        myLabel.text = title
        myLabel.textAlignment = .Center
        self.addSubview(myLabel)
    }
    
    private func mySliderInit(mainViewFrame: CGRect) {
        
        let thumbcarImage = UIImage(named: "car")
        let slider = UISlider.init(frame: CGRectMake(10, 55, mainViewFrame.width - 20, 3))
        slider.tintColor = UIColor.lightGrayColor()
        slider.minimumValue = 0
        slider.value = 5
        slider.maximumValue = 100
        slider.setThumbImage(thumbcarImage, forState: .Highlighted)
        slider.setThumbImage(thumbcarImage, forState: .Normal)
        
        slider.addTarget(self,
                         action: #selector(JKToolBarView.sliderDragUp),
                         forControlEvents: .TouchUpInside)
        
        slider.addTarget(self,
                         action: #selector(JKToolBarView.sliderValueChanged),
                         forControlEvents: .ValueChanged)

        mySlider = slider
        self.addSubview(slider)
    }
    
    func sliderValueChanged() {
    }
    
    /**
     *  The springback effect of slider
     */
    func sliderDragUp() {
        
        let turningPoint = Float((mySpacing * 0.5 + kLabelWidth) * CGFloat(mySlider!.maximumValue) / mySlider!.frame.width)
        var currentValue = mySlider!.value
        
        if  currentValue < turningPoint {
            currentValue = kRentByHourSelected
        } else if currentValue >= turningPoint && currentValue < mySlider!.maximumValue / 2 {
            currentValue = kRentByDaySelected
        } else if currentValue >= mySlider!.maximumValue / 2 && currentValue < mySlider!.maximumValue - turningPoint {
            currentValue = kRentForMuchTimeSelected
        } else {
            currentValue = kTestDriveSelected
        }
        mySlider?.value = currentValue
        if mySlider?.value == kRentByHourSelected {
            self.pictureName = "rentByHourCar.jpg"
        } else if mySlider?.value == kRentByDaySelected {
            self.pictureName = "rentByDayCar.jpg"
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateRentCarTypeNotification",
                                                                  object: self)
    }
}
