//
//  Date+Extension.swift
//  DarioHealthDeemo
//
//  Created by Anton Stremovskiy on 06.07.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import Foundation

extension Date {
    static func today() -> Date {
        return Date()
    }
}

extension Date {
    func dateToString(with format: String?, _ timezone: String? = "UTC") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "dd MMMM YYYY 'в' HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    func dateToTimeInterval() -> Double {
        return self.timeIntervalSince1970
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
