//
//  MainViewController.swift
//  Weather Forecast
//
//  Created by Никита on 12/09/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let api = API()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nextForecastButton: UIButton!
    
    @IBOutlet weak var dayForecastView: UIView!
    

    @IBOutlet weak var dayWeekLabel: UILabel!{
        didSet{
            dayWeekLabel.text = ""
        }
    }
    @IBOutlet weak var weatherStateImageView: UIImageView!{
        didSet{
            weatherStateImageView.image = nil
        }
    }
    
    @IBOutlet weak var maxTemperatureLabel: UILabel!{
        didSet{
            maxTemperatureLabel.text = ""
        }
    }
    @IBOutlet weak var minTemperatureLabel: UILabel!{
        didSet{
            minTemperatureLabel.text = ""
        }
    }
    @IBOutlet weak var windLabel: UILabel!{
        didSet{
            windLabel.text = ""
        }
    }
    @IBOutlet weak var windValueLabel: UILabel!{
        didSet{
            windValueLabel.text = ""
        }
    }
    
    @IBOutlet weak var visibilityLabel: UILabel!{
        didSet{
            visibilityLabel.text = ""
        }
    }
    @IBOutlet weak var visibilityValueLabel: UILabel!{
        didSet{
            visibilityValueLabel.text = ""
        }
    }
    @IBOutlet weak var humidityLabel: UILabel!{
        didSet{
            humidityLabel.text = ""
        }
    }
    @IBOutlet weak var humidityValueLabel: UILabel!{
        didSet{
            humidityValueLabel.text = ""
        }
    
    }
    @IBOutlet weak var uvLabel: UILabel!{
        didSet{
            uvLabel.text = ""
        }
    }
    @IBOutlet weak var uvValueLabel: UILabel!{
        didSet{
            uvValueLabel.text = ""
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    private var dailyWeather: [DailyResponse] = []
    private var hourlyWeather: [HourlyResponse] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayForecastView.backgroundColor = .white
        self.dayForecastView.layer.cornerRadius = 20
        
        self.dayForecastView.layer.shadowOffset = .zero
        self.dayForecastView.layer.shadowRadius = 10
        self.dayForecastView.layer.shadowOpacity = 0.1
        
        activityIndicator.startAnimating()
        
        api.fetchData { (result) in
            switch result{
            case.success(let model):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.setData(model: model)
                    self.dailyWeather = model.daily ?? []
                    self.tableView.reloadData()
                    }
                
                
            case.failure(let error):
                let message = " Describe: \(error.localizedDescription)"
                let alertController = UIAlertController(title: "Fail", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            if let cell = sender as? DayTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let model = dailyWeather[indexPath.row]
                destination.model = model
                
                if indexPath.row == 0 {
                    // is today
                    let todayArray = hourlyWeather.filter {
                        //                        return $0.isToday
                        $0.isToday
                    }
                    destination.modelsHours = todayArray
                }
                else if indexPath.row == 1 {
                    // is tomorrow
                    let tomorrowArray = hourlyWeather.filter { (item) -> Bool in
                        return item.isTmorrow
                    }
                    destination.modelsHours = tomorrowArray
                }
            }
        }
    }
    
    
    

    
    
    
    private func setData(model: Response){
        
        hourlyWeather = model.hourly ?? []
        windLabel.text = "Ветер:"
        visibilityLabel.text = "Видимость"
        humidityLabel.text = "Влажность"
        uvLabel.text = "УИ"
        
        if let minTemperature = model.daily?.first?.temp?.min{
            minTemperatureLabel.text = "\(Int(minTemperature)) °"
        }
        
        if let maxTemperature = model.daily?.first?.temp?.max{
            maxTemperatureLabel.text = "\(Int(maxTemperature)) °"
        }
        
        if let visibility = model.current?.visibility{
           let km = visibility / 1000
            visibilityValueLabel.text = "\(km) км"
        }
        
        if let humidity = model.current?.humidity{
            humidityValueLabel.text = "\(humidity) %"
        }
        
        if let windSpeed = model.current?.windSpeed{
            windValueLabel.text = "\(Int(windSpeed)) м/с"
        }
        
        if let uvLabel = model.current?.uvi{
            uvValueLabel.text = "\(uvLabel)"
        }
        let symbol = dayWeek()
        dayWeekLabel.text = symbol
        
        if let weatherName = model.current?.weather?.first?.main{
            weatherStateImageView.image = weatherImage(name:  weatherName)
        }
    
    
    }
    
    
    
    private func dayWeek() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let symbols = dateFormatter.shortWeekdaySymbols
        let currentWeekDay = Calendar.current.component(.weekday, from: Date()) - 1
        let currentSymbol = symbols?[currentWeekDay] ?? "Undefined"
        return currentSymbol.uppercased()
    }
    
    private func weatherImage(name: String) -> UIImage?{
        return UIImage(named: name)
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.identifier, for: indexPath) as! DayTableViewCell
        cell.model = dailyWeather[indexPath.row]
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
