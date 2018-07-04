//
//  DownloadService.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation

final class DownloadService {
    
    var session: URLSession!
    var activeDownloads: [URL: Download] = [:]
    
    // ダウンロード開始処理
    func startDownload(_ track: Track) {
        
        let download = Download(url: track.url)
        download.task = session.downloadTask(with: track.url)
        download.task!.resume()
        download.isDownloading = true
        activeDownloads[download.url] = download
    }
    
    // 一時停止処理
    func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.url] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in
                // ここで途中までダウンロードしていたデータを保持しておく
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    // キャンセル処理
    func cancelDownload(_ track: Track) {
        if let download = activeDownloads[track.url] {
            download.task?.cancel()
            activeDownloads[track.url] = nil
        }
    }
    
    // ダウンロード再開処理
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.url] else { return }
        
        // pause時に保存していたresumeDataがある場合はそこから続きのダウンロードを行う
        if let resumeData = download.resumeData {
            download.task = session.downloadTask(withResumeData: resumeData)
            download.task!.resume()
            download.isDownloading = true
        } else {
            download.task = session.downloadTask(with: download.url)
            download.task!.resume()
            download.isDownloading = true
        }
    }
}
