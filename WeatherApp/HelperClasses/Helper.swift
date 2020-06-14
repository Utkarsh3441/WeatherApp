//
//  Helper.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/14/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit

let urlString = "https://api.openweathermap.org/data/2.5/"


class Helper: NSObject {
    
    
    func showAlertWithTitle(msg:String,controller:UIViewController)
       {
           let alert = UIAlertController(title: "Message", message: msg, preferredStyle: UIAlertController.Style.alert)
           
           // add an action (button)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           
           // show the alert
           controller.present(alert, animated: true, completion: nil)
       }
    
    func showActivityIndicatorWithTitle(controller:UIViewController)
    {
        let alert = UIAlertController(title: nil, message: "Fetching Data...", preferredStyle: .alert)

           let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
           loadingIndicator.hidesWhenStopped = true
          loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
           loadingIndicator.startAnimating();

           alert.view.addSubview(loadingIndicator)
           controller.present(alert, animated: true, completion: nil)
    }
    
   
    
    
    
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

public extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}


extension UIColor
{

    class var themeColor: UIColor {
        get {
            
           return UIColor(red: 23.0/255.0, green: 117.0/255.0, blue: 169.0/255.0, alpha: 1.0)
            
        }
    }
    
    
}

extension String
{
    
    func dateWith(format: String, isGMT: Bool = false) -> Date? {
        

        let formatter: DateFormatter = DateFormatter()
        if(isGMT)
        {
            formatter.timeZone = TimeZone(identifier:"GMT")
        }
        formatter.locale = Locale(identifier: "EN")
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    
    /// Checkes if String value is nonEmpty and non nil
    ///
    /// - Parameter string: Optional String
    /// - Returns: if string is empty
    static func isEmptyString(string: String?) -> Bool {
        guard let str = string else {
            return true
        }
        return str.isEmpty
    }
    
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Date {
    
    var shortDateTime: String  { localizedDescription(dateStyle: .short,  timeStyle: .short) }
    
    
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                               timeStyle: DateFormatter.Style = .medium,
                            in timeZone : TimeZone = .current,
                               locale   : Locale = .current) -> String {
         Formatter.date.locale = locale
         Formatter.date.timeZone = timeZone
         Formatter.date.dateStyle = dateStyle
         Formatter.date.timeStyle = timeStyle
         return Formatter.date.string(from: self)
     }


}

extension Formatter {
    static let date = DateFormatter()
}
