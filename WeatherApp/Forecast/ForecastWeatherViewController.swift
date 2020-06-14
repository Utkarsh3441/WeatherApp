//
//  ForecastWeatherViewController.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/14/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation


class ForecastWeatherViewController: BaseViewController {
    
    let locationManager = CLLocationManager()
    var arrayData = [[WeatherDataModel]]()
    
    var arrayMonthlyData = [WeatherDataModel]()
    
    @IBOutlet weak var lblCity: UILabel!

    
    
    
    
    @IBOutlet weak var tblView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                             navigationController?.navigationBar.titleTextAttributes = textAttributes
               
        self.navigationItem.title = "Weather Forecast"
            
        self.tblView.register(UINib(nibName: WeatherTableViewCell.className, bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.className)
        
        self.fetchCurrentLocation()
        ForecastNetworkManager.sharedInstance.delegate = self


        // Do any additional setup after loading the view.
    }
    
    func fetchCurrentLocation()
    {

        locationManager.delegate = self
        locationManager.requestLocation()
        
    }
    
    func fetchWeatherForecast(cityName:String)
    {
        arrayData.removeAll()
        ForecastNetworkManager.sharedInstance.scheduleURLSessionForecastWeatherData(cityName: cityName)
        
        DispatchQueue.main.async{
            self.lblCity.text = cityName
        }
        
    }

}

extension ForecastWeatherViewController:CLLocationManagerDelegate
{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                print("Found user's location: \(location)")
                getPlacemark(forLocation: location) {
                    (originPlacemark, error) in
                        if let err = error {
                            print(err)
                        } else if let placemark = originPlacemark , let cityName = placemark.locality {
                            // Do something with the placemark
                            
                            self.fetchWeatherForecast(cityName: cityName)
                            
                    }
                }
                
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    

    
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in

            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })

    }
    
    
}

extension ForecastWeatherViewController: ForecastResponseProtocol
{
    func forecastModelDataForCity(arrWeatherData : [WeatherDataModel]) {
        
        
          let result = arrWeatherData.chunked(into: 8)
          print(result)
     
        arrayData = result
    
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
            self.tblView.reloadData()
        }
        
        
    }
    
    
    
}

extension ForecastWeatherViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 10))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            //  headerView.contentView.backgroundColor
            headerView.contentView.backgroundColor = .clear
            headerView.backgroundColor = UIColor.clear
            headerView.textLabel?.textColor = UIColor.themeColor
            
            headerView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        }
    }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  self.tblView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.className) as? WeatherTableViewCell
        
    
        cell?.setupCellForForecast(model: arrayData[indexPath.section][indexPath.row])
        
            
        return cell!
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (cell.responds(to: #selector(getter: UIView.tintColor))){
            if tableView == self.tblView {
                let cornerRadius: CGFloat = 12.0
                cell.backgroundColor = .clear
                let layer: CAShapeLayer = CAShapeLayer()
                let path: CGMutablePath = CGMutablePath()
                let bounds: CGRect = cell.bounds
                bounds.insetBy(dx: 25.0, dy: 0.0)
                var addLine: Bool = false
                
                if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
                   
                } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                    path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                    path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                    path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                    path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
                    
                } else {
                    path.addRect(bounds)
                    addLine = true
                }
                
                layer.path = path
                layer.fillColor = UIColor.white.withAlphaComponent(1.0).cgColor
              
                
                let testView: UIView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, at: 0)
                testView.backgroundColor = .clear
                cell.backgroundView = testView
            }
        }
    }
    
}

