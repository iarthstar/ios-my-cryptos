//
//  URLSession.swift
//  my-cryptos
//
//  Created by Arth Gajjar on 07/05/20.
//  Copyright © 2020 Arth Gajjar. All rights reserved.
//

import Foundation


func callApi<T: Codable, Q: Decodable>(_ method: String, _ url: String, _ body: T, _ completion: @escaping(_ resp: Q)-> Void) -> () {

    var request = URLRequest(url: URL(string: url)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = method

    do {
        
        if method != "GET" {
            let jsonData = try JSONEncoder().encode(body)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
            request.httpBody = jsonString.data(using: .utf8)
        }
        

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode){
                    if let data = data {
                        if let decodedResponse = try? JSONDecoder().decode(Q.self, from: data) {
                            DispatchQueue.main.async {
                                completion(decodedResponse)
                            }
                            return
                        }
                        else {
                            print("Decode failed: \(error?.localizedDescription ?? "Unknown error")")
                            DispatchQueue.main.async {
                                completion("DECODE_FAILED" as! Q )
                            }
                            return
                        }
                    }
//                    else {
//                        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//                        DispatchQueue.main.async {
//                            completion("FECTH_FAIL" as! Q)
//                        }
//                        return
//                    }
                }
            }
            
            
        }.resume()
    } catch {
     print("Error")
    }
}
