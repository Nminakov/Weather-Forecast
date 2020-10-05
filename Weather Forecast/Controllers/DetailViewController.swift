//
//  DetailViewController.swift
//  Weather Forecast
//
//  Created by Никита on 12/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var cloudsValueLabel: UILabel!
    @IBOutlet weak var feelsLikeValueLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: DailyResponse?
    
    var modelsHours: [HourlyResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            guard
                let model = model else {
                    return
            }
            
            setData(model: model)
        if modelsHours.isEmpty{
            collectionView.isHidden = true
        }
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        sender.animateTap {
            self.navigationController?
                .popViewController(animated: true)
        }
        
    }
    
}
    
extension DetailViewController{
    private func setData(model: DailyResponse){
        LocationLabel.text = "Москва"
        if let dayTemperature = model.temp?.day{
            temperatureLabel.text = "\(Int(dayTemperature)) °"
        }
        if let weatherName = model.weather?.first?.main{
            weatherIconImageView.image = UIImage(named: weatherName)
        }
        
        if let weatherDescription = model.weather?.first?.description{
            weatherDescriptionLabel.text = weatherDescription.capitalizingFirstLetter()
        }
        
        let cloudValue = model.clouds
        cloudsValueLabel.text = "\(cloudValue) %"
        
        
        if let feelsLike = model.feelsLike?.day{
            feelsLikeValueLabel.text = "\(Int(feelsLike)) %"
        }
        
        let windSpeedValue = model.windSpeed
        windSpeedValueLabel.text = "\(windSpeedValue) м/с"
        
        let humidityValue = model.humidity
        humidityValueLabel.text = "\(humidityValue) %"
    }
}

extension DetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelsHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCollectionViewCell.identifier, for: indexPath) as! HourCollectionViewCell
        
        let hourModel = modelsHours[indexPath.item]
        cell.timeLabel.text = hourModel.formattedTime
        cell.temperatureLabel.text = "\(Int(hourModel.temp)) °"
        cell.iconImageView.image = UIImage(named: hourModel.weather.first?.main ?? "")
        return cell
    }
    
}
extension DetailViewController: UICollectionViewDelegate {
    
}

