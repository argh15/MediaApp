//
//  MediaViewController.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import UIKit

class MediaViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var layout = UICollectionViewFlowLayout()
    
    private let viewModel: MediaViewModel
    
    @objc dynamic var currentIndex = 0
    var oldAndNewIndices = (0,0)
    
    init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViewModelListeners()
        configureCollectionView()
        viewModel.loadMediaItems()
    }
    
    private func registerViewModelListeners() {
        viewModel.onMediaItemsLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configureCollectionView() {
        
        configureFlowLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .darkGray
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPrefetchingEnabled = false
        
        
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureFlowLayout() {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    private func layoutCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MediaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as! MediaCollectionViewCell
        
        let media = viewModel.mediaItems[indexPath.item]
        cell.configureData(with: media, viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MediaCollectionViewCell {
            oldAndNewIndices.1 = indexPath.item
            currentIndex = indexPath.item
            cell.pause()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MediaCollectionViewCell {
            cell.stop()
        }
    }
}

extension MediaViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let cell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as? MediaCollectionViewCell
        cell?.replay()
    }
}
