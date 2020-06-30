//
//  ItemList.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/27/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Alamofire

enum sheetOption {
    case barcode, custom
}

struct StoreView: View {
    
    @EnvironmentObject var dataStore: DataStore
    
    @State private var showActionSheet = false
    @State private var showSheet = false
    
    @State private var sheetOption: sheetOption?
    
    var body: some View {
        
        VStack {
            if !self.showSheet {
                NavigationView {
                    VStack(spacing: 0) {
                        
                        ZStack(alignment: .topTrailing) {
                            WebImage(url: URL(string: self.dataStore.store!.imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        if self.dataStore.store!.merchantName != nil {
                                            Text(self.dataStore.store!.merchantName!)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        Text(self.dataStore.store!.storeName)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .foregroundColor(.white)
                                    .padding([.bottom, .leading], 10)
                                    .font(.system(size: 20))
                                    .shadow(radius: 10)
                            )
                            
                            
                        }
                        
                        List {
                            
                            Button(action: {
                                self.showActionSheet = true
                            }) {
                                Text("Add New Item")
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.white)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .foregroundColor(.blue)
                            )
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .actionSheet(isPresented: $showActionSheet) {
                                    ActionSheet(
                                        title: Text("Does this item have a barcode?"),
                                        buttons: [
                                            .default(Text("Yes"), action: {
                                                self.sheetOption = .barcode
                                                self.showSheet = true
                                            }),
                                            .default(Text("No"), action: {
                                                self.sheetOption = .custom
                                                self.showSheet = true
                                            }),
                                            .cancel()
                                    ])
                            }
                            
                            ForEach(self.dataStore.items) { item in
                                ItemRow(item: item)
                            }
                            .onDelete(perform: delete)
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            } else {
                ItemAdder(sheetOption: self.$sheetOption, showSheet: self.$showSheet).environmentObject(self.dataStore)
            }
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        let deletedItem = self.dataStore.items[offsets.first!]
        self.dataStore.items.remove(atOffsets: offsets)
        
        let url = "\(self.dataStore.proxy)/merchantApp/deleteItemFromStore"
        let parameters: Parameters = [
            "itemID": deletedItem.id!
        ]
        
        AF.request(url, method: .post, parameters: parameters).response { response in
            switch response.result {
            case .success(_):
                print("Deleted \(deletedItem.name)")
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
}


struct ItemRow: View {
    
    @State var item: Item
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: item.imageURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 75)
            
            VStack(spacing: 8) {
                Text(item.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            }
            
            Spacer()
            
            Text("$\(String(item.price))")
        }
        .padding(.horizontal, 5)
    }
}
