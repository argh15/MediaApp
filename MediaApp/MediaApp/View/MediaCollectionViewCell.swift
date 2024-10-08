//
//  MediaCollectionViewCell.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import UIKit
import AVFoundation

final class MediaCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MediaCollectionViewCell"
    private let backgroundImage = UIImageView()
    private let likeImageView = UIImageView()
    private let ratingStars = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    //    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var queuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?
    private var playbackLooper: AVPlayerLooper?
    private var isPlaying = false
    var mediaType: MediaType!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stop()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        queuePlayer = nil
        isPlaying = false
    }
    
    private func configureCell() {
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImage)
        
        configureTitleDescriptionView()
        configureRatingView()
        configureLikeButton()
        //        configureActivityIndicator()
        layoutCellUI()
    }
    
    private func configureLikeButton() {
        
        likeImageView.image = UIImage(systemName: "heart.fill")
        likeImageView.tintColor = .white
        likeImageView.contentMode = .scaleAspectFill
        
        likeImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeToggle))
        likeImageView.addGestureRecognizer(tapGesture)
        
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeImageView)
    }
    
    @objc private func likeToggle() {
        print("Like Button Tapped")
    }
    
    private func configureRatingView() {
        ratingStars.axis = .horizontal
        for _ in 1...5 {
            let star = UIImageView(image: UIImage(systemName: "star.fill"))
            star.tintColor = .yellow
            ratingStars.addArrangedSubview(star)
        }
        ratingStars.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStars)
    }
    
    private func configureTitleDescriptionView() {
        titleLabel.text = "Title Text"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 24)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        descriptionLabel.text = "This is the description of the video/image. Keeping it a little long to test multiline label view."
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
    }
    
    //    private func configureActivityIndicator() {
    //        activityIndicator.hidesWhenStopped = true
    //        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    //
    //        contentView.addSubview(activityIndicator)
    //    }
    
    private func layoutCellUI() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            //            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            //            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            ratingStars.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            ratingStars.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            likeImageView.widthAnchor.constraint(equalToConstant: 48),
            likeImageView.heightAnchor.constraint(equalTo: likeImageView.widthAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            likeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    func configureData(with media: Media, viewModel: MediaViewModel) {
        
        titleLabel.text = media.title
        descriptionLabel.text = media.description
        
        mediaType = media.mediaType
        
        switch media.mediaType {
        case .photo:
//            backgroundImage.image = nil
            setupImage(urlString: media.mediaURL, viewModel: viewModel)
        case .video:
            setupVideo(urlString: media.mediaURL)
        }
        
        ratingStars.arrangedSubviews.enumerated().forEach { (index, star) in
            if let starImageView = star as? UIImageView {
                starImageView.image = starImage(for: index, rating: media.rating)
            }
        }
        
        likeImageView.image = media.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    private func setupImage(urlString: String, viewModel: MediaViewModel) {
        backgroundImage.image = nil
        //        activityIndicator.startAnimating()
        
        Task {
            do {
                let image = try await viewModel.loadImage(urlString: urlString)
                DispatchQueue.main.async { [weak self] in
                    self?.backgroundImage.image = image
                }
            } catch let error as CustomError {
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.backgroundImage.image = nil
                }
            }
            //            DispatchQueue.main.async { [weak self] in
            //                self?.activityIndicator.stopAnimating()
            //            }
        }
    }
    
    private func starImage(for index: Int, rating: Double) -> UIImage? {
        // + 1 because rating starts from 1
        if Double(index + 1) < rating {
            return UIImage(systemName: "star.fill")
        } else if Double(index) < rating.rounded(.down) + 1.0 && rating.truncatingRemainder(dividingBy: 1.0) >= 0.5 {
            return UIImage(systemName: "star.lefthalf.fill")
        } else {
            return UIImage(systemName: "star")
        }
    }
    
    private func setupVideo(urlString: String) {
        guard let videoURL = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: videoURL)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        
        guard let playerLayer = playerLayer,
              let queuePlayer = queuePlayer
        else { return }
        
        playbackLooper = AVPlayerLooper.init(player: queuePlayer, templateItem: playerItem)
        
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = contentView.bounds
        backgroundImage.layer.insertSublayer(playerLayer, at: 0)
        queuePlayer.play()
        isPlaying = true
    }
    
    func replay() {
        if !isPlaying {
            queuePlayer?.seek(to: .zero)
            queuePlayer?.play()
            play()
        }
    }
    
    func play() {
        if !isPlaying {
            queuePlayer?.play()
            isPlaying = true
        }
    }
    
    func pause() {
        if isPlaying {
            queuePlayer?.pause()
            isPlaying = false
        }
    }
    
    func stop() {
//        if mediaType == .video {
            queuePlayer?.pause()
            queuePlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
//        }
    }
}
