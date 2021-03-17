//
//  UtilFunctions.swift
//  WorldWeather
//
//  Created by Ashish Ashish on 10/03/21.
//

import Foundation
import CoreLocation

func getLocationURL(_ lat : CLLocationDegrees, _ lng : CLLocationDegrees) -> String{
    var url = locationURL
    url.append("?apikey=\(apiKey)")
    url.append("&q=\(lat),\(lng)")
    return url
}

func getCurrentConditionURL(_ cityKey : String) -> String{
    var url = currentConditionURL
    url.append(cityKey)
    url.append("?apikey=\(apiKey)")
    return url
}

func getOneDayForecastsURL(_ cityKey : String) -> String {
    var url = oneDayURL
    url.append(cityKey)
    url.append("?apikey=\(apiKey)")
    return url
}

func getFiveDaysForecastsUrl(_ key: String) -> String {
    var url = fiveDaysForecastsReferer
    url.append(key)
    url.append("?apikey=\(apiKey)")
    return url
}
