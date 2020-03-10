//
//  ImagesListCollectionViewController.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 0.29 * UIScreen.main.bounds.width, height: 160)
        
        let myCollectionView: UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        myCollectionView.backgroundColor = .white
        return myCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        DispatchQueue.main.async {
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
        }
    }
}
extension ImagesListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
    
}
struct PhotoListViewModelCell {
    let imageUrl: URL
    let descText: String
    let id: Int
}
