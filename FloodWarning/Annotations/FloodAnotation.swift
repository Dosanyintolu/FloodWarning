//
//  FloodAnotation.swift
//  FloodWarning
//
//  Created by Doyinsola Osanyintolu on 10/20/20.
//

import Foundation
import MapKit
import UIKit


class FloodAnnotation: MKPointAnnotation {
    
    let flood: Flood
    
    init(_ flood: Flood) {
        self.flood = flood
    }
}
