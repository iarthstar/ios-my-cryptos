//
//  DataStore.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 06/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import Foundation

class DataStore: ObservableObject {
    @Published var backdrop: Int = 0
    @Published var userId: String = "iarthstar@gmail.com"
    @Published var currency: String = "INR"
    @Published var coins: [Coin] = []
    @Published var search: String = "1"
}
