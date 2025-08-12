//
//  ASHCollectionViewController.swift
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

import UIKit

class ASHCollectionViewController: UICollectionViewController {
    
    private static let CellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ASHCollectionViewController.CellIdentifier)
        self.collectionView.backgroundColor = UIColor.white
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ASHCollectionViewController.CellIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.orange
        
        return cell
    }
}