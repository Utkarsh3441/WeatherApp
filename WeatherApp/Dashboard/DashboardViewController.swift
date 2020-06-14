//
//  ViewController.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/13/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit


class DashboardViewController: BaseViewController,CurrentResponseProtocol {
        
    
    @IBOutlet weak var searchbar: UISearchBar!
    var cityNameArr:Array<String>?
    
    var arrayWeatherData = [WeatherDataModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchbar.delegate = self
 
        CurrentNetworkManager.sharedInstance.delegate = self
                
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
             
             self.navigationController?.navigationBar.isHidden = true
             

         }
     
     override func viewWillDisappear(_ animated: Bool) {
            
            super.viewWillDisappear(animated)
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        }
    
    func dailyModelDataForCity(weatherData: WeatherDataModel) {
        print(weatherData)
        
        arrayWeatherData.append(weatherData)
        
        if arrayWeatherData.count == cityNameArr?.count
        {
            self.pushToCurrentWeatherController()
        }
        
              
    }
    
    func pushToCurrentWeatherController()
    {
        
        DispatchQueue.main.async {
            
            
            self.dismiss(animated: false, completion: nil)
            
             let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CurrentWeatherViewController") as? CurrentWeatherViewController

            viewController?.arrayData = self.arrayWeatherData

            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
       
    }
    
    
    @IBAction func weatherForecastButtonTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            

            
               let viewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForecastWeatherViewController") as? ForecastWeatherViewController


              self.navigationController?.pushViewController(viewController!, animated: true)
            
            Helper().showActivityIndicatorWithTitle(controller:self)
          }
        
        
    }
    
    


}


extension DashboardViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        arrayWeatherData.removeAll()
        if  let searchText = searchBar.text
        {
            cityNameArr = searchText.components(separatedBy: ",")
            if let array = cityNameArr ,  array.count >= 3
            {
                Helper().showActivityIndicatorWithTitle(controller:self)
                CurrentNetworkManager.sharedInstance.callApi(cityArray:array)
                DispatchQueue.main.async {
                    self.searchbar.endEditing(true)
                    
                }
               
            }
            else
            {
                Helper().showAlertWithTitle(msg: "Please enter more than 3 cities separated by comma(,) to continue", controller: self)

            }
        }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
         DispatchQueue.main.async {
            self.searchbar.endEditing(true)
        }
    }
    
}





