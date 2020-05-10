//
//  OTPView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 09/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @Binding var email: String
    
    @State var otp: String = ""
    
    func loginUser () {
        self.dataStore.userId = email
    }
    
    var body: some View {
        List {
            Section (header: Text("")) {
                EmptyView()
            }
            Section (header: Text("EMAIL"), footer: Text("One time password has been sent to your email.\n")) {
                Text("\(email)").foregroundColor(Color.gray)
            }
            Section (header: Text("OTP")) {
                TextField("Enter OTP here", text: $otp)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("OTP"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.loginUser()
        }) {
            Text("Next")
        })
    }
}
