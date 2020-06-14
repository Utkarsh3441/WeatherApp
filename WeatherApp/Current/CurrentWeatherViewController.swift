//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Utkarsh Agarwal on 6/14/20.
//  Copyright © 2020 Utkarsh Agarwal. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: BaseViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    var arrayData:[WeatherDataModel]?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                      navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.title = "Current Weather"
        
        self.tblView.register(UINib(nibName: WeatherTableViewCell.className, bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.className)
        
         DispatchQueue.main.async {
          self.tblView.reloadData()
        }


        // Do any additional setup after loading the view.
    }
    
 


}

extension CurrentWeatherViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayData?.count ?? 0
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
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  self.tblView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.className) as? WeatherTableViewCell
        
        if let data = arrayData?[indexPath.section]
        {
            cell?.setUpCell(model: data)
        }
            
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
