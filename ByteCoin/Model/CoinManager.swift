//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Jeremy Rufo
//  Copyright © 2020 Jeremy H Rufo
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateData(_ coinManager: CoinManager, currency: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?

    private func getBaseURL() -> String {
        return Constants.baseURL + "/"
    }
    
    func getCoinPrice(forCurrency: String) {
        fetchData(basedOn: forCurrency)
    }
    
    /* Fetch bitcoin data based on currency name */
    func fetchData(basedOn: String) {
        var url = getBaseURL() + basedOn + "?"
        url += Constants.apiKey
        performRequest(with: url)
    }
        
    func performRequest(with urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URLSession
            let session = URLSession(configuration: .default)
            
            // Give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                // Check for errors
                if let error = error {
                    delegate?.didFailWithError(error: error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error : HTTP Response Code Error"])
                    delegate?.didFailWithError(error: error)
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error : No Response"])
                    delegate?.didFailWithError(error: error)
                    return
                }

                if let currency = self.parseJSON(data) {
                    delegate?.didUpdateData(self, currency: currency)
                }
            }
            
            // Start the task
            task.resume()
        }
    }
        
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let weather = CoinModel(data: decodedData)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        return nil
    }
}
