//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/13/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit



protocol CurrentResponseProtocol: class {
    
    func dailyModelDataForCity(weatherData:WeatherDataModel)

    
}


class CurrentNetworkManager : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    static var sharedInstance = CurrentNetworkManager()
    weak var delegate: CurrentResponseProtocol?
    

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                  print(String(data: data, encoding: String.Encoding.utf8)!)
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:AnyObject]
                {
                     print(jsonArray) // use the json here
                    self.parseCurrentDataInModel(jsonArray:jsonArray)
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
            
        }
    
    
    func parseCurrentDataInModel(jsonArray:[String:AnyObject])
    {
         var weatherObj = WeatherDataModel()
        
        if let tempDict = jsonArray["wind"] as? Dictionary<String,Any> , let windSpeed = tempDict["speed"] as? Double
        {
          weatherObj.windSpeed =  String(format: "%.2f", windSpeed)
        }
        
        if let tempDict = jsonArray["main"] as? Dictionary<String,Any> , let tempMin = tempDict["temp_min"] as? Double, let tempMax = tempDict["temp_max"] as? Double
               {
                 weatherObj.tempMax = String(format: "%.2f", tempMin)
                 weatherObj.tempMin = String(format: "%.2f", tempMax)
                
        }
        if let tempArray = jsonArray["weather"] as? Array<Dictionary<String,Any>> ,tempArray.count > 0 , let desc = tempArray[0]["description"] as? String
            {
                   
                    weatherObj.weatherDescription = desc
                      
              }
        
            weatherObj.cityName =  jsonArray["name"] as? String
        
        
        delegate?.dailyModelDataForCity(weatherData: weatherObj)
        

        
    }
    
    
    
    func scheduleURLSessionCurrentWeatherData(cityName:String) {
           
           let subString = "weather?&q=\(cityName)&appid=fac8962ae5ca268bb9efbbfa262103b8"
           let identifier = "myIdentifier." + cityName
           
                  let backgroundConfigObject = URLSessionConfiguration.background(withIdentifier: identifier)
                  let backgroundSession = URLSession(configuration: backgroundConfigObject, delegate: self, delegateQueue: nil)
                  let retrieveTask = backgroundSession.dataTask(with: URL(string: urlString + subString)!)
                  retrieveTask.resume()
          }
    

     
    func callApi(cityArray:[String])
     {
       
         for city in cityArray
         {
             self.scheduleURLSessionCurrentWeatherData(cityName:city)
         }
         
     }
    
    }


