//
//  Track.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation

struct Track: Decodable {
    let trackName: String
    let artistName: String
    let previewUrl: String
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case artistName
        case previewUrl
    }
}

extension Track {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let trackName = try container.decode(String.self, forKey: .trackName)
        self.trackName = trackName
        let artistName = try container.decode(String.self, forKey: .artistName)
        self.artistName = artistName
        let previewUrl = try container.decode(String.self, forKey: .previewUrl)
        self.previewUrl = previewUrl
        // URLを取得
        self.url = URL(string: previewUrl)!
    }
}

struct TrackList: Decodable {
    let results: [Track]
}
