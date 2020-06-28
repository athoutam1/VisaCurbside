//
//  DataStore.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/28/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire

class DataStore: ObservableObject {

    @Published var isLoggedIn = false
    @Published var storeID = 1
    @Published var items: [Item] = []
    
    @Published var proxy = "https://b7d42b2bc448.ngrok.io"

}
