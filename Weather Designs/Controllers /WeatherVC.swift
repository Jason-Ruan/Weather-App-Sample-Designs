//
//  ViewController.swift
//  Weather Designs
//
//  Created by Jason Ruan on 3/10/20.
//  Copyright © 2020 Jason Ruan. All rights reserved.
//

import UIKit

fileprivate enum ForecastType {
    case daily
    case hourly
}

class WeatherVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UI Objects
    lazy var weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2), collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(WeatherCell.self, forCellWithReuseIdentifier: "weatherCell")
        
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    
    //MARK: - Private Properties
    private var forecastDetails: WeatherForecast? {
        didSet {
            weatherCollectionView.reloadData()
        }
    }
    
    private var selectedForecast: ForecastType? {
        didSet {
            weatherCollectionView.reloadData()
        }
    }
    
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        selectedForecast = .daily
        setUpViews()
        loadWeather()
    }
    
    
    //MARK: Private Functions
    private func setUpViews() {
        view.addSubview(weatherCollectionView)
        
        weatherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            weatherCollectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            weatherCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
    }
    
    private func loadWeather() {
        DarkSkyAPIClient.manager.fetchWeatherForecast(lat: 40.742054, long: -73.769417) { (result) in
            switch result {
            case .success(let weatherForecast):
                self.forecastDetails = weatherForecast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedForecast {
        case .daily:
            return forecastDetails?.daily?.data?.count ?? 0
        case .hourly:
            return forecastDetails?.hourly?.data?.count ?? 0
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCell else { return WeatherCell() }
        let dayForecast = forecastDetails?.daily?.data?[indexPath.row]
        cell.dateLabel.text = convertTimeToDate(time: dayForecast?.time ?? 0)
        cell.weatherIconImageView.image = UIImage(systemName: "cloud")
        cell.lowTemperature.text = """
        Low
        \(dayForecast?.temperatureLow?.description ?? "N/A")\u{00B0}
        """
        
        cell.highTemperature.text = """
        High
        \(dayForecast?.temperatureLow?.description  ?? "N/A")\u{00B0}
        """
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let time = forecastDetails?.daily?.data?[indexPath.row].time else { return }
        print(convertTimeToDate(time: time))
    }
    
    func convertTimeToDate(time: Int) -> String {
        let dateInput = Date(timeIntervalSinceNow: TimeInterval(exactly: time) ?? 0)
        let formatter = DateFormatter()
        formatter.dateFormat = "E M/d"
        formatter.locale = .current
        return formatter.string(from: dateInput)
    }
    
    
}

