//
//  CitiesList.swift
//  DarioHealthDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import Foundation

enum CitiesList: CaseIterable {
    case london
    case telAviv
    case newYork
    case brussels
    case barcelona
    case paris
    case tokyo
    case beijing
    case sydney
    case buenosAires
    case miami
    case vancouver
    case kyiv
    case bangkok
    case johannesburg
    case tunis
    case manila
}

extension CitiesList {
    
    var name: String {
        switch self {
            
        case .london:
            return "London"
        case .telAviv:
            return "Tel Aviv"
        case .newYork:
            return "New York"
        case .brussels:
            return "Brussels"
        case .barcelona:
            return "Barcelona"
        case .paris:
            return  "Paris"
        case .tokyo:
            return "Tokyo"
        case .beijing:
            return "Beijing"
        case .sydney:
            return  "Sydney"
        case .buenosAires:
            return "Buenos Aires"
        case .miami:
            return "Miami"
        case .vancouver:
            return "Vancouver"
        case .kyiv:
            return "Kyiv"
        case .bangkok:
            return "Bangkok"
        case .johannesburg:
            return "Johannesburg"
        case .tunis:
            return "Tunis"
        case .manila:
            return "Manila"
        }
    }
}
