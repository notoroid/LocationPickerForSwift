//
//  LocationPickerViewController.swift
//  LocationPickerForSwift
//
//  Created by 能登 要 on 2016/09/18.
//  Copyright © 2016年 Irimasu Densan Planning. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {
    
    var locationCoordinate:CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    weak open var delegate: LocationPickerViewControllerDelegate?
    var locationCoordinateForInitialized:CLLocationCoordinate2D! = kCLLocationCoordinate2DInvalid
    
    private let locationManager :CLLocationManager = CLLocationManager();
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonSelect: UIButton!

    static func instantiate() -> LocationPickerViewController? {
        return UIStoryboard(name: "LocationPickerViewController", bundle: nil)
            .instantiateInitialViewController() as? LocationPickerViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 位置情報を有効化
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(LocationPickerViewController.onCancel(target:)))
        buttonSelect?.isEnabled = false
        
        if CLLocationCoordinate2DIsValid(locationCoordinateForInitialized) {
            mapView.centerCoordinate = locationCoordinateForInitialized
            mapView.region = MKCoordinateRegionMakeWithDistance(locationCoordinateForInitialized, 1200, 1200) // 1.2km

            // 初期化された位置にピンを立てる
            self.setAnnotation(locationCoordinate: locationCoordinateForInitialized, mapMove: false, animated: true)
        } else {
            self.locationManager.startUpdatingLocation()
            self.locationManager.delegate = self
            mapView.showsUserLocation = true
        }

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LocationPickerViewController.handleLongPressGesture(longpressGesture:)))
        mapView.addGestureRecognizer(longPressGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectLocation(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "位置の選択", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "この位置を選択", style: .default, handler: { [unowned self] _ in
            self.locationCoordinate = self.mapView.annotations[0].coordinate
            self.delegate?.locationPickerViewControllerDidSelectLocation(self)
        }))
        
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in
            
        }))

        self.present(alertController, animated: true, completion: {
            
        })
    }
    
    func onCancel(target:AnyObject?) {
        delegate?.locationPickerViewControllerDidCancel(self)
    }

    func handleLongPressGesture(longpressGesture:UILongPressGestureRecognizer) -> Void {
        if longpressGesture.state == . began {
            let touchPoint = longpressGesture.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            setAnnotation(locationCoordinate: touchCoordinate, mapMove: false, animated: false)
        }
    }
    
    func setAnnotation(locationCoordinate:CLLocationCoordinate2D,mapMove:Bool,animated:Bool) -> Void
    {
        // ピンを全て削除
        mapView.removeAnnotations(mapView.annotations)
        
        let anno = MKPointAnnotation()
        anno.coordinate = locationCoordinate
        mapView.addAnnotation(anno)
        
        // ピンの周りに円を表示
        let circle = MKCircle(center: locationCoordinate, radius: 200) // 半径500m
        mapView.add(circle)
        
        // ボタンを有効化
        buttonSelect.isEnabled = true
    }
}

extension LocationPickerViewController: MKMapViewDelegate,CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
                // 位置情報を停止
            
            mapView.centerCoordinate = location.coordinate
            mapView.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1200, 1200) // 1.2km
        }
    }
}

protocol LocationPickerViewControllerDelegate : NSObjectProtocol {
    func locationPickerViewControllerDidSelectLocation(_ locationPickerViewController: LocationPickerViewController)
    func locationPickerViewControllerDidCancel(_ locationPickerViewController: LocationPickerViewController)
}


