//
//  ContentView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/27/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import CarBode

struct ContentView: View {
    
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        TabView {
            StoreView().environmentObject(dataStore)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Store")
                }
            NavigationView {
             OrderView().environmentObject(dataStore)
            }
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Order")
            }
            
            
            ProfileView().environmentObject(dataStore)
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
