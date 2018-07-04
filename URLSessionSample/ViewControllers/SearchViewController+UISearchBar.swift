//
//  SearchViewController+UISearchBar.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/03.
//  Copyright © 2018年 shiz. All rights reserved.
//

import UIKit

// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
            searchService.getSearchResult(searchWord: searchBar.text!) { results, error in
                
                if let results = results {
                    self.results = results
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPoint.zero, animated: false)
                }
                if !error.isEmpty {
                    print("Search error: \(error)")
                }
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tap)
    }
    
}
