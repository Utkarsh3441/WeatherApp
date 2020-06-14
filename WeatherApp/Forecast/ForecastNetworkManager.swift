//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/13/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit



protocol ForecastResponseProtocol: class {
    
    func forecastModelDataForCity(arrWeatherData:[WeatherDataModel])

    
}



class ForecastNetworkManager : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    static var sharedInstance = ForecastNetworkManager()
    weak var delegate: ForecastResponseProtocol?



        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                  print(String(data: data, encoding: String.Encoding.utf8)!)
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:AnyObject]
                {
                     print(jsonArray) // use the json here
                    self.parseForecastDataInModel(jsonArray:jsonArray)
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
            
        }
    
    

    
    func parseForecastDataInModel(jsonArray:[String:AnyObject])
    {
        
        var arrWeatherData = [WeatherDataModel]()
   
        if let tempArray = jsonArray["list"] as? Array<Dictionary<String,Any>>
        {
            for obj in tempArray
            {
                 var weatherObj = WeatherDataModel()
                
                if let weather = obj["weather"] as? Array<Dictionary<String,Any>>, weather.count > 0 , let weatherDesc = weather[0]["description"] as? String
               {
                
                    weatherObj.weatherDescription = weatherDesc
              }
                
                
                if let tempData = obj["main"] as? Dictionary<String,Any>
                {
                   if let  tempMin = tempData["temp_min"] as? String
                   {
                    weatherObj.tempMin = tempMin
                    }
                    
                }
                
              if let tempData = obj["main"] as? Dictionary<String,Any>, let  tempMin = tempData["temp_min"] as? Double, let  tempMax = tempData["temp_min"] as? Double
                {
                    weatherObj.tempMin = String(format: "%.2f", tempMin)
                    weatherObj.tempMax = String(format: "%.2f", tempMax)
                    
                }
                
               if let wind = obj["wind"] as? Dictionary<String,Any> , let  windSpeed = wind["speed"] as? Double
                    {
                        weatherObj.windSpeed = String(format: "%.2f", windSpeed)
                        
                    }
                
                if let timeStamp = obj["dt_txt"] as? String
                {
                   
                  if  let date = timeStamp.dateWith(format: "YYYY-MM-dd HH:mm:ss")
                  {
                
                    weatherObj.date = date.shortDateTime

                    }
                
                }
                if let timeStamp = obj["dt"] as? String
                {
                    weatherObj.timeStamp = timeStamp
                }
                
                 arrWeatherData.append(weatherObj)
            }
    }
        
        delegate?.forecastModelDataForCity(arrWeatherData: arrWeatherData)

        
    }
    
       
    func scheduleURLSessionForecastWeatherData(cityName:String) {
            
            let subString = "forecast?&q=\(cityName)&appid=fac8962ae5ca268bb9efbbfa262103b8"
            let identifier = "myIdentifier." + cityName

            
                   let backgroundConfigObject = URLSessionConfiguration.background(withIdentifier: identifier)
                   let backgroundSession = URLSession(configuration: backgroundConfigObject, delegate: self, delegateQueue: nil)
                   let retrieveTask = backgroundSession.dataTask(with: URL(string: urlString + subString)!)
                   retrieveTask.resume()
        }
    

    
    }


