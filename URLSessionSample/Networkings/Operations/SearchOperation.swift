//
//  SearchOperation.swift
//  URLSessionSample
//
//  Created by stakata on 2018/07/04.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation

final class SearchOperation: AsyncOperation {
    
    typealias SearchResult = ([Track]?, String) -> ()
    
    var errorMessage: String = ""
    var task: URLSessionDataTask?
    let decoder = JSONDecoder()

    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.allowsCellularAccess = false
        return URLSession(configuration: config)
    }()
    
    private let url: URL
    private let completion: SearchResult?
    private var tracks: [Track] = []

    
    init(url: URL, completion: @escaping SearchResult) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {

        task = session.dataTask(with: url) { data, response, error in
            
            defer { self.task = nil }
            
            if let error = error {
                self.errorMessage += "クライアントエラー: \(error.localizedDescription)"
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    self.errorMessage += "サーバエラー"
                    return
            }
            
            if let completion = self.completion {
                self.updateResults(data)
                DispatchQueue.main.async {
                    completion(self.tracks, self.errorMessage)
                }
            }
            self.state = .finished
        }
        task?.resume()
    }
    
    private func updateResults(_ data: Data) {
        do {
            let list = try decoder.decode(TrackList.self, from: data)
            tracks = list.results
        } catch let error as NSError {
            errorMessage += "デコードエラー: \(error.localizedDescription)"
            return
        }
    }
}

