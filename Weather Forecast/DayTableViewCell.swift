//
//  DayTableViewCell.swift
//  Weather Forecast
//
//  Created by Никита on 12/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    static let identifier = "cell"
    
    
    var model: DailyResponse?{
        didSet{
            guard
                let datetime = model?.datetime,
                let minTemperature = model?.temp?.min,
                let maxTemperature = model?.temp?.max,
                let imageName = model?.weather?.first?.main else{
                return
            }
            
            DispatchQueue.main.async {
                self.currentWeatherImageView.image = self.weatherImage(name: imageName)
                self.dayWeekLabel.text = self.dayWeek(datetime: TimeInterval(datetime))
                self.minTemperatureLabel.text = "\(Int(minTemperature)) °"
                self.maxTemperatureLabel.text = "\(Int(maxTemperature)) °"
                let progressValue = minTemperature / maxTemperature
                self.progressView.progress = Float(progressValue)
            }
        }
    }
    
    @IBOutlet weak var dayWeekLabel: UILabel!{
        didSet{
            dayWeekLabel.text = "".uppercased()
        }
    }
    @IBOutlet weak var minTemperatureLabel: UILabel!{
        didSet{
            minTemperatureLabel.text = ""
        }
    }
    @IBOutlet weak var maxTemperatureLabel: UILabel!{
        didSet{
            maxTemperatureLabel.text = ""
        }
    

    
    
    }
    
    
    @IBOutlet weak var clipsView: UIView!{
        didSet{
            clipsView.layer.cornerRadius = 6
            clipsView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentWeatherImageView: UIImageView!{
        didSet{
            currentWeatherImageView.image = nil
        }
    }
    


    private func dayWeek(datetime: TimeInterval) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let symbols = dateFormatter.shortWeekdaySymbols
        
        let date = Date(timeIntervalSince1970: datetime)
        
        let currentWeekDay = Calendar.current.component(.weekday, from: date) - 1
        let currentSymbol = symbols?[currentWeekDay] ?? "Undefined"
        return currentSymbol.uppercased()
    }


    private func weatherImage(name: String) -> UIImage?{
        return UIImage(named: name)
    }
}

