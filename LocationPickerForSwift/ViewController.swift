//
//  ViewController.swift
//  LocationPickerForSwift
//
//  Created by 能登 要 on 2016/09/18.
//  Copyright © 2016年 Irimasu Densan Planning. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var labelLocation: UILabel!
    var locationCoordinate:CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectLocation(_ sender: AnyObject) {
        if let vc = LocationPickerViewController.instantiate() {
            vc.delegate = self
            
            if CLLocationCoordinate2DIsValid(locationCoordinate) {
                vc.locationCoordinateForInitialized = locationCoordinate
            }
            
            let nv = UINavigationController(rootViewController: vc)
            self.present(nv, animated: true, completion: {
                
            })
        
        }
        
    }
}

extension ViewController: LocationPickerViewControllerDelegate
{
    func locationPickerViewControllerDidSelectLocation(_ locationPickerViewController: LocationPickerViewController){
        self.dismiss(animated: true, completion: { [unowned self] in
            self.locationCoordinate = locationPickerViewController.locationCoordinate
            self.labelLocation.text = "緯度:\(self.locationCoordinate.latitude)\n軽度:\(self.locationCoordinate.longitude)"
        })
    }
    
    func locationPickerViewControllerDidCancel(_ locationPickerViewController: LocationPickerViewController){
        self.dismiss(animated: true, completion: {
            
        })
    }
}

