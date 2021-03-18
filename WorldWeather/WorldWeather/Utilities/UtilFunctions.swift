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

func transferDateToWeek(_ rawDate: String) -> String {
    let start = rawDate.index(rawDate.startIndex, offsetBy: 0)
    let end = rawDate.index(rawDate.endIndex, offsetBy: -16)
    let date = String(rawDate[start...end])

    let weekdays = [
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday"
            ]
    let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    if let todayDate = formatter.date(from: date) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        guard let weekDay = myComponents.weekday else { return "" }
            return weekdays[weekDay - 1]
        } else {
            return ""
        }
}
