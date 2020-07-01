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
                                .blur(radius: 3.5)
                                .overlay(
                                    VStack {
                                        Spacer()
                                        if self.dataStore.store!.merchantName != nil {
                                            Text(self.dataStore.store!.merchantName!)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                        Text(self.dataStore.store!.storeName)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        Spacer()
                                    }
                                    .foregroundColor(.white)
//                                    .padding([.bottom, .leading], 10)
                                    .font(.system(size: 28))
                                    .shadow(radius: 10)
                            )
                            
                            
                        }
                        
                        List {
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showActionSheet = true
                                }) {
                                    Text("Add Item")
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.white)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .foregroundColor(Color("Dark Blue"))
                                )
                                .padding(.vertical, 15)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                                Spacer()
                            }
                                
                                
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
                .frame(maxWidth: 75, maxHeight: 75)
            
            VStack(spacing: 8) {
                HStack {
                    Text(item.name)
                    .bold()
                    .lineLimit(1)
                    Text("- $\(String(item.price))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(item.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            }
            
             Spacer()
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }
}
