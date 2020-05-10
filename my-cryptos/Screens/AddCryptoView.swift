//
//  AddCryptoView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 06/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

struct AddCryptoView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectedCoinIndex = -1
    
    @Binding var showAddCrypto: Bool
    @Binding var list: [Crypto]

    @State var name: String
    @State var quantity: String
    
    var edit: Bool
    
    @State private var selectedCrypto: Coin = Coin(Name: "", CoinName: "", Symbol: "")
    
    func addCrypto(data: AddCryptoRequest) {
        dataStore.backdrop += 1
        addCryptoAPI(data, { (resp: AddCryptoResponse) -> Void in
            self.presentationMode.wrappedValue.dismiss()
            self.dataStore.backdrop -= 1
            self.list.append(Crypto(name: resp.cryptoName, quantity: resp.cryptoQuantity, inr: 0.0))
        })
    }
    
    func editCrypto(data: EditCryptoRequest) {
        dataStore.backdrop += 1
        editCryptoAPI(data, { (resp: [Int]) -> Void in
            self.presentationMode.wrappedValue.dismiss()
            self.dataStore.backdrop -= 1
            self.list = self.list.map { crypto in
                var updatedCrypto = crypto
                if updatedCrypto.name == data.cryptoName {
                    updatedCrypto.quantity = data.cryptoQuantity
                    return updatedCrypto
                } else {
                    return crypto
                }
            }
        })
    }
    
    func enableDoneButton () -> some View {
        if self.edit && self.quantity != "" {
            return Button(action: {
                self.editCrypto(data: EditCryptoRequest(cryptoName: self.name, cryptoQuantity: Double(self.quantity) ?? 0.0, userId: self.dataStore.userId))
            }) {
                Text("Done").bold()
            }
        } else if self.selectedCrypto.Symbol == "" || self.quantity == "" {
            return Button(action:{}) { Text("") }
        } else {
            return Button(action: {
                self.addCrypto(data: AddCryptoRequest(boughtAt: 1.0, cryptoName: self.selectedCrypto.Symbol, cryptoQuantity: Double(self.quantity) ?? 0.0, userId: self.dataStore.userId))
            }) {
                Text("Done").bold()
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                List {
                    Section {
                        HStack {
                            Text("Coin")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            if self.edit {
                                Text(name)
                                    .foregroundColor(Color.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                if dataStore.coins.count != 0 {
                                    NavigationLink (destination: AllCryptosListView(selectedCrypto: self.$selectedCrypto).environmentObject(dataStore)) {
                                        VStack (alignment: .leading, spacing: 0) {
                                            Text(selectedCrypto.Symbol)
                                                .font(.system(size: 16)).bold()
                                            Text(selectedCrypto.CoinName)
                                                .font(.system(size: 12))
                                        }
                                        .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                        HStack {
                           Text("Quantity")
                               .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            TextField("Enter quantity", text: $quantity)
                                .keyboardType(.decimalPad)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle(Text(self.edit ? "Edit Crypto" : "Add Crypto"))
            .navigationBarItems(trailing: enableDoneButton())
    }
}
