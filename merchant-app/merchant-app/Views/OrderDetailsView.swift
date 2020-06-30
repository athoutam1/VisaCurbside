//
//  OrderDetailsView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire

struct OrderDetailsView: View {
    
    @EnvironmentObject var dataStore: DataStore
    
    @State var order: Order
    @State var orderItems: [Item] = []
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .padding(12)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                Spacer()
                VStack(alignment: .leading) {
                    Text(self.order.shopperName)
                        .font(.system(size: 20))
                        .bold()
                    Text("\(convertToDate(oldDate: self.order.time)?.localizedDescription ?? "")")
                    if self.order.isPending && !self.order.isReadyForPickup {
                        Text("\(self.order.shopperName) is waiting for you to approve their order")
                            .foregroundColor(.gray)
                    } else if !self.order.isPending && self.order.isReadyForPickup {
                        Text("\(self.order.shopperName) will let you know when they've arrived")
                        .foregroundColor(.gray)
                    }
                }
                
            }
            .padding()
            
            Divider()
            .padding(.horizontal)
            
            HStack {
                Text("Items")
                .font(.title)
                Spacer()
                
                NavigationLink(destination: ChatView(chatID: "\(self.order.shopperID)AND\(self.dataStore.storeID)", order: self.order).environmentObject(dataStore)) {
                    HStack {
                        Text("Chat Now")
                        Image(systemName: "message")
                    }
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(self.orderItems) { item in
                    ItemRow(item: item)
                }
                
                Button(action: {
                    //
                }) {
                    Text("Add New Item")
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                }
                .background(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .foregroundColor(.green)
                )
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                Button(action: {
                    //
                }) {
                    Text("Accept Order")
                    .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                }
                .background(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .foregroundColor(.blue)
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
        }
        
        .navigationBarTitle("Order Details", displayMode: .large)
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
