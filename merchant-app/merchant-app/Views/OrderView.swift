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
    
    var body: some View {
            
            VStack {
                
                List {
                    Section(header:
                        ListHeader(text: "Pending Review", icon: "stopwatch")
                            .font(.title)
                    ) {
                        ForEach(self.dataStore.orders.filter({ (order) -> Bool in
                            order.isPending && !order.isReadyForPickup
                        })) { order in
                            NavigationLink(destination: OrderDetailsView(order: order).environmentObject(self.dataStore)) {
                                OrderRow(order: order)
                            }
                        }
                    }
                    
                    Section(header:
                        ListHeader(text: "Awaiting Pickup", icon: "car")
                    ) {
                        ForEach(self.dataStore.orders.filter({ (order) -> Bool in
                            !order.isPending && order.isReadyForPickup
                        })) { order in
                            OrderRow(order: order)
                        }
                    }
                    Section(header:
                        ListHeader(text: "Past Orders", icon: "clock")
                    ) {
                        ForEach(self.dataStore.orders.filter({ (order) -> Bool in
                            !order.isPending && !order.isReadyForPickup
                        })) { order in
                            OrderRow(order: order)
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Orders", displayMode: .large)
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
        VStack(spacing: 6) {
            HStack(alignment: .center, spacing: 12) {
                Text("Order ID: \(self.order.id)")
                .font(.system(size: 10))
                .foregroundColor(.gray)
                Text(self.order.shopperName)
                .font(.system(size: 18))
                Spacer()
            }
            Text("\(convertToDate(oldDate: self.order.time)?.localizedDescription ?? "")")
            .font(.system(size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
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
