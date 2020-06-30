//
//  Store.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI

struct Store: Codable, Hashable {
    var description: String
    var imageURL: String
    var location: String
    var merchantID: String?
    var merchantName: String?
    var storeID: Int
    var storeName: String
}
