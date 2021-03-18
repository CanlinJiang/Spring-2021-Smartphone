//
//  CityViewModel.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 10/03/21.
//

import Foundation
import PromiseKit


class WorldWeatherViewModel{
    
    func getCityData(_ url : String) -> Promise<ModelCity> {
        
        return Promise<ModelCity>{ seal ->Void in
            
            getAFResponseJSON(url).done { json in
                
                let key = json["Key"].stringValue
                let city = json["LocalizedName"].stringValue
                let cityModel: ModelCity = ModelCity(key, city)
                
                seal.fulfill(cityModel)
            }
            .catch { error in
                seal.reject(error)
            }
        }
    }
    
    func getCurrentConditions(_ url : String) -> Promise<ModelCurrentCondition>{
        return Promise<ModelCurrentCondition> { seal ->Void in
            
            getAFResponseJSONArray(url).done { currentWeatherJSON in
//                print(currentWeatherJSON)
                let weatherText = currentWeatherJSON[0]["WeatherText"].stringValue
                let weatherIcon = currentWeatherJSON[0]["WeatherIcon"].intValue
                let isDayTime = currentWeatherJSON[0]["IsDayTime"].boolValue
                let metricTemp = currentWeatherJSON[0]["Temperature"]["Metric"]["Value"].floatValue
                let imperialTemp = currentWeatherJSON[0]["Temperature"]["Imperial"]["Value"].intValue

                let currCondition = ModelCurrentCondition(weatherText, metricTemp, imperialTemp)
                currCondition.weatherIcon = weatherIcon
                currCondition.isDayTime  = isDayTime
                
                
                seal.fulfill(currCondition)
            
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getOneDayForecasts(_ url : String) -> Promise<ModelForecast>{
        return Promise<ModelForecast> { seal -> Void in
            
            getAFResponseJSON(url).done { forecast in
                
                let todayForecast = ModelForecast()
                todayForecast.headlineText = forecast["Headline"]["Text"].stringValue
                todayForecast.date = forecast["DailyForecasts"][0]["Date"].stringValue
                todayForecast.weekday = transferDateToWeek(todayForecast.date)
                todayForecast.minimumTemperature = forecast["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
                todayForecast.maximumTemperature = forecast["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue
                todayForecast.dayIcon = forecast["DailyForecasts"][0]["Day"]["Icon"].intValue
                todayForecast.nightIcon = forecast["DailyForecasts"][0]["Night"]["Icon"].intValue
                todayForecast.dayIconPhrase = forecast["DailyForecasts"][0]["Day"]["IconPhrase"].stringValue
                todayForecast.nightIconPhrase = forecast["DailyForecasts"][0]["Night"]["IconPhrase"].stringValue

                seal.fulfill(todayForecast)
            
            }
            .catch { error in
                seal.reject(error)
            }
            
        }
    }
    
    func getFiveDaysForecasts(_ url: String) -> Promise<[ModelForecast]> {
        return Promise<[ModelForecast]> {seal -> Void in
            getAFResponseJSON(url).done { responseJson in
                let forecastsData = responseJson["DailyForecasts"].array
                var forecasts: [ModelForecast] = [ModelForecast]()
                for eachData in forecastsData! {
                    var forecast: ModelForecast = ModelForecast()
                    forecast.date = eachData["Date"].stringValue
                    forecast.weekday = transferDateToWeek(forecast.date)
                    forecast.minimumTemperature = eachData["Temperature"]["Minimum"]["Value"].intValue
                    forecast.maximumTemperature = eachData["Temperature"]["Maximum"]["Value"].intValue
                    forecast.dayIcon = eachData["Day"]["Icon"].intValue
                    forecast.nightIcon = eachData["Night"]["Icon"].intValue
                    forecast.dayIconPhrase = eachData["Day"]["IconPhrase"].stringValue
                    forecast.nightIconPhrase = eachData["Night"]["IconPhrase"].stringValue
                    forecasts.append(forecast)
                }
                seal.fulfill(forecasts)
            }
        }
    }
    
    
}
