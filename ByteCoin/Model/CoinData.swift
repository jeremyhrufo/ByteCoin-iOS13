//
//  CoinData.swift
//  ByteCoin
//
//  Created by Jeremy Rufo on 7/29/20.
//

import Foundation

struct CoinData: Codable {
    let time: String?
    let asset_id_base: String?
    let asset_id_quote: String?
    let rate: Double?
}

extension CoinData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        time = (try? container.decodeIfPresent(String.self, forKey: .time)) ?? "2020-07-20T01:01:01.01Z"
        asset_id_base = (try? container.decodeIfPresent(String.self, forKey: .asset_id_base)) ?? ""
        asset_id_quote = (try? container.decodeIfPresent(String.self, forKey: .asset_id_quote)) ?? ""
        rate = (try? container.decodeIfPresent(Double.self, forKey: .rate)) ?? 0.0
    }
}
