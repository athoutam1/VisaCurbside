//
//  ReplaceItemView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 7/1/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire

struct ReplaceItemView: View {
    
    @EnvironmentObject var dataStore: DataStore
    
    @Binding var order: Order
    @Binding var orderItems: [Item]
    @Binding var itemToReplace: Item?
    
    @Binding var showSheet: Bool
    @State var search = ""
    
    var body: some View {
        ScrollView {
            TextField("Search", text: $search)
            .font(.system(size: 25))
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .padding(.top, 27)
            
            VStack(spacing: 20) {
                ForEach(self.dataStore.items.filter({ (item) -> Bool in
                    item.name.lowercased().hasPrefix(search.lowercased())
                }), id: \.self) { itemToAdd in
                    ItemCard(item: itemToAdd, editable: false, showSheet: .constant(false), editingItem: .constant(nil), awaitingPayment: .constant(false))
                    .onTapGesture {
                        var url = "\(self.dataStore.proxy)/merchantApp/removeItemFromOrder"
                        var parameters: Parameters = [
                            "orderID": self.order.id,
                            "itemID": self.itemToReplace!.id!
                        ]
                        
                        AF.request(url, method: .post, parameters: parameters).response { response in
                            switch response.result {
                            case .success(_):
                                print("deleted")
                                self.orderItems = self.orderItems.filter() {
                                    $0 != self.itemToReplace!
                                }
                            case .failure(let err):
                                print(err)
                            }
                        }
                        
                        url = "\(self.dataStore.proxy)/merchantApp/addItemToOrder"
                        parameters = [
                            "orderID": self.order.id,
                            "itemID": itemToAdd.id!,
                            "shopperID": self.order.shopperID
                        ]
                        
                        AF.request(url, method: .post, parameters: parameters).response { response in
                            switch response.result {
                            case .success(_):
                                print("ADded new item")
                                self.orderItems.append(itemToAdd)
                                self.showSheet = false
                            case .failure(let err):
                                print(err)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}
