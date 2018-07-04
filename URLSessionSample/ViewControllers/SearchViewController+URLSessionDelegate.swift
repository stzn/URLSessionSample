//
//  SearchViewController+URLSessionDelegate.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/03.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation
import UIKit

// MARK: URLSessionDownloadDelegate

extension SearchViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        // ダウンロードが完了したのでnil
        downloadService.activeDownloads[sourceURL] = nil
        
        let destinationURL = localFilePath(for: sourceURL)
        
        let manager = FileManager.default
        try? manager.removeItem(at: destinationURL)
        do {
            try manager.copyItem(at: location, to: destinationURL)
        } catch let error {
            print("ファイルコピー失敗: \(error)")
        }
        
        if let index = trackIndex(for: downloadTask) {
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url] {
            
            download.progress = Float(downloadTask.progress.fractionCompleted)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            
            if let trackIndex = trackIndex(for: downloadTask) {
                
                DispatchQueue.main.async {
                    if let trackCell = self.tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? ProgressUpdatable {
                        
                        trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
                    }
                }
            }
        }
    }
    
    private func trackIndex(for task: URLSessionDownloadTask) -> Int? {
        
        guard let url = task.originalRequest?.url else {
            return nil
        }
        let indexedTracks = results.enumerated().filter { $0.1.url == url }
        return indexedTracks.first?.0
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didFinishCollecting metrics: URLSessionTaskMetrics) {
        print(metrics)
    }
}

// MARK: URLSessionTaskDelegate

extension SearchViewController: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "接続エラー", message: "wifiの接続状況を確認してください", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: URLSessionTaskDelegate

extension SearchViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}
