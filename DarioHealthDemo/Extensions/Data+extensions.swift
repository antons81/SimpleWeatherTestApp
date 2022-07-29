//
//  Data+extensions.swift
//  DarioHealthDeemo
//
//  Created by Anton Stremovskiy on 28.09.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Data {
    
    var html2AttributedString: NSAttributedString? {
        do {
            let attrString = try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                          .characterEncoding: String.Encoding.utf8.rawValue],
                                                                            documentAttributes: nil)
            
            let mutableStr: NSMutableAttributedString = NSMutableAttributedString(attributedString: attrString)
            mutableStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, attrString.length))
            return mutableStr
        } catch {
            #if DEBUG
            print("error: \(error)")
            #endif
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
