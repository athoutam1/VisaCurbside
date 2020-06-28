//
//  Splash.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/28/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire

struct Splash: View {
    
    @State var storeID = 1
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        VStack {
            if self.dataStore.isLoggedIn {
                ItemList().environmentObject(dataStore)
            } else {
                Text("Loading ...")
            }
        }
        .onAppear {
            let url = "\(self.dataStore.proxy)/merchantApp/getItemsForStore"
            let parameters: Parameters = [
                "storeID": self.dataStore.storeID
            ]
            
            AF.request(url, method: .post, parameters: parameters).responseDecodable(of: [Item].self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                    self.dataStore.items = response
                    self.dataStore.isLoggedIn = true
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
