//
//  ProfileView.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/29/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    init()
    {
        UISwitch.appearance().onTintColor = .systemYellow
    }

    var body: some View {
        ScrollView {
            
            VStack {
                Image(systemName: "person.fill")
                .font(.system(size: 100))
                .padding(15)
                .background(Color(red: 239/255, green: 236/255, blue: 232/255))
                .clipShape(Circle())
                .foregroundColor(Color(red: 198/255, green: 195/255, blue: 189/255))
                    .padding(.top, 40)
                
                Text("Edit Profile")
                    .foregroundColor(Color("Yellow"))
                
                Divider()
                .foregroundColor(.black)
                .padding(.top, 15)
                VStack {
                    Text("Personal Information")
                    .bold()
                    .font(.system(size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 15)
                    VStack {
                        Text("Name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.gray)
                        Text("John Appleseed")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 10)
                    Divider()
                    VStack {
                        Text("Email")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.gray)
                        Text("john@visa.com")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 10)
                    Divider()
                    VStack {
                        Text("Role")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.gray)
                        Text("Store Owner")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 30)
                Divider()
                    .foregroundColor(.black)
                
                VStack {
                    Text("Store Settings")
                    .bold()
                    .font(.system(size: 22))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 15)
                    
                    HStack {
                        Text("Enable Chat With Customers")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Toggle(isOn: .constant(true)) {
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 10)
                    Divider()
                    HStack {
                        Text("Allow Custom Orders")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Toggle(isOn: .constant(false)) {
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 10)
                    Divider()
                    HStack {
                        Text("Allow Product Catalog Filters")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Toggle(isOn: .constant(false)) {
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 10)
                    Divider()
                    HStack {
                        Text("Allow Employees to Manage Orders")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Toggle(isOn: .constant(true)) {
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 10)
                    Divider()
                    HStack {
                        Text("Enable Chat Bot")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Toggle(isOn: .constant(true)) {
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 10)
                    
                }
                .padding(.horizontal, 30)
                
                
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
