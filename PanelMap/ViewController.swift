//
//  ViewController.swift
//  MapDrawer
//
//  Created by TK on 2021/10/29.
//

import UIKit
import SnapKit
import MapKit

struct POIStore {
    let name: String
    let latitude: Double
    let longitude: Double
}

class ViewController: UIViewController {

    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let stores: [POIStore] = [
        .init(name: "摩斯漢堡 明耀店", latitude: 25.0405509, longitude: 121.5497692),
        .init(name: "無聊咖啡 AMBI- CAFE", latitude: 25.042658, longitude: 121.5490383),
        .init(name: "西雅圖極品咖啡-極品嚴焙", latitude: 25.041231, longitude: 121.5522009)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.layoutMargins = .init(top: 0, left: 0, bottom: view.safeAreaLayoutGuide.layoutFrame.height / 2, right: 0)
        
        let annotations = stores.map {
            StoreAnnotation(title: $0.name, coordinate: .init(latitude: $0.latitude, longitude: $0.longitude))
        }
        mapView.addAnnotations(annotations)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let storeAnnoation = view.annotation as? StoreAnnotation else { return }
        mapView.setCenter(storeAnnoation.coordinate, animated: true)
    }
}

// MARK: - StoreAnnotation

class StoreAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
