//
//  Download.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation

class Download: NSObject {
    var url: URL
    var isDownloading = false
    var progress: Float = 0
    
    var task: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: URL) {
        self.url = url
    }
}
