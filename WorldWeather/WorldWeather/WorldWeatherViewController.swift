//
//  ViewController.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 08/03/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit

/*
 Localization Steps:
 1. Click on the Project in the left top bar
 2. Select the project from the Project in the main screen
 3. In the Localizations section Click on + button to add your localized language
 4. Create a local folder and call it Localizable
 5. Add a new Strings file and call it Localizable too
 6. Add a key value pair in the file like following "hello_world" = "Hello World"; // remember to terminate string by semi colon
 7. Click on the Localizable.string file and in the right menu (identity inspector) you will see a Localization section
 8. Click on the Localize button in the Localization section
 9. In the Pop up click on Localize
 10. In the identity inspector check for all the languages you want to localize
 11. Create a file called Utilities
 12. Add a Swift file called LocalizationUtil.swift
 13. Add a variable for the string you want to localize and localize it with the Key added in the strings file as follows
 14. var strHelloWorld = NSLocalizedString("hello_world", comment: "")
 15. Replace Corresponding text in the language files with localized text
 16. Add a function which will initialize the text for all the UI Elements
 17. Call the initialize text from the viewDidLoad()
 
 */

class WorldWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblcurrentWeatherIcon: UIImageView!
    @IBOutlet weak var lblMaximum: UILabel!
    @IBOutlet weak var lblMinimum: UILabel!
    @IBOutlet weak var lblMaximumIcon: UIImageView!
    @IBOutlet weak var lblMinimumIcon: UIImageView!
    
    
    
    let locationManager = CLLocationManager()
    
    // We need to have a class of View Model
    let viewModel = WorldWeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeText()
        tblView.delegate = self
        tblView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func initializeText(){
        self.title = strWorldWeather
        lblCity.text = strCity
        lblCondition.text = strCondition
        lblTemperature.text = strTemperature
        lblMaximum.text = strHighLow
        lblMinimum.text = "d"
    }
    
    var forecasts : [ModelForecast] = [ModelForecast]()
    @IBOutlet weak var tblView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.forecasts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("fiveDaysForecastsTableViewCell", owner: self, options: nil)?.first as! fiveDaysForecastsTableViewCell

        cell.lblDate.text = self.forecasts[indexPath.row].weekday
        cell.lblMaximumTemperature.text = String("\(self.forecasts[indexPath.row].maximumTemperature)°")
        cell.maximumTemperatureIcon.image = UIImage(named: "\(self.forecasts[indexPath.row].dayIcon)-s")
        cell.lblMinimumTemperature.text = String("\(self.forecasts[indexPath.row].minimumTemperature)°")
        cell.minimumTemperatureIcon.image = UIImage(named: "\(self.forecasts[indexPath.row].nightIcon)-s")
        return cell
    }
    
    
    //MARK: Location Manager functions
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currLocation = locations.last{
            
            let lat = currLocation.coordinate.latitude
            let lng = currLocation.coordinate.longitude
            
            updateWeatherData(lat, lng)
        }
    }
    
    
    //MARK: Update the weather from ViewModel
    
    func updateWeatherData(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees){
        
        let cityDataURL = getLocationURL(lat, lng)
        
        viewModel.getCityData(cityDataURL).done { city in
            // Update City Name
            self.lblCity.text = city.cityName
            
            let key = city.cityKey
            
            let currentConditionURL = getCurrentConditionURL(key)
            let oneDayForecastsURL = getOneDayForecastsURL(key)
            let fiveDaysForecastsUrl = getFiveDaysForecastsUrl(key)
            // Update current conditions and temperature
            self.viewModel.getCurrentConditions(currentConditionURL).done { currCondition in
                self.lblCondition.text = currCondition.weatherText
                self.lblTemperature.text =  "\(currCondition.imperialTemp)°"
                self.lblcurrentWeatherIcon.image = UIImage(named: "\(currCondition.weatherIcon)-s")
            }.catch { error in
                print("Error in getting current conditions \(error.localizedDescription)")
            }
            // Update one day maximum and minimum temperature
            self.viewModel.getOneDayForecasts(oneDayForecastsURL).done { oneDay in
                self.lblMaximum.text = "H: \(oneDay.maximumTemperature)°"
                self.lblMaximumIcon.image = UIImage(named:"\(oneDay.dayIcon)-s")
                self.lblMinimum.text = "L: \(oneDay.minimumTemperature)°"
                self.lblMinimumIcon.image = UIImage(named:"\(oneDay.nightIcon)-s")
                
                
            }.catch { error in
                print("Error in getting one day forecast conditions \(error.localizedDescription)")
            }
            
            self.viewModel.getFiveDaysForecasts(fiveDaysForecastsUrl).done{ forecastsArray in
                    self.forecasts.removeAll()
                    for forecast in forecastsArray {
                        self.forecasts.append(forecast)
                    }
                    self.tblView.reloadData()
                }.catch { error in
                    print("Error in getting city's maximum and minimum temperature: \(error.localizedDescription)")
                }
        }
        .catch { error in
            print("Error in getting City Data \(error.localizedDescription)")
        }
    }
}

