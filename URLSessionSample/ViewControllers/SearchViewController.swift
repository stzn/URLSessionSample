//
//  SearchViewController.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results: [Track] = []
    let searchService = SearchService()
    let downloadService = DownloadService()
    
    lazy var tap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    lazy var session: URLSession = {
       let config = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: - View controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadService.session = session
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func play(_ track: Track) {
        let playController = AVPlayerViewController()
        present(playController, animated: false, completion: nil)
        let url = localFilePath(for: track.url)
        let player = AVPlayer(url: url)
        playController.player = player
        player.play()
    }
    
    func localFilePath(for url: URL) -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentPath.appendingPathExtension(url.lastPathComponent)
    }
    
    private func localFileExists(for track: Track) -> Bool {
        let url = localFilePath(for: track.url)
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
    }
}

// MARK: TrackCellDelegate

extension SearchViewController: TrackCellDelegate {
    
    // TrackCellDelegateはCellの更新があるためViewControllerで処理をしている
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = results[indexPath.row]
            downloadService.startDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            
        }
    }
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = results[indexPath.row]
            downloadService.pauseDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = results[indexPath.row]
            downloadService.resumeDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            
        }
    }
    
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = results[indexPath.row]
            downloadService.cancelDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            
        }
    }
}


// MARK: UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TrackCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.delegate = self
        
        let track = results[indexPath.row]
        cell.configure(track, download: downloadService.activeDownloads[track.url], downloaded: localFileExists(for: track))
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = results[indexPath.row]
        if localFileExists(for: track) {
            play(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

