//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/14/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController:UIViewController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setBackgroundGradient()
        
        self.setGradientBackground(colorTop: UIColor(red: 23/255, green: 117/255, blue: 169/255, alpha: 1.0)  , colorBottom: UIColor(red: 39/255, green: 207/255, blue: 218/255, alpha: 1.0))
        
        
        self.navigationItem.leftBarButtonItem = self.navBarButtonForController()
    }
    
     func navBarButtonForController(imageSize: CGFloat = 20,buttonSize: CGFloat = 24, imageColor: UIColor = UIColor.white)-> UIBarButtonItem{
        
        var button: UIButton!
        button = UIButton(frame : CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        button.setBackgroundImage( UIImage(named: "ic_back"), for: .normal)
        button.addTarget(self, action: #selector(backBarBtnPressed(sender:)), for: UIControl.Event.touchUpInside)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: button)
        return barButton
    }
    
    @objc func backBarBtnPressed(sender: Any?){
        
     
        let _ = navigationController?.popViewController(animated: false)
        
       
    }
    

    
    
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.view.bounds
        
        //layer.insertSublayer(gradientLayer, at: 0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    
    
}


