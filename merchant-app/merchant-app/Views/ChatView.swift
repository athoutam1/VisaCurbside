//
//  ChatView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ChatView: View {
        
    @EnvironmentObject var dataStore: DataStore
    @State var chatID: String
    
    @State var messages: [Message] = []
    
    var body: some View {
        VStack {
            
            List {
                ForEach(self.messages, id: \.self) { message in
                    HStack {
                        Text(message.messenger)
                        Text(message.message)
                    }
                }
            }
            .animation(nil)
            
        }
            .onAppear {
                self.dataStore.db.collection("chats").document(self.chatID)
                .addSnapshotListener { documentSnapshot, error in
                  guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                  }
                  guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                  }
                    
                    do {
                        let old = data["messages"] as? [NSDictionary]?
                        let json = try JSONSerialization.data(withJSONObject: old)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedMessages = try decoder.decode([Message].self, from: json)
                        self.messages = decodedMessages
                    } catch {
                        print(error)
                    }

                    
                }
        }
    }
}
