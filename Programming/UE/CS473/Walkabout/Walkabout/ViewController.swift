//
//  ViewController.swift
//  Walkabout
//
//  Created by Nhan Cao on 10/23/19.
//  Copyright © 2019 Nhan Cao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resumeLocationButton: UIView!
    
    
    @IBOutlet weak var startButton: UIView!
    @IBOutlet weak var startLabel: UILabel!
    
    var locationManager : CLLocationManager!
    
    var checkPoints = [CheckPoint]()
    
    var isRecording = false {
        didSet {
//            checkPoints.removeAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
    }
    
    private func configureView() {
        configureLocationManager()
        configureMap()
        configureUI()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    private func configureMap() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        let location = CLLocationCoordinate2DMake(37.971558, -87.571091)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    private func configureUI() {
        resumeLocationButton.layer.cornerRadius = 0.5*resumeLocationButton.frame.height
        resumeLocationButton.layer.shadowColor = UIColor.black.cgColor
        resumeLocationButton.layer.shadowOpacity = 0.5
        resumeLocationButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        resumeLocationButton.layer.shadowRadius = 10
        
        let tapGuestureResumeLocation = UITapGestureRecognizer(target: self, action: #selector(resumeCurrentLocation(_:)))
        resumeLocationButton.addGestureRecognizer(tapGuestureResumeLocation)
        
        startButton.layer.cornerRadius = 0.5*startButton.frame.height
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        startButton.layer.shadowRadius = 10
        
        let tapGuestureStart = UITapGestureRecognizer(target: self, action: #selector(startRecording(_:)))
        startButton.addGestureRecognizer(tapGuestureStart)
        
    }
    
    @objc private func resumeCurrentLocation(_ sender: Any) {
        let coord = mapView?.userLocation.coordinate
        if coord != nil {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coord!, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @objc private func startRecording(_ sender: Any) {
        var location = mapView?.userLocation.location
        
        if isRecording {
            
            if checkPoints.last != nil {
                location = checkPoints.last?.location
            }
            
            if location != nil {
                addPin(at: location!, with: "End")
            }
            startLabel.text = "Start"
            startButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
        } else {
            restartMapContent()
            
            if location != nil {
                checkPoints += [CheckPoint(location: location!)]
                addPin(at: location!, with: "Begin")
            }
            startLabel.text = "Stop"
            startButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
        isRecording = !isRecording
    }
    
    private func addPin(at location: CLLocation, with title: String? = nil, with subtitle: String? = nil) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = location.coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    
    private func saveRecord() {
        
    }
    
    private func restartMapContent() {
        removeAllOverlays()
        removeAllAnnotations()
        checkPoints.removeAll()
    }
    
    private func removeAllOverlays() {
        mapView.removeOverlays(mapView.overlays)
    }
    
    private func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocation = manager.location else { return }
        if isRecording {
            if checkPoints.count > 0 {
                createPolyline(from: checkPoints.last!.location.coordinate, to: currentLocation.coordinate)
            }

            checkPoints += [CheckPoint(location: currentLocation)]
        }
    }
    
    func createPolyline(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let points = [origin, destination]
        let polyline = MKPolyline(coordinates: points, count: 2)
        mapView.addOverlay(polyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    
    
    
    
}

