//
//  ViewController.swift
//  WeatherFi
//
//  Created by Aakash Sinha on 24/05/22.
//
/* 1) get current loaction as default
 2) if not put location to nagpur maharashtra
 3) search for cities
 4) save recent 5 searches
 5) on click of city show current weather
 */
import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController  {
    
    var keyArray: [String] = []
    let userDefaults = UserDefaults.standard
    var weatherData: [WeatherModel]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    var cities: [String] = []
    var searchedCity = ["Alwar", "Nagpur", "Jaipur", "Delhi"]
    var recentCity: [String] = []
    var recentCode: [String] = []
    let initialLocation = CLLocation(latitude: 21.1458, longitude: 79.0882)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        configureTableView()
    }
    
    @IBAction func searchCity(_ sender: UIButton) {
        if searchBar.text != nil {
            recentCity.append(searchBar.text!)
            let urlString = API.getCityURL(cityName: searchBar.text!)
            print(urlString)
            fetchCityCode(cityName: searchBar.text!, for: urlString)
            
            userDefaults.set(recentCity, forKey: "recents")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }  
    }
    
    func fetchCityCode(cityName: String, for urlString: String) {
        NetworkManager<CityData>.fetchWeather(for: URL(string: urlString)!) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    for i in response {
                        self.keyArray = []
                        self.keyArray.append(i.key)
                        break
                    }
                    self.recentCode.append(self.keyArray.first!)
                    self.userDefaults.set(self.recentCode, forKey: "codes")
                    let weatherUrl =  API.getWeatherURL(locationKey: self.keyArray.first!)
                    self.fetchWeather(locationKey: self.keyArray.first!, urlString: weatherUrl)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchWeather(locationKey: String, urlString: String) {
        print(urlString)
        NetworkManager<WeatherData>.fetchWeather(for: URL(string: urlString)!) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    for i in response {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailViewController") as! WeatherDetailViewController
                        vc.temp = "\(i.temperature.imperial.value)"
                        vc.times = "\(i.epoch)"
                        vc.textt = i.weatherText
                        self.navigationController?.pushViewController(vc, animated: true)
                        break
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func configureLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        isLocationEnabled()
    }

    
    func isLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            print("access granted")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        let nagpur = MKPointAnnotation()
        nagpur.title = "Nagpur"
        nagpur.coordinate = CLLocationCoordinate2D(latitude: 21.1458, longitude: 79.0882)
        self.mapView.addAnnotation(nagpur)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let place = MKPointAnnotation()
        place.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        self.mapView.addAnnotation(place)
        mapView.centerToLocation(currentLocation)
        locationManager.stopUpdatingLocation()
        
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchedCityTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        tableView.register(UINib(nibName: "RecentSearchesTableViewCell", bundle: nil), forCellReuseIdentifier: "recentCityCell")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0 {
            return 1
        }
        else if section == 1  {
            if recentCity.count > 0 {
                return recentCity.count
            }
            return 0
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderTableViewCell
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentCityCell", for: indexPath) as! RecentSearchesTableViewCell
            cell.recentCityLabel.text = recentCity[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let codesSearches: [String] = userDefaults.object(forKey: "codes") as! [String]
        let weatherUrl =  API.getWeatherURL(locationKey: codesSearches[indexPath.row])
        self.fetchWeather(locationKey: codesSearches[indexPath.row], urlString: weatherUrl)
        
    }
}


private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


