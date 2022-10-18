//
//  ViewController.swift
//  testMap
//
//  Created by Даниил Ермоленко on 18.10.2022.
//

import UIKit
import CoreMotion
import CoreLocation
import MapKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType(rawValue: 0)!
        map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 10
        return map
    }()
    
    var infoStackView = UIStackView()
    
    let heelView = InfoView(name: "Heel")
    let pitchView = InfoView(name: "Pitch")
    
    let motionManager = CMMotionManager()
    var timer: Timer!
    
    var locationManager = CLLocationManager()
    var allLocations: [CLLocation] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.startDeviceMotionUpdates()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MainViewController.updateMotion), userInfo: nil, repeats: true)
        
        setupLocationManager()
        setDelegates()
        setupViews()
        setConstraints()
    }
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnable()
    }
    
    // MARK: - setDelegates
    private func setDelegates() {
        
        mapView.delegate = self
        locationManager.delegate = self
    }
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = Colors.background.uiColor
        
        infoStackView = UIStackView(arrangedSubviews: [heelView,
                                                       pitchView],
                                    axis: .horizontal,
                                    spacing: 10)
        infoStackView.distribution = .fillEqually
        view.addSubview(infoStackView)
        view.addSubview(mapView)
        
    }
    // MARK: - updateMotion
    @objc func updateMotion() {
        if let deviceMotion = motionManager.deviceMotion {
            
            pitchView.valueLabel.text = String(format:"%.8f", deviceMotion.attitude.pitch)
            heelView.valueLabel.text = String(format:"%.8f", deviceMotion.attitude.roll)
        }
    }
    // MARK: - checkLocationEnable
    func checkLocationEnable() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
            showAlert(title: "У вас выключена служба геолокации", message: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    // MARK: - setupLocationManager
    func setupLocationManager() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    // MARK: - checkAuthorization
    func checkAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            break
        case .denied:
            showAlert(title: "Вы запртеили использование местоположения", message: "Хотие это изменить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
// MARK: - setConstraints
extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mapView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 40),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoStackView.heightAnchor.constraint(equalToConstant: 185)
        ])
    }
}
// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first(where: { $0.horizontalAccuracy >= 0 }) else {
            return
        }
        
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        
        let previousCoordinate = allLocations.last?.coordinate
        allLocations.append(currentLocation)
        
        if previousCoordinate == nil { return }
        
        var area = [previousCoordinate!, currentLocation.coordinate]
        let polyline = MKPolyline(coordinates: &area, count: area.count)
        mapView.addOverlay(polyline)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}
// MARK: - MKMapViewDelegate
extension MainViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4
        return renderer
    }
}
