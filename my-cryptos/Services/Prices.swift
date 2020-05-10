//
//  Prices.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 09/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import Foundation

func getPricesAPI(_ data: GetPricesRequest, _ callback: @escaping(_ resp: GetPricesResponse)-> Void) {
    callApi("POST", "https://grandeur-backend.herokuapp.com/crypto_api/get_price_for_cryptos", data, callback)
}
