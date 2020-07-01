//
//  PastOrderView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/30/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire

struct PastOrderView: View {
    @EnvironmentObject var dataStore: DataStore
    @State var order: Order
    @State var orderItems: [Item] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(self.orderItems) { item in
                    ItemRow(item: item)
                }
            }
        }
        .navigationBarTitle("Order #\(self.order.id)")
        .onAppear {
            let url = "\(self.dataStore.proxy)/merchantApp/getOrderItems"
            let parameters: Parameters = [
                "orderID": self.order.id
            ]
            
            AF.request(url, method: .get, parameters: parameters).responseDecodable(of: [Item].self){ response in
                switch response.result {
                case .success(let response):
                    self.orderItems = response
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
