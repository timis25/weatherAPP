//
//  ViewController.swift
//  weatherApp
//
//  Created by Timur Israilov on 21/01/21.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController {
//    MARK: Variables
    var weatherArray:WeatherModel!
    var city: String?
    var userLocation = CLLocationCoordinate2D()
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshing(sender:)), for: .valueChanged)
        return refresh
    }()

    
    @IBOutlet weak var weatherTable: UITableView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mainDegreesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocmanager()
        weatherTable.refreshControl = refreshControl
        self.weatherTable.delegate = self
        self.weatherTable.dataSource = self
        
        
        
    }
//    MARK: startLocationManager
    func startLocmanager(){
        self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }

       
    }
    
    
    
    
    
// MARK: Parse Api
    func parse(lat:CLLocationDegrees , lon: CLLocationDegrees){
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=f7fbda9fc5f8e8a30619d82ee864d474"
        
        print(url)
        AF.request(url).responseJSON{response in
            guard let jsonData = response.data else {return}
        do{
            let weatherModel = try JSONDecoder().decode(WeatherModel.self,from: jsonData)
//            self.cityLabel.text = weatherModel.city?.name
            let  mainDegree = String(Int(round(weatherModel.current?.temp ?? 0)))
            self.mainDegreesLabel.text = "Сейчас \(mainDegree)C"
    } catch {
                print(error)
            }
          
        }
    
    }
//    MARK: RefreshTable
    @objc func refreshing(sender: UIRefreshControl){
        weatherTable.reloadData()
        sender.endRefreshing()
    }
}
// MARK: Extensions
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                    guard let userLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.userLocation = userLocation
            parse(lat:self.userLocation.latitude, lon: self.userLocation.longitude)
        }
}





extension ViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  weatherCell = weatherTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell {
            AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(userLocation.latitude)&lon=\(userLocation.longitude)&units=metric&appid=f7fbda9fc5f8e8a30619d82ee864d474").responseJSON{response in
                guard let jsonData = response.data else {return}
            do{
                let weatherModel = try JSONDecoder().decode(WeatherModel.self,from: jsonData)
                let degrees = String(Int(round(weatherModel.hourly?[indexPath.row].temp ?? 0)))
                let clouds: () =  weatherCell.weatherLabel.text = String( weatherModel.hourly?[indexPath.row].clouds ?? 0 )
                let feelsLike = String(Int(round(weatherModel.hourly?[indexPath.row].feelsLike ?? 0)))
                let windSpeed = String( weatherModel.hourly?[indexPath.row].windSpeed ?? 0)
                let humidity = String( weatherModel.hourly?[indexPath.row].humidity ?? 0)
                
                    weatherCell.weatherLabel.text = "Скороть ветра \(windSpeed)м/с , по ощущению \(feelsLike)C, влажность \(humidity)%"
               
                weatherCell.degreesLabel.text = "\(degrees)C"
        } catch {
                    print(error)
                }
              
            }
            
            return weatherCell
        }
        return TableViewCell()
    }
  }
