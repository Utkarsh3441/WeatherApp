//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/14/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblWeatherDescription: UILabel!
    
    @IBOutlet weak var lblWindSpeed: UILabel!
    
    @IBOutlet weak var lblTempMax: UILabel!
    
    @IBOutlet weak var lblTempMin: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(model:WeatherDataModel)
       {
        DispatchQueue.main.async {
            
            self.lblHeader.text = model.cityName
            self.lblWeatherDescription.text = model.weatherDescription
            self.lblWindSpeed.text = "Wind Speed: \(model.windSpeed ?? "")"
            self.lblTempMax.text =   "Max: \(model.tempMax ?? "")"
            self.lblTempMin.text = "Min: \(model.tempMin ?? "")"
            
        }

    }
    
    func setupCellForForecast(model:WeatherDataModel)
    {
        DispatchQueue.main.async {
                   
                   self.lblHeader.text = model.date
                   self.lblWeatherDescription.text = model.weatherDescription
                   self.lblWindSpeed.text = "Wind Speed: \(model.windSpeed ?? "")"
                   self.lblTempMax.text =   "Max: \(model.tempMax ?? "")"
                   self.lblTempMin.text = "Min: \(model.tempMin ?? "")"
                   
               }
    }
    


}
