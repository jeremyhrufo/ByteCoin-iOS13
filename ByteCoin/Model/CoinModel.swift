//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Jeremy Rufo on 7/29/20.
//

import Foundation

struct CoinModel {
    let time: String?
    let asset_id_base: String?
    let asset_id_quote: String?
    let rate: Double?
    
    init(data: CoinData) {
        self.time = data.time
        self.asset_id_base = data.asset_id_base
        self.asset_id_quote = data.asset_id_quote
        self.rate = data.rate
    }
}
