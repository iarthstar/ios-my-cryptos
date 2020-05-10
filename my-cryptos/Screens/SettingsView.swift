//
//  SettingsView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 06/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataStore: DataStore
    @State var email: String = ""
    
    var frameworks = ["INR", "USD"]
    @State private var selectedFrameworkIndex = 0
    
    func logOutUser () {
        self.dataStore.userId = ""
    }
    
    func enableDoneButton () -> some View {
        if self.frameworks[selectedFrameworkIndex] == self.dataStore.currency {
            return Button(action:{}) { Text("") }
        } else {
            return Button(action: {
                self.dataStore.currency = self.frameworks[self.selectedFrameworkIndex]
            }) { Text("Done").bold() }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section (header: Text("EMAIL"), footer: Text("")) {
                        Text(email)
                            .foregroundColor(Color.gray)
                    }
                    
                    Section (header: Text("PREFERENCES"), footer: Text("")) {
                        HStack{
                            Text("Currency")
                            Spacer()
                            Picker("", selection: $selectedFrameworkIndex) {
                               ForEach(0 ..< frameworks.count) {
                                  Text(self.frameworks[$0])
                               }
                            }
                            .frame(width: 120)
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    Section {
                        Button (action: {
                            self.logOutUser()
                        }){
                           Text("Log Out").foregroundColor(Color.red)
                        }
                        
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(trailing: enableDoneButton())
        }
        .onAppear() {
            self.email = self.dataStore.userId
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
