//
//  ProgressUpdatable.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import Foundation

protocol ProgressUpdatable {
    func updateDisplay(progress: Float, totalSize : String);
}
