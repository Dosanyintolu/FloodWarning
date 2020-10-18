//
//  ViewController.swift
//  FloodWarning
//
//  Created by Doyinsola Osanyintolu on 10/16/20.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var floodButton: UIButton!
    
    private lazy var db: Firestore = {
        
        let firestoreDB = Firestore.firestore()
        return firestoreDB
    }()
    private lazy var locationManager: CLLocationManager = {
       
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
       
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func addFloodWarning(_ sender: Any) {
    
        guard let location = self.locationManager.location else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = "Flooded"
        annotation.subtitle = "Reported 12:00am"
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
        
        saveFloodToFirebase()
        
    }
    
    private func saveFloodToFirebase() {
        self.db.collection("Flooded-regions").addDocument(data:["latitude" : 12.00, "longitude" : 11.00]){ (error) in
            if let error = error {
                print(error)
            } else {
                print("saved")
            }
        }
    }
    
    private func setupUI() {
        self.floodButton.layer.cornerRadius = 6.0
        self.floodButton.layer.masksToBounds = true
    }
    

}

