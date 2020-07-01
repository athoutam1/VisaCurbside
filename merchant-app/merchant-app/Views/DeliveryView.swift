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

struct DeliveryView: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//    @State var manager = CLLocationManager()
    @State var alert = false
    @State var order: Order
    
    var body: some View {
        VStack {
            MapView()
                .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                .cornerRadius(20)
                .padding()
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

struct MapView: UIViewRepresentable {


    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        let locationManager = CLLocationManager()
        let status = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            view.setRegion(region, animated: true)
        }
    }

}
