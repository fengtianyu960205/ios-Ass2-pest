//
//  MapViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 11/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData
import UserNotifications

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,DatabaseListener{
    
   var listenerType: ListenerType = .all
    var locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var getDirectionBtn: UIButton!
    @IBOutlet weak var DestinationText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getLocationBtn: UIButton!
    @IBOutlet weak var startLocationText: UITextField!
    weak var databaseController: DatabaseProtocol?
    var allPests : [Pest] = []
    var locationList = [LocationAnnotation]()
    var currentLocation: CLLocationCoordinate2D?
    var userLocation : CLLocation?
    var startLocationCord : CLLocationCoordinate2D?
    var destinationCord: CLLocationCoordinate2D?
    var geofence : CLCircularRegion?
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the database controller
        self.navigationController?.navigationBar.isHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        allPests = databaseController?.getPests() as! [Pest]
        
        //ask user for authoriztion for location and notification
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
         getLocationBtn.isHidden = false
        }
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            //
        }
        
        //add the location to the annotation list
        addlocationtoMap()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        mapView.delegate = self
        getLocationBtn.isHidden = true
        
               
               
        // Do any additional setup after loading the view.
        
        Utility.StyleTextField(DestinationText)
        Utility.StyleTextField(startLocationText)
        Utility.StyleButtonFilled(getDirectionBtn)
    }
    
    func addlocationtoMap(){
       
        for specificPest in allPests{
            var index = 0
            let size = integer_t((specificPest.location.count)) as integer_t
            for n in 1...size {
                let inputString = (specificPest.location[index])
                let splits = inputString.components(separatedBy: ",")
                let lng = Double(splits[0])!
                let lat = (splits[1] as NSString).doubleValue
                let location = LocationAnnotation(title: splits[2],
                subtitle: "",
                lat: lat, long: lng)
                locationList.append(location)
                
               index += 1
            }
        }
        for pestLocation in locationList{
            self.mapView.addAnnotation(pestLocation)
            showCircle(coordinate: pestLocation.coordinate,
            radius: 10000)
            geofence = CLCircularRegion(center: pestLocation.coordinate, radius: 500, identifier: "geofence")
            geofence?.notifyOnExit = true
            geofence?.notifyOnEntry = true
            locationManager.startMonitoring(for: geofence!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           locationManager.startUpdatingLocation()
        databaseController?.addListener(listener: self)
          
       }
       
    override func viewDidDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           locationManager.stopUpdatingLocation()
        databaseController?.removeListener(listener: self)
        //locationList.removeAll()
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         currentLocation = locationManager.location?.coordinate
        userLocation = locationManager.location
           
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse {
            getLocationBtn.isHidden = false
            
        }
     }
    
    @IBAction func getDIrectionAct(_ sender: Any) {
        getAddress()
    }
    
    func getAddress(){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(DestinationText.text!) { [self] (placemarks, error) in
            guard let placemarks = placemarks,let location = placemarks.first?.location
                else{
                    self.displayMessage(title: "Error" , message: "destination not found")
                    return
            }
            geoCoder.geocodeAddressString(startLocationText.text!) { (placemarks, error) in
               guard let placemarks = placemarks,let startlocation = placemarks.first?.location
                    else{
                        self.displayMessage(title: "Error" , message: "start location not found")
                        return
                }
                self.startLocationCord = startlocation.coordinate
                self.destinationCord = location.coordinate
                mapthis(destinationCord:self.destinationCord! , startLocationCord: self.startLocationCord!)
            }
            
        }
        //geoCoder.geocodeAddressString(startLocationText.text!) { (placemarks, error) in
       //     guard let placemarks = placemarks,let startlocation = placemarks.first?.location
       //         else{
       //             self.displayMessage(title: "Error" , message: "start location not found")
       //             return
        //    }
       //     self.startLocationCord = startlocation.coordinate
       // }
        //mapthis(destinationCord:self.destinationCord! , startLocationCord: //self.startLocationCord!)
    }
    
    func mapthis(destinationCord : CLLocationCoordinate2D,startLocationCord :CLLocationCoordinate2D ){
        let sourceCordinate = startLocationCord
        let sourcePlacemark = MKPlacemark(coordinate: sourceCordinate)
        let destplaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark : sourcePlacemark)
        let destItem = MKMapItem(placemark : destplaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else{
                if let error = error{
                    self.displayMessage(title: "Error" , message: "some error happens")
                    return
                }
                return
            }
            for route in response.routes{
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView,
                    rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           
        //let circleOverlay = overlay as? MKCircle
       // let circleRenderer = MKCircleRenderer(overlay: circleOverlay as! MKOverlay)
       //        circleRenderer.fillColor = .red
       //        circleRenderer.alpha = 0.5

       // return circleRenderer
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .red
            circleRenderer.alpha = 0.3

            return circleRenderer
        }
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        mapView.addOverlay(circle)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
            style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onPestChange(change: DatabaseChange, pests: [Pest]) {
        
    }
    
    func onUserCDChange(change: DatabaseChange, user: [UserCD]) {
        
    }
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
     let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 20000,longitudinalMeters: 20000)
     mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
     }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let annotation = annotation as? LocationAnnotation {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView.annotation = annotation
                view = annotationView as! MKPinAnnotationView
                return annotationView
            } else {
                let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                

                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
            }
        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as? LocationAnnotation
        focusOn(annotation: annotation as! MKAnnotation)
    }
    

    @IBAction func getLocationAct(_ sender: Any) {
        autoAddress()
    }
    
    func autoAddress(){
        if let currentLocation = currentLocation {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation!) { (placemarks, error) in
                if let error = error{
                    self.displayMessage(title: "error", message: error.localizedDescription)
                }
                else if let placemarks = placemarks{
                    for placemark in placemarks{
                        self.startLocationText.text = placemark.subThoroughfare! + " " + placemark.thoroughfare!+" "+placemark.locality!+" "+placemark.administrativeArea!
                       
                    }
                }
            }
        } else {
            displayMessage(title: "Location Not Found", message: "The location has not yet been determined.")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //the content of notification
        let content = UNMutableNotificationContent()
        content.title = "Pest Protection - Exiting"
        content.body = "You have exit the range of " + region.description
        
        //create the trigger
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        
        //create the reuest and register the notification
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            //
        }
    }
    
}
