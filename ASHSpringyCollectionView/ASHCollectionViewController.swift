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
        
        // Add settings button
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Springy Collection"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
    }
    
    @objc private func showSettings() {
        let settingsVC = SpringSettingsViewController()
        settingsVC.delegate = self
        
        // Get current values from layout
        if let layout = collectionViewLayout as? ASHSpringyCollectionViewFlowLayout {
            settingsVC.currentDamping = layout.springDamping
            settingsVC.currentFrequency = layout.springFrequency
            settingsVC.currentResistance = layout.scrollResistanceDivisor
        }
        
        let navController = UINavigationController(rootViewController: settingsVC)
        navController.modalPresentationStyle = .pageSheet
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.selectedDetentIdentifier = .large
            sheet.prefersGrabberVisible = true
        }
        
        present(navController, animated: true)
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

// MARK: - SpringSettingsDelegate

extension ASHCollectionViewController: SpringSettingsDelegate {
    func settingsDidChange(damping: CGFloat, frequency: CGFloat, resistance: CGFloat) {
        if let layout = collectionViewLayout as? ASHSpringyCollectionViewFlowLayout {
            layout.springDamping = damping
            layout.springFrequency = frequency
            layout.scrollResistanceDivisor = resistance
        }
    }
}