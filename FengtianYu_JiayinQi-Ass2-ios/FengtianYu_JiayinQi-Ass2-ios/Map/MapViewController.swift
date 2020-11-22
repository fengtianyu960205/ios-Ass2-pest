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

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,DatabaseListener, UNUserNotificationCenterDelegate{
    
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
        getLocationBtn.isHidden = true
        //ask user for authoriztion for location and notification
        let authorisationStatus = CLLocationManager.authorizationStatus()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if authorisationStatus != .authorizedAlways {
            
            if authorisationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            }
            else if authorisationStatus == .denied{
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()

            }else if authorisationStatus == .restricted {
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()

            }
            
        }else{
            // if location status is always, show the button
         getLocationBtn.isHidden = false
        }
        if authorisationStatus == .authorizedWhenInUse {
            // if location status is when in use, show the button
            getLocationBtn.isHidden = false
        }
        
        
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            //
        }
        center.delegate = self
        
        //add the location to the annotation list
        addlocationtoMap()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
        
        Utility.StyleTextField(DestinationText)
        Utility.StyleTextField(startLocationText)
        Utility.StyleButtonFilled(getDirectionBtn)
    }
    
    func addlocationtoMap(){
        
        var distanseslist : [Double] = []
        
        // append all pests location to location list
        for specificPest in allPests{
            var index = 0
            let size = integer_t((specificPest.location.count)) as integer_t
            for n in 1...size {
                let inputString = (specificPest.location[index])
                let splits = inputString.components(separatedBy: ",")
                let lng = Double(splits[0])!
                let lat = (splits[1] as NSString).doubleValue
                let location = LocationAnnotation(title: specificPest.name  ,
                subtitle: splits[2],
                lat: lat, long: lng)
                locationList.append(location)
               index += 1
            }
        }
        
        // add all locations on the map
        for pestLocation in locationList{
            self.mapView.addAnnotation(pestLocation)
            showCircle(coordinate: pestLocation.coordinate,
                       radius: 10000)
            
            let point1 = CLLocation(latitude: pestLocation.coordinate.latitude, longitude: pestLocation.coordinate.longitude)
            let point2 = CLLocation(latitude: currentLocation?.latitude ?? -42.880999, longitude: currentLocation?.longitude ?? 147.281095)
            
            let distanse = point2.distance(from: point1)
            
            distanseslist.append(Double(distanse))
            

        }
        
        distanseslist.sort()
        let limit = distanseslist[18]
        
        for pestLocation in locationList{
            let point1 = CLLocation(latitude: pestLocation.coordinate.latitude, longitude: pestLocation.coordinate.longitude)
            let point2 = CLLocation(latitude: currentLocation?.latitude ?? -42.880999, longitude: currentLocation?.longitude ?? 147.281095)
            
            let distanse = point2.distance(from: point1)
            
            if Double(distanse) <= limit{
                geofence = CLCircularRegion(center: pestLocation.coordinate, radius: 10 * 1000, identifier: pestLocation.subtitle ?? "unknown location")
                geofence?.notifyOnExit = true
                geofence?.notifyOnEntry = true
                locationManager.startMonitoring(for: geofence!)
                print(pestLocation)
            }
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
       }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get user current address
         currentLocation = locationManager.location?.coordinate
        userLocation = locationManager.location
        var distanceslist : [Double] = []
        //for monitored in locationManager.monitoredRegions{
        //    locationManager.stopMonitoring(for: monitored)
       // }
        for pestLocation in locationList{
            
            let point1 = CLLocation(latitude: pestLocation.coordinate.latitude, longitude: pestLocation.coordinate.longitude)
            let point2 = CLLocation(latitude: currentLocation?.latitude ?? -42.880999, longitude: currentLocation?.longitude ?? 147.281095)
            
            let distanse = point2.distance(from: point1)
            
            distanceslist.append(Double(distanse))
            
        }
        distanceslist.sort()
        let limit = distanceslist[18]
        
        for pestLocation in locationList{
            let point1 = CLLocation(latitude: pestLocation.coordinate.latitude, longitude: pestLocation.coordinate.longitude)
            let point2 = CLLocation(latitude: currentLocation?.latitude ?? -42.880999, longitude: currentLocation?.longitude ?? 147.281095)
            
            let distanse = point2.distance(from: point1)
            
            if Double(distanse) <= limit{
                geofence = CLCircularRegion(center: pestLocation.coordinate, radius: 10 * 1000, identifier: pestLocation.subtitle ?? "unknown location")
                geofence?.notifyOnExit = true
                geofence?.notifyOnEntry = true
                locationManager.startMonitoring(for: geofence!)
                print(pestLocation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // if location statues is wheninuse or always ,show the button
            getLocationBtn.isHidden = false
            
        }
     }
    
    @IBAction func getDIrectionAct(_ sender: Any) {
        getAddress()
    }
    
    // This function is to  get the start address coordinate and destiantion address coordinate
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
       
    }
    
    // This function is to add a route from start location to destination on the map
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
           
      // if it is a pest location ,show a circle
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .red
            circleRenderer.alpha = 0.3

            return circleRenderer
        }
        // if it is a route , show polyline
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
        // if user click one annotation, it can zoom the map
        mapView.selectAnnotation(annotation, animated: true)
     let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 20000,longitudinalMeters: 20000)
     mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
     }
    
    // this function is to add a button on the annotation
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
    
    // this function is to get user current address to show it in the blank
    func autoAddress(){
        if let currentLocation = currentLocation {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation!) { (placemarks, error) in
                if let error = error{
                    self.displayMessage(title: "error", message: error.localizedDescription)
                }
                else if let placemarks = placemarks{
                    for placemark in placemarks{
                        if placemark.subThoroughfare == nil {
                            self.displayMessage(title: "Location is not correct", message: "Please type location manually")
                            return
                        }
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
        postNotification(region.identifier, "Exited")
        print(1)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        postNotification(region.identifier, "Entered")
        print(1)
    }
    
    func postNotification(_ eventRegion : String, _ eventReason: String){
        
        let content = UNMutableNotificationContent()
        content.title = "Pest Protection - \(eventReason)"
        content.body = "You have \(eventReason) the range of \(eventRegion)"
        content.sound = UNNotificationSound.default
        
        
        let date = Date().addingTimeInterval(5)
        let datecomponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: false)
        
        let uuid = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        
        center.add(request) { (error) in
            if let error = error{
                print(error)
            }else{
                print("added \(eventReason) \(eventRegion)")
            }
        }
        
    }
    
}
