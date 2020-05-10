//
//  CryptosListView.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 06/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import SwiftUI

var timer: Timer? = nil

struct CryptosView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @State var showAddCrypto: Bool = false
    @State var list: [Crypto] = []
    @State var total = 0.0

   
    func currencyFormatter(val: Double) -> String {
        if val < 1 {
            return String("\(val)")
        } else {
            return String(format: "%.2f", val)
        }
    }
    
    func totalAmount() -> Double {
        var total: Double = 0
        self.list.forEach { coin in
            total += coin.quantity * coin.inr
        }
        return total
    }
    
    func deleteCrypto(at offsets: IndexSet) {
        deleteCryptoAPI(DeleteCryptoRequest(cryptoName: list[offsets.first ?? -1].name, userId: dataStore.userId), { (resp) in
            self.list.remove(at: offsets.first ?? -1)
        })
    }
    
    func editCrypto (_ crypto: Crypto) {
        
    }

    func getCryptos(data: MyCrptosRequest) {
        dataStore.backdrop += 1
        getCryptosAPI(data, { (resp: [MyCryptosResponse]) -> Void in
            self.list = resp.map { crypto in
                return Crypto(name: crypto.cryptoName, quantity: crypto.cryptoQuantity, inr: 0.0)
            }
            
            // First Time Prices Fetch
            let cryptoNames: [String] = self.list.map { coin in return coin.name }
            getPricesAPI(GetPricesRequest(cryptoNames: cryptoNames, currencies: [self.dataStore.currency]), { (resp: GetPricesResponse) -> Void in
                self.list = resp.results.map { coin in
                    let quantity = (self.list.first { crypto in crypto.name == coin.name})?.quantity ?? 0.0
                    return Crypto(name: coin.name, quantity: quantity, inr: coin.prices[0].value)
                }
                self.dataStore.backdrop -= 1
            })
            
            // Recurring Price Fetch every 10 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { timer in
                if self.list.count != 0 {
                    let cryptoNames: [String] = self.list.map { coin in return coin.name }
                    self.getPrices(GetPricesRequest(cryptoNames: cryptoNames, currencies: [self.dataStore.currency]))
                }
            }
        })
    }
    
    func getAllCryptos () {
        dataStore.backdrop += 1
        getAllCryptosAPI({ (resp: GetAllCryptosResponse) -> Void in
            var symbols: [Coin] = []
            for (_, value) in resp.Data {
                symbols.append(value)
            }
            self.dataStore.coins = symbols.sorted(by: <)
            self.dataStore.backdrop -= 1
        })
    }
    
    func getPrices(_ data: GetPricesRequest) {
        getPricesAPI(data, { (resp: GetPricesResponse) -> Void in
            self.list = resp.results.map { coin in
                let quantity = (self.list.first { crypto in crypto.name == coin.name})?.quantity ?? 0.0
                return Crypto(name: coin.name, quantity: quantity, inr: coin.prices[0].value)
            }
        })
    }
    
    func currencySymbol () -> String {
        if self.dataStore.currency == "INR" {
            return "₹"
        } else if self.dataStore.currency == "USD" {
            return "$"
        } else {
            return ""
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if list.count > 0 {
                    List {
                        Section {
                            ForEach(list, id: \.name) { crypto in
                                NavigationLink(destination: AddCryptoView(showAddCrypto: self.$showAddCrypto, list: self.$list, name: crypto.name, quantity: String("\(crypto.quantity)"), edit: true).environmentObject(self.dataStore)) {
                                    HStack {
                                        VStack (alignment: .leading) {
                                            Text(crypto.name)
                                                .fontWeight(.bold)
                                                .padding(.bottom, 4)
                                            Text("\(self.currencyFormatter(val: crypto.quantity))")
                                                .font(.system(size: 12))
                                            
                                        }
                                        Spacer()
                                        VStack (alignment: .trailing) {
                                            Text("\(self.currencySymbol()) \(self.currencyFormatter(val: crypto.inr))")
                                                .font(.system(size: 12))
                                                .padding(.bottom, 4)
                                            Text("\(self.currencySymbol()) \(self.currencyFormatter(val: crypto.quantity * crypto.inr))")
                                                .fontWeight(.bold)
                                        }
                                        .padding(.trailing, 10)
                                    }
                                    .contentShape(Rectangle())
                                }
                                
                            }
                            .onDelete(perform: self.deleteCrypto)
                            .onMove { (indexSet, index) in
                                self.list.move(fromOffsets: indexSet, toOffset: index)
                            }
                        }
                        Section (header: Text("")) {
                            HStack {
                                Text("Total Amount")
                                Spacer()
                                Text("\(self.currencySymbol()) \(self.currencyFormatter(val: self.totalAmount()))")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                } else {
                    HStack {
                        Text("Tap")
                        Image(systemName: "plus").foregroundColor(Color.blue)
                        Text("on top-right to add new crypto")
                    }
                }
            }
            .navigationBarTitle(Text("Coins"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: AddCryptoView(showAddCrypto: self.$showAddCrypto, list: self.$list, name: "", quantity: "", edit: false).environmentObject(self.dataStore)) {
                    Image(systemName: "plus")
                }
            )
        }
        .onAppear() {
            self.getCryptos(data: MyCrptosRequest(userId: self.dataStore.userId))
            if self.dataStore.coins.count == 0 {
                self.getAllCryptos()
            }
        }
        .onDisappear() {
            timer?.invalidate()
            timer = nil
        }
    }
}
