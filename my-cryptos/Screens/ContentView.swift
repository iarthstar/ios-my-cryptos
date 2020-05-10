//
//  ContentView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 06/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @State var email: String = ""
    
    var body: some View {
        ZStack {
            
            if dataStore.userId == "" {
                LoginView().environmentObject(dataStore)
            } else {
                TabView {
                    CryptosView().tabItem {
                        VStack {
                            Image(systemName: "list.dash")
                                .font(.system(size: 16, weight: .bold))
                            Text("Coins")
                        }
                    }.tag(1)
                    SettingsView().tabItem {
                        VStack {
                            Image(systemName: "gear")
                                .font(.system(size: 16, weight: .bold))
                            Text("Settings")
                        }
                    }.tag(2)
                }
                .blur(radius: (dataStore.backdrop > 0 ? 4 : 0))
            }
            
            
            if dataStore.backdrop > 0 {
                VStack {
                    Text("Loading").foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Rectangle().fill(Color(UIColor.init(white: 0.5, alpha: 0.5))).shadow(radius: 50))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
