//
//  Double+extensions.swift
//  DarioHealthDeemo
//
//  Created by Anton Stremovskiy on 23.11.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import Foundation

extension Double {
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    var format2Decimals: String {
        return String(format: "%.02f", self)
    }
    
    var format2DecimalsInch: String {
        return String(format: "%.02f˝", self)
    }
    
    var format2DecimalsCm: String {
        return String(format: "%.02f cm", self)
    }
    
    var formatToInt: Int {
        return Int(self)
    }
}

extension Double {
    
    var toFahrenheit: Double {
        return ((self - 273.15) * 1.8) + 32
    }
    
    var toFahrenheitString: String {
        return (((self - 273.15) * 1.8) + 32).formatToInt.toString + "℉"
    }
    
    var toCelsius: Double {
        return self - 273.15
    }
    
    var toCelsiusString: String {
        return (self - 273.15).formatToInt.toString + "℃"
    }
}
