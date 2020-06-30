//
//  Order.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Order: Identifiable, Codable, Hashable {
  var id: Int
  var shopperID: String
  var isPending: Bool
  var isReadyForPickup: Bool
  var time: String
  var shopperName: String
}

struct Message: Codable, Hashable {
    var message: String
    var messenger: String
    
//    init(snapshot: QueryDocumentSnapshot) {
//        let snapshotValue = snapshot.data()
//        message = (snapshotValue["message"] as? String)!
//        messenger = (snapshotValue["messenger"] as? String)!
//    }
    
    
}
