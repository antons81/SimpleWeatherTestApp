//
//  String+Extension.swift
//  DarioHealthDeemo
//
//  Created by Anton Stremovskiy on 06.07.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    func stringToDate(with format: String? = nil) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self) ?? Date()
    }
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    
    var toDouble: Double {
        return Double(self) ?? 0
    }
    
    var toInt64: Int64 {
        return Int64(self) ?? 0
    }
    
    var toDecimal: Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let number = formatter.number(from: self)
        return number?.doubleValue ?? 0
    }
}
