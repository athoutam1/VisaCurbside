//
//  OrderDetailsView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI

struct OrderDetailsView: View {
    
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var order: Order
    @State var orderItems: [Item] = []
    @State var awaitingPayment: Bool
    
    @State private var showSheet = false
    @State private var showReplaceSearch = false
    @State var editingItem: Item?
    
    var body: some View {
        ScrollView {
        VStack {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 80))
                    .padding(15)
                    .background(Color(red: 239/255, green: 236/255, blue: 232/255))
                    .clipShape(Circle())
                    .foregroundColor(Color(red: 198/255, green: 195/255, blue: 189/255))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(self.order.shopperName)
                        .font(.system(size: 17))
                        .bold()
                    Text("\(convertToDate(oldDate: self.order.time)?.localizedDescription ?? "")")
                    .font(.system(size: 14))
                    HStack(alignment: .center) {
                        Circle()
                            .fill(Color("Yellow"))
                            .frame(width: 7, height: 7)
                        if self.order.isPending && !self.order.isReadyForPickup {
                            Text("\(self.order.shopperName) is waiting for you to approve their order")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color("Yellow"))
                                .font(.system(size: 12))
                        } else if !self.order.isPending && self.order.isReadyForPickup {
                            Text("\(self.order.shopperName) will let you know when they've arrived")
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color("Yellow"))
                            .font(.system(size: 12))
                        }
                    }
                }
                
            }
            .padding()
            
            Divider()
            .foregroundColor(.black)
            
            HStack {
                Text("Items")
                    .font(.system(size: 20))
                Spacer()
                
                NavigationLink(destination: ChatView(chatID: "\(self.order.shopperID)AND\(self.dataStore.storeID)", order: self.order).environmentObject(dataStore)) {
                    Image(systemName: "message")
                    .foregroundColor(Color("Dark Blue"))
                }
            }
            .padding(.horizontal)
            
                VStack(spacing: 20) {
                    ForEach(self.orderItems, id: \.self) { item in
                        ItemCard(item: item, editable: true, showSheet: self.$showSheet, editingItem: self.$editingItem, awaitingPayment: self.$awaitingPayment)
                    }
                    
                    Button(action: {
                        if !self.awaitingPayment {
                            let url = "\(self.dataStore.proxy)/merchantApp/approveOrder"
                            let parameters: Parameters = [
                                "orderID": self.order.id
                            ]
                            
                            AF.request(url, method: .post, parameters: parameters).response { response in
                                switch response.result {
                                case .success(_):
                                    self.mode.wrappedValue.dismiss()
                                case .failure(let err):
                                    print(err)
                                }
                            }
                        }
                    }) {
                        Text(!self.awaitingPayment ? "Approve Order" : "Awaiting Customer Payment ...")
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(!self.awaitingPayment ? Color("Dark Blue") : Color(red: 149/255, green: 165/255, blue: 166/255))
                    )
                        .padding(.vertical, 15)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                    
                }
                .sheet(isPresented: $showReplaceSearch, content: {
                    ReplaceItemView(order: self.$order, orderItems: self.$orderItems, itemToReplace: self.$editingItem, showSheet: self.$showReplaceSearch).environmentObject(self.dataStore)
                })
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(
                        title: Text("How do you want to modify this item?"),
                        buttons: [
                            .default(Text("Replace"), action: {
                                self.showReplaceSearch = true
                            }),
                            .default(Text("Remove"), action: {
                                self.orderItems = self.orderItems.filter() {
                                    $0 != self.editingItem!
                                }
                                let url = "\(self.dataStore.proxy)/merchantApp/removeItemFromOrder"
                                let parameters: Parameters = [
                                    "orderID": self.order.id,
                                    "itemID": self.editingItem!.id!
                                ]
                                print(parameters)
                                
                                AF.request(url, method: .post, parameters: parameters).response { response in
                                    switch response.result {
                                    case .success(_):
                                        print("item deleted")
                                    case .failure(let err):
                                        print(err)
                                    }
                                }
                            }),
                            .cancel({
                                self.editingItem = nil
                            })
                        ])
                }
            
            Spacer()
        }
        .padding(.horizontal, 30)
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
        .onDisappear {
            let url = "\(self.dataStore.proxy)/merchantApp/getOrders"
            let parameters: Parameters = [
                "storeID": self.dataStore.store!.storeID
            ]
            
            AF.request(url, method: .get, parameters: parameters).responseDecodable(of: [Order].self){ response in
                switch response.result {
                case .success(let response):
                    self.dataStore.orders = response
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
}

struct ItemCard: View {
 @State var item: Item
@State var editable: Bool
    @Binding var showSheet: Bool
    @Binding var editingItem: Item?
    @Binding var awaitingPayment: Bool
    
    var body: some View {
        
        HStack {
            WebImage(url: URL(string: item.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 75, maxHeight: 75)
            
            VStack(spacing: 8) {
                Text(item.name)
                .bold()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(item.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            }
            
            Spacer()
            
            if self.editable && !self.awaitingPayment {
                Button(action: {
                    self.showSheet = true
                    self.editingItem = self.item
                }) {
                    Image(systemName: "pencil")
                    .foregroundColor(Color("Dark Blue"))
                    .font(.system(size: 22))
                }
            }
             
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .background(Color(red: 248/255, green: 248/255, blue: 248/255))
        .cornerRadius(10)
        .clipped()
        .shadow(radius: 5)
        
    }
}
