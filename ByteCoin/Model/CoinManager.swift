//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoin(coin: CoinModel)
    func didFailWhitError(error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "C13FEBAC-759F-4777-8EFA-E90AA1B9C5F3"
    
    let currencyArray = ["AUD","ARG","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        
        let urlString = "\(baseURL)\(currency)?apiKey=\(apiKey)"
        performRequest(whith: urlString)
    }
    
    
    
    func performRequest(whith urlString:String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWhitError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData){
                        
                        self.delegate?.didUpdateCoin(coin: coin)
                    }
                }
                
             }
            task.resume()
            }
            
        }
    
    func parseJSON(_ coinData: Data) -> CoinModel?{
        
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let coinValue = decodedData.rate
            
            let coin = CoinModel(rateValue: coinValue)
            
            return coin
        } catch{
            return nil
        }
        
        
        
    }
        
}
    




