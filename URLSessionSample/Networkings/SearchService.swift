//
//  SearchService.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation

final class SearchService {
    
    typealias SearchResult = ([Track]?, String) -> ()
    
    let queue = OperationQueue()
    
    
    func getSearchResult(searchWord: String, completion: @escaping SearchResult) {
                
        queue.cancelAllOperations()
        
        guard var component = URLComponents(string: "https://itunes.apple.com/search") else {
            return
        }
        component.query = "media=music&entity=song&term=\(searchWord)"
        
        guard let url = component.url else {
            return
        }
        
        let op = SearchOperation(url: url) {  tracks, error in
            DispatchQueue.main.async {
                completion(tracks, error)
            }
        }
        queue.addOperation(op)
    }
}




































