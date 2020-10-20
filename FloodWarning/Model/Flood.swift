//
//  Flood.swift
//  FloodWarning
//
//  Created by Doyinsola Osanyintolu on 10/18/20.
//

import Foundation
import Firebase

struct Flood {
    var documentID: String?
    let latitude: Double
    let longitude: Double
    var reportedDate: Date = Date()
}

extension Flood {
    
    init?(_ snapshot: QueryDocumentSnapshot) {
        guard let latitude = snapshot["latitude"] as? Double,
              let longitude = snapshot["longitude"] as? Double else {
            return nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    func toDictionary() -> [String:Any] {
        return [
            "latitude": self.latitude,
            "longitude": self.longitude,
            "reportedDate": self.reportedDate.convertDateToString()
        ]
    }
}
