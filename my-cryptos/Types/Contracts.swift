//
//  Contracts.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 07/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import Foundation

struct MyCryptosResponse: Codable {
    var cryptoName: String
    var cryptoQuantity: Double
}

struct MyCrptosRequest: Codable {
    var userId: String
}

struct AddCryptoRequest: Codable {
    var boughtAt: Double
    var cryptoName: String
    var cryptoQuantity: Double
    var userId: String
}

struct AddCryptoResponse: Codable {
    var boughtAt: Double
    var createdAt: String
    var cryptoName: String
    var cryptoQuantity: Double
    var srno: Double
    var updatedAt: String
    var userId: String
}

struct DeleteCryptoRequest: Codable {
    var cryptoName: String
    var userId: String
}

struct EditCryptoRequest: Codable {
    var cryptoName: String
    var cryptoQuantity: Double
    var userId: String
}

struct GetPricesRequest: Codable {
    var cryptoNames: [String]
    var currencies: [String]
}

struct GetPricesResponse: Codable {
    struct CoinPrices: Codable {
        struct Prices: Codable {
            var name: String
            var value: Double
        }
        var name: String
        var prices: [Prices]
    }
    var results: [CoinPrices]
}

struct Coin: Codable, Hashable, Equatable, Comparable {
    static func < (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.Symbol < rhs.Symbol
    }
    
    var Name: String
    var CoinName: String
    var Symbol: String
}

struct GetAllCryptosResponse: Codable {
    var Data: [String: Coin]
}
