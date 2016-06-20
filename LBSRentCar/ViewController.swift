//
//  ViewController.swift
//  LBSRentCar
//
//  Created by 宋旭 on 16/4/13.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit
import MapKit

let kToolBarViewHeight: CGFloat = 85
let kBtnInMapWidth: CGFloat = 40
let kBtnInMapHeight: CGFloat = 40

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private lazy var zoomLevel: Double = { 1 }()
    
    private lazy var mapView: MKMapView = {
        var temporaryView = MKMapView.init(frame: self.view.bounds)
        temporaryView.delegate = self
        temporaryView.userTrackingMode = .Follow
        temporaryView.showsUserLocation = true
        return temporaryView
    }()
    
    private lazy var toolBarView: JKToolBarView = {
        let frame = self.view.bounds
        let rect = CGRectMake(frame.origin.x,
                              frame.height - frame.origin.y - kToolBarViewHeight,
                              frame.width,
                              kToolBarViewHeight)
        let temporaryToolBarView = JKToolBarView.createJKRentCarView(rect)
        return temporaryToolBarView
    }()
    
    private var myDetailView: JKAnnotationDetailView?
    private var rentByHourAnnotations: [JKAnnotation]?
    private var rentByDayAnnotations: [JKAnnotation]?
    private var locationManager = CLLocationManager.init()
    
    //MARK:>>>>>>>>>>>>>>>>>>> ViewDidLoad <<<<<<<<<<<<<<<<<<<<
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //监控toolBarView中Slider的滑动情况
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(updateRentCarType),
                                                         name: "updateRentCarTypeNotification",
                                                         object: nil)
        
    }
    
    /**进入时开启定位授权并开始定位*/
    override func viewWillAppear(animated: Bool) {
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        
        self.view.addSubview(mapView)
        self.view.insertSubview(toolBarView, aboveSubview: mapView)
        self.setupBtnInMap(UIScreen.mainScreen().bounds)
    }
    
    /**退出时关闭定位*/
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        mapView.removeFromSuperview()
        toolBarView.removeFromSuperview()
    }
    
    /**
     *  时租与日租的切换
     */
    func updateRentCarType() {
        if toolBarView.pictureName == "rentByHourCar.jpg" {
            mapView.removeAnnotations(rentByDayAnnotations!)
            mapView.addAnnotations(rentByHourAnnotations!)
        } else if toolBarView.pictureName == "rentByDayCar.jpg" {
            mapView.removeAnnotations(rentByHourAnnotations!)
            mapView.addAnnotations(rentByDayAnnotations!)
        }
    }

    //MARK: addAnnotation
    func addAnnotation() {
        let myCoordinate1 = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude + 0.007, mapView.userLocation.coordinate.longitude + 0.01)
        let myCoordinate2 = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude - 0.004, mapView.userLocation.coordinate.longitude - 0.009)
        let myCoordinate3 = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude + 0.007, mapView.userLocation.coordinate.longitude + 0.007)
        let myCoordinate4 = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude - 0.004, mapView.userLocation.coordinate.longitude - 0.004)
        
        let annotation1 = JKAnnotation(myCoordinate: myCoordinate1, image: UIImage(named: "rentByHourCar.jpg")!, tag: 0)
        
        let annotation3 = JKAnnotation(myCoordinate: myCoordinate3, image: UIImage(named: "rentByHourCar.jpg")!, tag: 1)
        rentByHourAnnotations = [annotation1, annotation3]
        
        let annotation2 = JKAnnotation(myCoordinate: myCoordinate2, image: UIImage(named: "rentByDayCar.jpg")!, tag: 2)
        let annotation4 =  JKAnnotation(myCoordinate: myCoordinate4, image: UIImage(named: "rentByDayCar.jpg")!, tag: 3)
        rentByDayAnnotations = [annotation2, annotation4]
        
        mapView.addAnnotations(rentByHourAnnotations!)
        
    }
    
    //MARK: >>>>>>>>>>>>>>>>>> SetupButtonInMap <<<<<<<<<<<<<<<<<<<
    /**
     *  初始化按钮
     */
    func btnInitWith(frame: CGRect, btnImg: UIImage, btnHighlightedImg: UIImage) -> UIButton {
        let btn = UIButton.init(frame: frame)
        btn.setImage(btnImg, forState: .Normal)
        btn.setImage(btnHighlightedImg, forState: .Highlighted)
        mapView.addSubview(btn)
        return btn
    }
    
    /**
     *  对按钮进行设置
     */
    func setupBtnInMap(frame: CGRect) {
        let myLocationBtnRect = CGRectMake(10,
                                           frame.height - kToolBarViewHeight - kBtnInMapHeight - 60,
                                           kBtnInMapWidth,
                                           kBtnInMapHeight)
        
        let myZoomingInBtnRect = CGRectMake(frame.width - 10 - kBtnInMapWidth,
                                            myLocationBtnRect.origin.y - kBtnInMapHeight,
                                            kBtnInMapWidth,
                                            kBtnInMapHeight)
        
        let myZoomingOutBtnRect = CGRectMake(frame.width - 10 - kBtnInMapWidth,
                                             frame.height - kToolBarViewHeight - kBtnInMapHeight - 60,
                                             kBtnInMapWidth,
                                             kBtnInMapHeight)
        
        let locationBtn = self.btnInitWith(myLocationBtnRect,
                                           btnImg: UIImage(named: "mylocationBtn.png")!,
                                           btnHighlightedImg: UIImage(named: "mylocationBtnHighlighted.png")!)
        
        let zoomInBtn = self.btnInitWith(myZoomingInBtnRect,
                                         btnImg: UIImage(named: "zoomIn.png")!,
                                         btnHighlightedImg: UIImage(named: "zoomInHighlighted.png")!)
        let zoomOutBtn = self.btnInitWith(myZoomingOutBtnRect,
                                          btnImg: UIImage(named: "zoomOut.png")!,
                                          btnHighlightedImg: UIImage(named: "zoomOutHighlighted.png")!)
        zoomInBtn.tag = 1000
        zoomOutBtn.tag = 2000
        
        locationBtn.addTarget(self, action: #selector(ViewController.pitchUserCurrentPositionBtnClicked),
                              forControlEvents: .TouchUpInside)
        
        zoomInBtn.addTarget(self, action: #selector(ViewController.zoomBtnClicked(_:)),
                            forControlEvents: .TouchUpInside)
        zoomOutBtn.addTarget(self, action: #selector(ViewController.zoomBtnClicked(_:)),
                             forControlEvents: .TouchUpInside)
    }
    
    /**
     *  点击回到我的位置
     */
    func pitchUserCurrentPositionBtnClicked() {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 5000, 5000),
                          animated: true)
    }
    
    /**
     *  点击缩放
     */
    func zoomBtnClicked(btn: UIButton) {
        if btn.tag == 1000 {
            zoomLevel = 0.5
        } else if btn.tag == 2000 {
            zoomLevel = 2
        }
        var currentVisibleRect = mapView.visibleMapRect
        currentVisibleRect.size.width *= zoomLevel
        currentVisibleRect.size.height *= zoomLevel
        
        mapView.setVisibleMapRect(currentVisibleRect, animated: true)
    }
    
    //MARK: >>>>>>>>>>>>>>>>>>> MapViewDelegate <<<<<<<<<<<<<<<<<<
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let location = userLocation.location
        let geocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(location!) { (placeMarks: [CLPlacemark]?, error: NSError?) in
            let mark: CLPlacemark = (placeMarks?.last)!
            let dict = mark.addressDictionary
            print("\n您当前位于:\(dict)")
        }
        
        if self.rentByHourAnnotations == nil {
            self.addAnnotation()
        }
    }
    
    //MARK: load annotationView
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(JKAnnotation) {
            let key = "AnnotationKey"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(key)
            //允许交互点击
            if (annotationView == nil) {
                annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: key)
                annotationView!.frame = CGRectMake(0, 0, 30, 30)
            }
            //修改大头针视图
            //重新设置此类大头针视图的大头针模型（因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置）
            annotationView?.annotation = annotation
            //设置大头针视图的图片
            annotationView!.image = (annotation as! JKAnnotation).image
            //设置大头针视图的tag值
            annotationView?.tag = (annotation as! JKAnnotation).tag
            return annotationView
        } else {
            return nil
        }
    }
    
    //MARK: load and remove  annotationDetialView
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if (view.reuseIdentifier != nil) {
            let rect = CGRectMake(10, toolBarView.frame.origin.y - 30, self.view.frame.width - 20, 100)
            myDetailView = JKAnnotationDetailView(rect, atIndex: view.tag)
            toolBarView.removeFromSuperview()
            self.view.insertSubview(myDetailView!, aboveSubview: mapView)
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        myDetailView?.removeFromSuperview()
        self.view.insertSubview(toolBarView, aboveSubview: mapView)
    }
    
    //MARK: >>>>>>>>>>>>>>>>CLLocationManagerDelegate<<<<<<<<<<<<<<<<
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("定位失败: \(error)")
    }
    
}

