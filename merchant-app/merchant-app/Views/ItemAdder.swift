//
//  ItemAdder.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/27/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import CarBode
import Alamofire
import SDWebImageSwiftUI
import FirebaseStorage

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct ItemAdder: View {
    
    @Binding var items: [Item]
    @Binding var sheetOption: sheetOption?
    @Binding var showSheet: Bool
    
    @State var barcode: String?
    
    @State var itemName: String = ""
    @State var itemPrice: String = ""
    @State var itemDescription: String = ""
    
    @State var loading = false
    @State var loadingMessage = ""
    
    @State var isTyping = false
    @State var imageURL: String = ""
    @State var itemImage: UIImage?
    @State var showImagePicker = false
    @State var showError = false
    
    var body: some View {
        ZStack {
            VStack {
                if sheetOption == .barcode {
                    ZStack {
                        CBScanner(supportBarcode: [.ean13])
                            .interval(delay: 5.0) //Event will trigger every 5 seconds
                            .found{
                                
                                self.loadingMessage = "Predicting Product Data ..."
                                self.loading = true
                                
                                print($0)
                                self.barcode = $0
                                
                                let url = "https://b7d42b2bc448.ngrok.io/productData"
                                let parameters: Parameters = [
                                    "barcode": self.barcode!
                                ]
                                
                                AF.request(url, method: .post, parameters: parameters).responseJSON { response in
                                    switch response.result {
                                    case .success(let jsonData):
                                        self.loading = false
                                        
                                        let response = jsonData as! NSDictionary
                                        let newItem = Item(name: response["name"] as! String, description: response["description"] as! String, price: (response["price"] as! NSString).doubleValue, imageURL: response["imageURL"] as! String)
                                        
                                        print(newItem)
                                        self.itemName = newItem.name
                                        self.itemPrice = String(newItem.price)
                                        self.imageURL = newItem.imageURL
                                        self.itemDescription = newItem.description
                                        
                                        self.sheetOption = .custom
                                    case .failure(let err):
                                        self.loading = false
                                        self.showError = true
                                        print(err)
                                    }
                                }
                                
                        }
                        // .simulator(mockBarCode: "MOCK BARCODE DATA 1234567890")
                        VStack {
                            Text("Please point the camera at the barcode")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 15)
                            Spacer()
                        }
                    }
                    .alert(isPresented: $showError) {
                        Alert(title: Text("Product Unavailable"), message: Text("We couldn't find any data on this product"),
                              primaryButton: .default(Text("Manual entry"), action: {
                                self.sheetOption = .custom
                              }),
                              secondaryButton: .default(Text("Try again")))
                    }
                } else if sheetOption == .custom {
                    ScrollView {
                        
                        ZStack(alignment: .bottomTrailing) {
                            
                            if self.itemImage != nil {
                                Image(uiImage: self.itemImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .cornerRadius(15)
                            } else if self.imageURL != "" {
                                WebImage(url: URL(string: self.imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: UIScreen.main.bounds.height * 0.5 )
                                .cornerRadius(15)
                            } else {
                                Image("placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .cornerRadius(15)
                            }
                            
                            Button(action: {
                                self.showImagePicker = true
                            }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 25))
                                    .padding([.trailing, .bottom], 10)
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(sourceType: .photoLibrary) { (image) in
                                    self.itemImage = image
                                }
                            }
                        }
                        
                        VStack(spacing: 25) {
                            TextField("Name", text: $itemName, onCommit: {
                                self.isTyping = false
                            })
                                .onTapGesture {
                                    self.isTyping = true
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                            
                            TextField("Price", text: $itemPrice, onCommit: {
                                self.isTyping = false
                            })
                                .onTapGesture {
                                    self.isTyping = true
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .keyboardType(.decimalPad)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                            
                            MultilineTextField("Description", text: $itemDescription) {
                                self.isTyping = false
                            }
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                            .onTapGesture {
                                self.isTyping = true
                            }
                        }
                        .padding(.top, 10)
                        
                        Button(action: {
                            self.isTyping = false
                            if self.itemName.trimmingCharacters(in: .whitespaces) == "" || self.itemPrice.trimmingCharacters(in: .whitespaces) == "" || self.itemDescription.trimmingCharacters(in: .whitespaces) == "" {
                                print("Missing something")
                            } else {
                                
                                if self.itemImage != nil {
                                    print("Picked a custom image")
                                    self.loadingMessage = "Uploading Image ..."
                                    self.loading = true
                                    
                                    let imageData = self.itemImage!.jpegData(compressionQuality: 0.75)
                                    let storageRef = Storage.storage().reference().child("productPics/\(UUID()).png")
                                    
                                    let uploadTask = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                                        if err != nil {
                                            print(err!)
                                            return
                                        }
                                    })
                                    uploadTask.observe(.success) { snapshot in
                                        print("Finished uploading")
                                        
                                        storageRef.downloadURL { (uploadURL, error) in
                                            if let error = error {
                                                print(error)
                                            } else {
                                            self.loadingMessage = "Saving Item ..."
                                        let newItem = Item(name: self.itemName, description: self.itemDescription, price: (self.itemPrice as NSString).doubleValue, imageURL: "\(uploadURL!)")
                                               print(newItem)
                                               self.items.append(newItem)
                                                self.loading = false
                                               self.showSheet = false
                                            }
                                        }
                                        
                                    }
                                } else {
                                    self.loadingMessage = "Saving Item ..."
                                    self.loading = true
                                    let newItem = Item(name: self.itemName, description: self.itemDescription, price: (self.itemPrice as NSString).doubleValue, imageURL: self.imageURL)
                                    print(newItem)
                                    self.items.append(newItem)
                                 self.loading = false
                                    self.showSheet = false
                                }
                                
                                
                            }
                        }) {
                            Text("Add item")
                        }
                        .padding(.top, 30)
                        
                        Button(action: {
                            self.isTyping = false
                            self.showSheet = false
                        }) {
                            Text("Cancel")
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 100)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .offset(y: self.isTyping ? -(UIScreen.main.bounds.height * 0.3) : 0)
            .animation(self.isTyping ? .easeInOut : nil)
            
            if self.loading {
                VStack(spacing: 15) {
                    LottieView(filename: "loading")
                    .frame(width: 80, height: 80)
                    Text(self.loadingMessage)
                }
                .padding()
                .background(Color(red: 236/255, green: 240/255, blue: 241/255))
                .cornerRadius(25)
                .offset(y: -40)
                
            }
        }
        .onTapGesture {
            self.isTyping = false
            hideKeyboard()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}




struct ItemAdder_Previews: PreviewProvider {
    static var previews: some View {
        ItemAdder(items: .constant([]), sheetOption: .constant(.custom), showSheet: .constant(false))
    }
}
