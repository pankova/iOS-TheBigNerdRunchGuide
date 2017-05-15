//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Pankova Mariya on 09.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    var geoButton: UIButton!
    var pinButton: UIButton!
    
    var locationManager = CLLocationManager.init()
    var state: Int = 0
    
    var homePin: MKPointAnnotation!
    var realHomePin: MKPointAnnotation!
    var futureTravelPin: MKPointAnnotation!


    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let sateliteString = NSLocalizedString("Satelite", comment: "Satelite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, sateliteString, hybridString])

        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)),for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
                                                                               constant: 8)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    // чтобы при сдвиге карты вернуться к обновившейся геопозиции
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        mapView.setCenter(userLocation.coordinate, animated: true)
//    }
    
    func geoButtonAction(_ sender: UIButton!) {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if locationManager.location != nil {
            let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setLocation(_ place: MKPointAnnotation!){
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if place != nil{
            let region = MKCoordinateRegion.init(center: (place.coordinate), span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func pinButtonAction(_ sender: UIButton!) {
        switch state {
        case 0:
            state += 1
            setLocation(homePin)
        case 1:
            state += 1
            setLocation(realHomePin)
        default:
            state = 0
            setLocation(futureTravelPin)
        }
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Map loaded")
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        
        // ** GeoButton options **
        
        let geoButton = UIButton(type: .custom)
        let buttonWidth = 40
        
        geoButton.frame = CGRect(x: 15,y: 100,width: buttonWidth, height: buttonWidth)
        geoButton.layer.cornerRadius = 0.5 * geoButton.bounds.size.width
        geoButton.layer.borderWidth = 0.25
        geoButton.layer.borderColor = UIColor.darkGray.cgColor
        geoButton.layer.backgroundColor = UIColor.lightGray.cgColor
        geoButton.setTitle("▲", for: UIControlState())
        geoButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        geoButton.addTarget(self, action: #selector(MapViewController.geoButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(geoButton)


        // ** MapPins options (set some pins on the map) **
        
        // homePin
        homePin = MKPointAnnotation()
        homePin.title = "Home"
        let homeCoordinates = CLLocationCoordinate2D(latitude: 54.866865, longitude: 83.089656)
        homePin.coordinate = homeCoordinates
        
        let homePinView = MKPinAnnotationView()
        homePinView.annotation = homePin
        homePinView.pinTintColor = UIColor.green
        homePinView.animatesDrop = true
        
        mapView.addAnnotation(homePin)
        
        // realHomePin
        realHomePin = MKPointAnnotation()
        realHomePin.title = "Real home"
        let realHomeCoordinates = CLLocationCoordinate2D(latitude: 48.362137, longitude: 135.040722)
        realHomePin.coordinate = realHomeCoordinates
        
        let realHomePinView = MKPinAnnotationView()
        realHomePinView.annotation = realHomePin
        realHomePinView.pinTintColor = UIColor.blue
        realHomePinView.animatesDrop = true
        
        mapView.addAnnotation(realHomePin)
        
        // futureTravelPin
        futureTravelPin = MKPointAnnotation()
        futureTravelPin.title = "Must visit"
        let futureTravelCoordinates = CLLocationCoordinate2D(latitude: 51.507486, longitude: -0.127635)
        futureTravelPin.coordinate = futureTravelCoordinates
        
        let futureTravelPinView = MKPinAnnotationView()
        futureTravelPinView.pinTintColor = UIColor.green
        futureTravelPinView.animatesDrop = true
        futureTravelPinView.annotation = futureTravelPin
        
        mapView.addAnnotation(futureTravelPin)
        
        
        // ** ButtonPin options **
        
        pinButton = UIButton(type: .custom)
        
        pinButton.frame = CGRect(x: 15,y: 200,width: buttonWidth, height: buttonWidth)
        pinButton.layer.cornerRadius = 0.5 * geoButton.bounds.size.width
        pinButton.layer.borderWidth = 0.25
        pinButton.layer.borderColor = UIColor.darkGray.cgColor
        pinButton.layer.backgroundColor = UIColor.lightGray.cgColor
        pinButton.setTitle("📌", for: UIControlState())
        pinButton.addTarget(self, action: #selector(MapViewController.pinButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(pinButton)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}
