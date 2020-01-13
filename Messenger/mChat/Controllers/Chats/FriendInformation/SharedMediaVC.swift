//
//  SharedMediaVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/2/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class SharedMediaVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var friend: FriendInfo!
    var sharedMedia = [String]()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Shared Media"
        setupCollectionView()
        getSharedMedia()
    }
    
    func getSharedMedia(){
        Database.database().reference().child("messages").child(CurrentUser.uid).child(friend.id).observe(.childAdded) { (snap) in
            guard let values = snap.value as? [String: Any] else { return }
            guard let mediaUrl = values["mediaUrl"] as? String else { return }
            self.sharedMedia.insert(mediaUrl, at: 0)
            self.collectionView.reloadData()
        }
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 4
        let size = view.bounds.width/3 - 3
        layout.itemSize =  CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoresizesSubviews = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(SharedMediaCell.self, forCellWithReuseIdentifier: "sharedMediaCell")
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharedMediaCell", for: indexPath) as! SharedMediaCell
        cell.imageView.loadImage(url: sharedMedia[indexPath.row])
        cell.sharedMediaVC = self
        return cell
    }
    
    func zoomImageHandler(image: UIImageView){
        let _ = SelectedImageView(image, nil, self)
    }
    
}