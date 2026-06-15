//
//  LocationDetailsViewController.swift
//  firatilhancomtr
//
//  Created by Fırat İlhan on 15.06.2026.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myTypeSegment: UISegmentedControl!
    
    var coordinate: CLLocationCoordinate2D?
    var locationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let coordinate = coordinate else { return }
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .satellite
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locationName
        mapView.addAnnotation(annotation)
        
    }
    
    
      @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
          mapView.mapType = sender.selectedSegmentIndex == 0 ? .standard : .hybrid
      }
    

  

}
