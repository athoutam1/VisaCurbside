//
//  ChatView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import FirebaseFirestoreSwift
import Alamofire

struct ChatView: View {
        
    @EnvironmentObject var dataStore: DataStore
    @State var chatID: String
    @State var order: Order
    
    @State var messages: [Message] = []
    @State var typingMessage: String = ""
    @State var isTyping = false
    
    var body: some View {
        ZStack {
            
            VStack {
                List {
                    ForEach(self.messages, id: \.self) { message in
                        VStack {
                            if message.messenger == "store" {
                                HStack(alignment: .bottom) {
                                    Spacer()
                                    Text(message.message)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .clipShape(Bubble(chat: true))
                                    Image(message.messenger)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 35)
                                        .clipShape(Circle())
                                }
                            } else {
                                HStack(alignment: .bottom) {
                                    Image(message.messenger)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 35)
                                        .clipShape(Circle())
                                    Text(message.message)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .clipShape(Bubble(chat: false))
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                }
//                .animation(nil)
            }
            .padding(.bottom, self.isTyping ? 100 : 0)
            
            
            VStack {
                Spacer()
                HStack {
                    TextField("Message", text: $typingMessage, onCommit: {
                        self.isTyping = false
                    })
                    .onTapGesture {
                        self.isTyping = true
                    }
                    Button(action: {
                        self.isTyping = false
                        
                        let url = "\(self.dataStore.proxy)/merchantApp/messageShopper"
                        let parameters: Parameters = [
                            "storeID": self.dataStore.store!.storeID,
                            "message": self.typingMessage,
                            "shopperID": self.order.shopperID
                        ]
                        
                        AF.request(url, method: .get, parameters: parameters).response { response in
                            switch response.result {
                            case .success(let response):
                                print(response)
                                self.typingMessage = ""
                            case .failure(let err):
                                print(err)
                            }
                        }
                        
                    }) {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
                .background(Color(red: 236/255, green: 240/255, blue: 241/255))
            }
            
        }
        .navigationBarTitle(self.order.shopperName)
   
            
            .offset(y: self.isTyping ? -(UIScreen.main.bounds.height * 0.3) : 0)
            .animation(self.isTyping ? .easeInOut : nil)
            .onTapGesture {
                self.isTyping = false
                hideKeyboard()
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

struct Bubble: Shape {
    var chat: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, chat ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 25, height: 25))
        return Path(path.cgPath)
    }
}
