//
//  PhotoViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 15/10/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController ,CLLocationManagerDelegate{
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var userLocatrion : CLLocation?
    
   
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var pestName: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var pestImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pestImage?.image = UIImage(named: "fox")
        
        takePhotoBtn.isHidden = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        
        let authorisationStatus = CLLocationManager.authorizationStatus()
        
        if authorisationStatus != .authorizedWhenInUse {
            
            if authorisationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            else if authorisationStatus == .denied{
                locationManager.requestWhenInUseAuthorization()
            }else if authorisationStatus == .restricted {
                locationManager.requestWhenInUseAuthorization()
            }
            
        }else{
            takePhotoBtn.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            userLocatrion = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse {
             takePhotoBtn.isHidden = false
        }
     }
    
    func autoAddress(){
        if let currentLocation = currentLocation {
            
       // street.text = "\(currentLocation.latitude)"
        //city.text = "\(currentLocation.longitude)"
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(userLocatrion!) { (placemarks, error) in
                if let error = error{
                    self.displayMessage(title: "error", message: error.localizedDescription)
                }
                else if let placemarks = placemarks{
                    for placemark in placemarks{
                        self.street.text = placemark.subThoroughfare! + " " +  placemark.thoroughfare!
                        self.city.text = placemark.locality
                        self.state.text = placemark.administrativeArea
                    }
                }
            }
        } else {
            displayMessage(title: "Location Not Found", message: "The location has not yet been determined.")
            
        }
    }
    
    @IBAction func takePhotoBtnAct(_ sender: Any) {
        autoAddress()
       }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
            style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
