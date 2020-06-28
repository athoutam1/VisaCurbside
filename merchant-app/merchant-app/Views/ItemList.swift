//
//  ItemList.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/27/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

enum sheetOption {
    case barcode, custom
}

struct ItemList: View {
    
    @State var items: [Item] = [
        Item(name: "Ketchup", description: "asdashd asdas dohasdoas", price: 2.99, imageURL: "https://images-na.ssl-images-amazon.com/images/I/71Q28KBgotL._SX679_.jpg")
    ]
    
    @State private var showActionSheet = false
    @State private var showSheet = false
    
    @State private var sheetOption: sheetOption?
    
    var body: some View {
        
        VStack {
            if !self.showSheet {
                NavigationView {
                    VStack {
                        List {
                            ForEach(items) { item in
                                ItemRow(item: item)
                            }
                        }
                        .navigationBarTitle("Product Catalog")
                        .navigationBarItems(trailing:
                            Button(action: {
                                self.showActionSheet = true
                            }, label: {
                                Image(systemName: "plus")
                                    .padding(10)
                            })
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
                        )
                    }
                    
                }
            } else {
                ItemAdder(items: self.$items, sheetOption: self.$sheetOption, showSheet: self.$showSheet)
            }
        }
        
    }
    
    struct ItemList_Previews: PreviewProvider {
        static var previews: some View {
            ItemList()
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
                
                Text(item.name)
                
                Spacer()
                
                Text("$\(String(item.price))")
            }
            .padding(.horizontal, 5)
        }
    }
}
