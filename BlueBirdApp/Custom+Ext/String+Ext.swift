//
//  String+Ext.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 13/03/21.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "dd/MM/yyyy hh:mm")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}
