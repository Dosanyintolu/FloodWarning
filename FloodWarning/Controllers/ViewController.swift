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
    private(set) var flood = [Flood]()
    private var documentRef: DocumentReference?
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
        setupUI()
        configureObservers()
    }
    
    private func UpdateMapUI() {
        
        DispatchQueue.main.async {
            for flood in self.flood {
                self.addFloodToMap(flood)
            }
        }
    }
    
    
    private func configureObservers() {
        self.db.collection("flooded-regions").addSnapshotListener { [weak self] snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching snapshot")
                return
            }
            
            for changes in snapshot.documentChanges {
                if changes.type == .added {
                    if let floods = Flood(changes.document) {
                        self?.flood.append(floods)
                        self?.UpdateMapUI()
                    }
                } else if changes.type == .removed {
                    if let floods = Flood(changes.document) {
                        if let flood = self?.flood {
                            self?.flood = flood.filter{ $0.documentID != floods.documentID }
                            self?.UpdateMapUI()
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
       
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func addFloodWarning(_ sender: Any) {
        saveFloodToFirebase()
    }
    
    private func addFloodToMap(_ flood: Flood) {
        let annotation = FloodAnnotation(flood)
        annotation.coordinate = CLLocationCoordinate2D(latitude: flood.latitude, longitude: flood.longitude)
        annotation.title = "Flooded Area"
        annotation.subtitle = flood.reportedDate.convertDateToString()
        self.mapView.addAnnotation(annotation)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "FloodAnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "FloodAnnotationView")
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "flood-annotation")
            annotationView?.rightCalloutAccessoryView = UIButton.buttonForRightAccessoryView()
        }
        
        return annotationView
    }
    
    private func saveFloodToFirebase() {
        guard let location = self.locationManager.location else {
            return
        }

        
        var flood = Flood(location.coordinate.latitude, location.coordinate.longitude)
        
        self.db.collection("flooded-regions").addDocument(data: flood.toDictionary()) { [weak self] (error) in
            if let error = error  {
                print(error)
            } else {
                flood.documentID = self?.documentRef?.documentID
                self?.addFloodToMap(flood)
            }
        }
        
    }
    
    private func setupUI() {
        self.floodButton.layer.cornerRadius = 6.0
        self.floodButton.layer.masksToBounds = true
    }
    

}

