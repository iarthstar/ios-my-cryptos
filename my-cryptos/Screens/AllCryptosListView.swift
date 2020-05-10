//
//  AllCryptosListView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 10/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

struct AllCryptosListView: View {
    @EnvironmentObject var dataStore: DataStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var search: String = ""
    
    @Binding var selectedCrypto: Coin
    
    var body: some View {
        VStack (spacing: 0) {
            List {
                Section (header: Text("SEARCH")) {
                    TextField("Type here to search", text: $search)
                }
            }
            .listStyle(GroupedListStyle())
            .frame(height: 100)
            
            List (self.dataStore.coins.filter({ crypto in crypto.Symbol >= self.search}).prefix(search == "" ? 0 : 20), id:\.Symbol) { crypto in
                VStack (alignment: .leading) {
                    Text(crypto.Symbol)
                        .font(.system(size: 16)).bold()
                    Text(crypto.CoinName)
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedCrypto = crypto
                    self.presentationMode.wrappedValue.dismiss()
                }

            }
            .frame(maxHeight: .infinity)
            
        }
        .frame(maxHeight: .infinity)
        .navigationBarTitle(Text("All Cryptos"), displayMode: .inline)
        .onAppear() {
            self.search = self.selectedCrypto.Symbol
        }
    }
}
