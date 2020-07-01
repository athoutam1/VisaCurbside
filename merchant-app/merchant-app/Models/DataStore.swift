//
//  DataStore.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/28/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire
import Firebase


class DataStore: ObservableObject {

    @Published var isLoggedIn = false
    @Published var storeID = 1
    
    @Published var items: [Item] = []
    @Published var store: Store?
    @Published var orders: [Order] = []
    
    @Published var proxy = "https://33f9240848dd.ngrok.io"
    
    // Google maps API Key AIzaSyC1bpFx82bEj8dzGExzq9d253vz1CkQTfw
    
    @Published var db = Firestore.firestore()

}
