//
//  DateHelper.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 04/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import Foundation

class DateHelper {
    static func getDateWithWeekday(dateTime: TimeInterval) -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: dateTime)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        formatter.locale = Locale(identifier: "pl_PL")
        
        return formatter.string(from: date) + " " + getDayOfWeek(day: weekDay)
    }
    
    static func getDayOfWeek(day: Int) -> String {
        switch day {
            case 1:
                return "Monday"
            case 2:
                return "Thusday"
            case 3:
                return "Wednesday"
            case 4:
                return "Thursday"
            case 5:
                return "Friday"
            case 6:
                return "Saturday"
            case 7:
                return "Sunday"
            default:
                return ""
        }
    }
    
    static func getDate(dateTime: TimeInterval) -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: dateTime)

        formatter.dateFormat = "dd.MM HH:mm:ss"
        formatter.locale = Locale(identifier: "pl_PL")
        
        return formatter.string(from: date)
    }
}
