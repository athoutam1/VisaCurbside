//
//  Item.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/27/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import Foundation

struct Item: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String = ""
    var description: String = ""
    var price: Double = 0.0
    var imageURL: String = ""
}
