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
    @IBOutlet weak var dashboardView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    var totalDistance: Double = 0 {
        didSet {
            distanceLabel.text = String(totalDistance)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeUnitLabel: UILabel!
    
    var startTime = Date()
    var traveledTime: Double = 0 {
        didSet {
            displayTraveledTime()
        }
    }
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedUnitLabel: UILabel!
    
    var avgSpeed: Double = 0 {
        didSet {
            avgSpeedLabel.text = String(avgSpeed)
        }
    }
    
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var currentSpeedUnitLabel: UILabel!
    
    var currentSpeed: Double = 0 {
        didSet {
            currentSpeedLabel.text = String(currentSpeed)
        }
    }
    
    @IBOutlet weak var startButton: UIView!
    @IBOutlet weak var startLabel: UILabel!
    
    var locationManager : CLLocationManager!
    var checkPoints = [CLLocation]()
    var isRecording = false
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
    }
    
    private func configureView() {
        configureLocationManager()
        configureMap()
        configureUI()
//        configureTimer()
        
        prepareToStartRecording()
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
        resumeLocationButton.setShadow()
        
        let tapGuestureResumeLocation = UITapGestureRecognizer(target: self, action: #selector(resumeCurrentLocation(_:)))
        resumeLocationButton.addGestureRecognizer(tapGuestureResumeLocation)
        
        startButton.layer.cornerRadius = 0.5*startButton.frame.height
        startButton.setShadow()
        
        let tapGuestureStart = UITapGestureRecognizer(target: self, action: #selector(startRecording(_:)))
        startButton.addGestureRecognizer(tapGuestureStart)
        
        dashboardView.layer.cornerRadius = 10
        dashboardView.setShadow()
        
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
        guard var location : CLLocation = mapView?.userLocation.location else {return}
        
        if isRecording {
            
            stopTimer()
            startLabel.text = "Start"
            startButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
            if checkPoints.last != nil {
                location = checkPoints.last!
            }
            addPin(at: location, with: "End")
            
            setupAfterStopRecording()
            
        } else {
            prepareToStartRecording()
            
            startLabel.text = "Stop"
            startButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            startTimer()
            checkPoints += [location]
            addPin(at: location, with: "Begin")
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
    
    private func prepareToStartRecording() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        checkPoints.removeAll()
        
        totalDistance = 0
        traveledTime = 0
        avgSpeed = 0
        currentSpeed = 0
        
        startTime = Date()
        timerUpdateInterval = 0.1
    }
    
    private func setupAfterStopRecording() {
        
    }
    
    private func updateTotalDistance() {
        
    }
    
    var timerUpdateInterval = Double() {
        didSet {
            if isRecording {
                startTimer()
            }
        }
    }
    
    func startTimer() {
        timer.invalidate()
        if timerUpdateInterval < 0 {return}
        
        timer = Timer.scheduledTimer(withTimeInterval: timerUpdateInterval, repeats: true) {
            timer in
            self.traveledTime = Date().timeIntervalSince(self.startTime)
        }
        UIApplication.shared.isIdleTimerDisabled = true
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    private func displayTraveledTime() {
        var traveledTimeText : String
        var traveledTimeUnitText : String
        var displayedNumber : Double = 0
        switch traveledTime {
        case 0...60:
            traveledTimeUnitText = "s"
            timerUpdateInterval = 0.1
            displayedNumber = traveledTime
        case 60..<3600:
            traveledTimeUnitText = "m"
            timerUpdateInterval = 6
            displayedNumber = traveledTime/60
        case 3600..<3600*24:
            traveledTimeUnitText = "hr"
            timerUpdateInterval = 360
            displayedNumber = traveledTime/3600
        case (3600*24)...:
            traveledTimeUnitText = "d"
            timerUpdateInterval = 360*24
            displayedNumber = traveledTime/(3600*24)
        default:
            traveledTimeUnitText = "s"
            timerUpdateInterval = -1
            displayedNumber = 0
        }
        
        traveledTimeText = String(format: "%.1f", displayedNumber)
        timeLabel.text = traveledTimeText
        timeUnitLabel.text = traveledTimeUnitText

    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocation = manager.location else { return }
        if isRecording {
            if checkPoints.count > 0 {
                createPolyline(from: checkPoints.last!.coordinate, to: currentLocation.coordinate)
            }
            checkPoints += [currentLocation]
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

extension CLLocation {

    static func averageSpeed(of points: [CLLocation]) -> Double? {
        if points.count < 2 { return nil }

        var distanceInMeter: Double = 0
        for i in 1..<points.count {
            distanceInMeter += points[i].distance(from: points[i-1])
        }

        let timeIntervalInSec = points.last!.timestamp.timeIntervalSince(points.first!.timestamp)

        return distanceInMeter/timeIntervalInSec
    }

    static func instantaneousSpeeds(between points: [CLLocation]) -> [Double] {
        return points.map{$0.speed}
    }
}

extension UIView {
    func setShadow(color: CGColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    func setShadow() {
        self.setShadow(color: UIColor.black.cgColor, opacity: 0.5, offset: CGSize(width: 5, height: 5), radius: 5)
    }
}

