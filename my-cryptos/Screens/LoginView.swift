//
//  LoginView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 09/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @State var email: String = ""
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                List {
                    Section (header: Text(""), footer: Text("Track all your Crypto holdings at one place.\nSee real-time pricing, quantity and total amount of your crypto holdings.\n")) {
                       EmptyView()
                    }
                    
                    Section (header: Text("EMAIL"), footer: Text("")) {
                        TextField("Enter you email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                }
                .listStyle(GroupedListStyle())
            }
        .navigationBarTitle(Text("My Cryptos"))
            .navigationBarItems(trailing: NavigationLink(destination: OTPView(email : self.$email).environmentObject(dataStore)){
                Text("Next")
            })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
