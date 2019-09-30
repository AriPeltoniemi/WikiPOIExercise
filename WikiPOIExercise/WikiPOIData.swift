//
//  WikiPOIData.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 30.9.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import Foundation
import SwiftUI



struct WikiPOI: Decodable {
    let pageid: String
    let title: String
    let lat: Double
    let lon: Double
}


