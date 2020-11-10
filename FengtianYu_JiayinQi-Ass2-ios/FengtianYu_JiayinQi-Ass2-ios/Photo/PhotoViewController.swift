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
import CoreLocation

class PhotoViewController: UIViewController ,CLLocationManagerDelegate{
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var userLocatrion : CLLocation?
    
     weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var pestName: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var pestImage: UIImageView!
    var lat: Double?
    var lon : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        pestImage?.image = UIImage(named: "fox")
        
        takePhoto.contentVerticalAlignment = .fill
        takePhoto.contentHorizontalAlignment = .fill
        takePhoto.imageEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        currentLocationBtn.isHidden = true
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
            currentLocationBtn.isHidden = false
             locationBtnUI()
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
             currentLocationBtn.isHidden = false
            locationBtnUI()
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
    
   
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
            style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
   
    @IBAction func getCurrentLocation(_ sender: Any) {
        autoAddress()
    }
    
    func locationBtnUI(){
        
        
        currentLocationBtn.contentVerticalAlignment = .fill
        currentLocationBtn.contentHorizontalAlignment = .fill
        currentLocationBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
               
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func takePhotoAct(_ sender: Any) {
        addressToGeoPoint()
        
    }
    
    func addressToGeoPoint(){
        
        let geocoder = CLGeocoder()
        let streetString = self.street.text!
        let cityString = self.city.text!
        let stateString = self.state.text!
        let addressString = String(streetString)+","+String(cityString)+","+String(stateString)
        geocoder.geocodeAddressString(addressString) {
            placemarks, error in
            let placemark = placemarks?.first
            self.lat = placemark?.location?.coordinate.latitude
            self.lon = placemark?.location?.coordinate.longitude
            if placemark != nil{
                self.databaseController?.addPestLocation(id: "M3rPEqjDrkP0QRCSK69T",  location: "\(self.lon!)"+","+"\(self.lat!)"+","+cityString+","+stateString)
                self.displayMessage(title: "Add location", message: "Add location successfully.")
            }
            else{
                self.displayMessage(title: "Add location", message: "Can not find this location")
            }
        }
    }
}
