//
//  LocationChooseViewController.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 15.06.2026.
//

import UIKit
import MapKit
import CoreLocation

class LocationChooseViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()

    @IBOutlet weak var mapTypeSegment: UISegmentedControl!
    var exifCoordinate: CLLocationCoordinate2D?
    var onLocationSelected: ((String) -> Void)?
    var selectedCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.showsUserLocation = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mapLongPressed))
        mapView.addGestureRecognizer(longPress)
        
        mapView.selectableMapFeatures = [.pointsOfInterest]
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if let coordinate = exifCoordinate {
            centerMap(to: coordinate)
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc private func mapLongPressed(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let point = gesture.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        selectedCoordinate = coordinate
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] placemarks, _ in
            if let placemark = placemarks?.first {
                let name = [placemark.name, placemark.locality]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                DispatchQueue.main.async {
                    annotation.title = name
                    self?.onLocationSelected?(name)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    
    private func centerMap(to coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
  
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = sender.selectedSegmentIndex == 0 ? .standard : .hybrid
    }
    
}


extension LocationChooseViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if exifCoordinate == nil, let location = locations.first {
            centerMap(to: location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
}



extension LocationChooseViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard !(annotation is MKUserLocation) else { return }
        
        if let title = annotation.title, let locationName = title {
            selectedCoordinate = annotation.coordinate
            onLocationSelected?(locationName)
            navigationController?.popViewController(animated: true)
        }
    }
}
