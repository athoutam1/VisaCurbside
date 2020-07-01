//
//  OrderView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI
import Alamofire

struct OrderView: View {
    
    @EnvironmentObject var dataStore: DataStore
//    @State var showOrderDetailsView = false
    
    var body: some View {
            
        ScrollView {
            VStack(spacing: 35) {
                
                Text("Pending Review")
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
                
                VStack(spacing: 18) {
                    ForEach(self.dataStore.orders.filter({ (order) -> Bool in
                        (order.isPending && !order.isReadyForPickup) || (order.isPending && order.isReadyForPickup)
                    }), id: \.self) { order in
                        NavigationLink(destination: OrderDetailsView(order: order, awaitingPayment: (order.isPending && order.isReadyForPickup)).environmentObject(self.dataStore)) {
                            OrderRow(order: order)
                        }
                    }
                }
                .padding(.leading, 15)
                
                Text("Awaiting Pickup")
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
                
                VStack(spacing: 18) {
                ForEach(self.dataStore.orders.filter({ (order) -> Bool in
                    !order.isPending && order.isReadyForPickup
                }), id: \.self) { order in
                    NavigationLink(destination: DeliveryView(order: order).environmentObject(self.dataStore)) {
                        OrderRow(order: order)
                    }
                }
                }
                .padding(.leading, 15)
                
                Text("Past Orders")
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
                
                VStack(spacing: 18) {
                ForEach(self.dataStore.orders.filter({ (order) -> Bool in
                    !order.isPending && !order.isReadyForPickup
                }), id: \.self) { order in
                    NavigationLink(destination: PastOrderView(order: order).environmentObject(self.dataStore)) {
                        OrderRow(order: order)
                    }
                }
                }
                .padding(.leading, 15)
                
                Spacer()
                
            }
            .padding(.horizontal, 30)
            .padding(.top, 15)
            .onAppear {
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
            .navigationBarTitle("Orders", displayMode: .large)
            
    }
}

struct ListHeader: View {
    @State var text: String
    @State var icon: String
    var body: some View {
        HStack {
            Image(systemName: self.icon)
            Text(self.text)
        }
        .font(.system(size: 17))
        .padding(.vertical)
    }
}

struct OrderRow: View {
    @State var order: Order
    var body: some View {
        HStack {
            VStack(spacing: 6) {
                Text(self.order.shopperName)
                    .font(.system(size: 18))
                    .bold()
                     .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(convertToDate(oldDate: self.order.time)?.localizedDescription ?? "")")
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Order #: \(self.order.id)")
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            Image(systemName: "message")
            .foregroundColor(Color("Dark Blue"))
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

func convertToDate(oldDate: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let date = dateFormatter.date(from: oldDate) {
        return date
    }
    return nil
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}


extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}
