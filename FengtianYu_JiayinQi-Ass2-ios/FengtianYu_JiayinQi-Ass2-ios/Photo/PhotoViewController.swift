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
import SwiftUI
import FirebaseStorage

class PhotoViewController: UIViewController ,CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var userLocatrion : CLLocation?
    let storage = Storage.storage().reference()
    
     weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var pestName: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var street: UITextField!
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var pestImage: UIImageView!
    var lat: Double?
    var lon : Double?
    var takingPicture:UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        takePhotoBtn.contentVerticalAlignment = .fill
        takePhotoBtn.contentHorizontalAlignment = .fill
        takePhotoBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 35, bottom: 25, right: 10)
        
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
            // if location status is wheninuse, then show the btn
            currentLocationBtn.isHidden = false
             locationBtnUI()
        }
        
        if authorisationStatus == .authorizedAlways{
            // if location status is always, then show the btn
            currentLocationBtn.isHidden = false
             locationBtnUI()
        }
        
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func setupView(){
        Utility.StyleTextField(pestName)
        Utility.StyleTextField(state)
        Utility.StyleTextField(city)
        Utility.StyleTextField(street)

        takePhotoBtn.imageEdgeInsets = UIEdgeInsets(top: 127.5, left: 71.25, bottom: 127.5, right: 71.25)
        takePhoto.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        currentLocationBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            userLocatrion = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse || status == .authorizedAlways  {
             currentLocationBtn.isHidden = false
            locationBtnUI()
        }
     }
    
    // this function will show user current address in the blank
    func autoAddress(){
        if let currentLocation = currentLocation {

            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(userLocatrion!) { (placemarks, error) in
                if let error = error{
                    self.displayMessage(title: "error", message: error.localizedDescription)
                }
                else if let placemarks = placemarks{
                    for placemark in placemarks{
                        if placemark.subThoroughfare == nil {
                            self.displayMessage(title: "Location is not correct", message: "Please type location manually")
                            return
                        }
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
    
    // this function is to convert location to geopoint and upload the photo to firebase
    func addressToGeoPoint(){
        
        var pestID : String?
        pestID = self.databaseController?.getPestidByName(pestName: self.pestName.text!)
        
        if pestID == "" {
            self.displayMessage(title: "Species Name", message: "the species is not in pest list ")
            return
        }
        
        guard let imageData = pestImage.image?.pngData()
            else{
                return
        }
        
        let number = Int.random(in: 1..<100)
        let numberString = String(number)
        let ref = storage.child(pestID! + "/file" + numberString + ".png")
        
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
                
                self.databaseController?.addPestLocation(id: pestID! ,  location: "\(self.lon!)"+","+"\(self.lat!)"+","+cityString+","+stateString)
                
                ref.putData(imageData, metadata: nil) { (_, error) in
                    guard error == nil
                    else{
                        self.displayMessage(title: "Download failure", message: "fail to upload")
                        return
                    }
                    
                    ref.downloadURL { (url, error) in
                        guard let url = url , error == nil else{
                            self.displayMessage(title: "download failure", message: "fail to download")
                            return
                        }
                        let urlString = url.absoluteString
                        self.databaseController?.addPestImages(id: pestID!, imageUrl: urlString)
                    }
                    
                }
                self.displayMessage(title: "Add location", message: "Add location successfully.")
            }
            else{
                self.displayMessage(title: "Add location", message: "Can not find this location")
            }
        }
    }
    
    // this function is to show to take a photo
    @IBAction func addPhotoAct(_ sender: Any) {
        
       // self.displayMessage(title: "add photo", message: "Can not find this location")
        let actionSheetController = UIAlertController()
         
         let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
             print("Tap cancel Button")
         }
         
         let takingPicturesAction = UIAlertAction(title: "take photo", style: UIAlertAction.Style.destructive) { (alertAction) -> Void in
             self.getImageGo(type: 1)
         }
         
         let photoAlbumAction = UIAlertAction(title: "photo library", style: UIAlertAction.Style.default) { (alertAction) -> Void in
             self.getImageGo(type: 2)
         }
                 
         actionSheetController.addAction(cancelAction)
         actionSheetController.addAction(takingPicturesAction)
         actionSheetController.addAction(photoAlbumAction)
         

        actionSheetController.popoverPresentationController?.sourceView = sender as? UIView
         self.present(actionSheetController, animated: true, completion: nil)
    }
    
   
    // get image from photo library or user take a photo
    func getImageGo(type:Int){
        takingPicture =  UIImagePickerController.init()
        
        if(type==1){
            takingPicture.sourceType = .camera
           
        }else if(type==2){
            takingPicture.sourceType = .photoLibrary
        }
        
        takingPicture.allowsEditing = false
        takingPicture.delegate = self
        present(takingPicture, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       takingPicture.dismiss(animated: true, completion: nil)
       if(takingPicture.allowsEditing == false){
           
            pestImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            takePhotoBtn.setImage(nil, for: .normal)
            
       }else{
           
           pestImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            takePhotoBtn.setImage(nil, for: .normal)
       }
    
    }
    
}
