//
//  DeliveryView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/30/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import MapKit
import Alamofire
import GoogleMaps

struct DeliveryView: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var alert = false
    @State var order: Order
    
    var body: some View {
        VStack {
            if self.order.coordinates != nil {
                GoogleMapsView(latitude: Double(self.order.coordinates!.split(separator: ",")[0].trimmingCharacters(in: .whitespacesAndNewlines))!, longitude: Double(self.order.coordinates!.split(separator: ",")[1].trimmingCharacters(in: .whitespacesAndNewlines))!, order: self.order)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                .cornerRadius(20)
                .padding()
            } else {
                GoogleMapsView(order: self.order)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                .cornerRadius(20)
                .padding()
            }
            Spacer()
            Spacer()
            
            if self.order.coordinates != nil {
                Button(action: {
                    let url = "\(self.dataStore.proxy)/merchantApp/orderDelivered"
                    let parameters: Parameters = [
                        "orderID": self.order.id
                    ]
                    
                    AF.request(url, method: .post, parameters: parameters).response { response in
                        switch response.result {
                        case .success(_):
                            print("order delivered")
                            self.mode.wrappedValue.dismiss()
                        case .failure(let err):
                            print(err)
                        }
                    }
                }) {
                    Text("Mark as Delivered")
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundColor(Color("Dark Blue"))
                    )
                    .padding(.vertical, 15)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                }
            }
            
            Spacer()
            NavigationLink(destination: ChatView(chatID: "\(self.order.shopperID)AND\(self.dataStore.storeID)", order: self.order).environmentObject(dataStore)) {
                Text("Message \(self.order.shopperName)")
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .foregroundColor(Color("Dark Blue"))
                )
                .padding(.vertical, 15)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
            }
            
            Spacer()
            Spacer()
        }
        .navigationBarTitle("Order Pickup")
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


struct GoogleMapsView: UIViewRepresentable {
    // 1
    @ObservedObject var locationManager = LocationManager()
    @State var latitude: Double?
    @State var longitude: Double?
    @State var order: Order
    private let zoom: Float = 15.0
    
    // 2
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        if let lat = latitude {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: self.longitude!)
            marker.title = self.order.shopperName
            marker.snippet = "Order #\(self.order.id)"
            marker.map = mapView
        }
        
        return mapView
    }
    
    // 3
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        //        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        //        mapView.camera = camera
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
    }
}
