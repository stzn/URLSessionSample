//
//  TrackCell.swift
//  URLSessionSample
//
//  Created by shiz on 2018/07/02.
//  Copyright © 2018年 shiz. All rights reserved.
//

import UIKit

protocol TrackCellDelegate: class {
    func downloadTapped(_ cell: TrackCell)
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
    func cancelTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {

    weak var delegate: TrackCellDelegate? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var downloadingStackView: UIStackView!
    @IBOutlet weak var notDownloadingView: UIView!
    @IBOutlet weak var pauseButton: UIButton!

    @IBAction func downloadTapped(_ sender: UIButton) {
        delegate?.downloadTapped(self)
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Pause" {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    func configure(_ track: Track, download: Download?, downloaded: Bool) {
        titleLabel.text = track.trackName
        artistLabel.text = track.artistName
        
        var showDownloadingControls: Bool = false
        if let download = download {
            showDownloadingControls = true
            
            progressLabel.text = download.isDownloading ? "Downloading..." : "Paused"
            progressView.progress = download.progress
            
            let title = download.isDownloading ? "Pause" : "Resume"
            pauseButton.setTitle(title, for: .normal)
        }

        progressLabel.isHidden = !showDownloadingControls
        progressView.isHidden = !showDownloadingControls
        downloadingStackView.isHidden = !showDownloadingControls
        
        notDownloadingView.isHidden = downloaded || showDownloadingControls
        
        selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none

    }
}

// MARK: ProgressUpdatable
extension TrackCell: ProgressUpdatable {
    func updateDisplay(progress: Float, totalSize: String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}



















