//
//  Cryptos.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 07/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import Foundation

func getCryptosAPI(_ data: MyCrptosRequest, _ callback: @escaping(_ resp: [MyCryptosResponse])-> Void) {
    callApi("POST", "https://my-cryptos.herokuapp.com/myCryptos", data, callback)
}

func addCryptoAPI(_ data: AddCryptoRequest, _ callback: @escaping(_ resp: AddCryptoResponse)-> Void) {
    callApi("POST", "https://my-cryptos.herokuapp.com/addCrypto", data, callback)
}

func editCryptoAPI(_ data: EditCryptoRequest, _ callback: @escaping(_ resp: [Int])-> Void) {
    callApi("POST", "https://my-cryptos.herokuapp.com/editCrypto", data, callback)
}

func deleteCryptoAPI(_ data: DeleteCryptoRequest, _ callback: @escaping(_ resp: String)-> Void) {
    callApi("POST", "https://my-cryptos.herokuapp.com/deleteCrypto", data, callback)
}

func getAllCryptosAPI(_ callback: @escaping(_ resp: GetAllCryptosResponse)-> Void) {
    callApi("GET", "https://min-api.cryptocompare.com/data/all/coinlist", "{}", callback)
}
