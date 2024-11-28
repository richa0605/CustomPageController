//
//  ViewController.swift
//  Custome Page Controll
//
//  Created by Richa Rich on 21/11/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var colImage: UICollectionView!
    @IBOutlet weak var vwPc: RKPageControl!
    
    var arr = [UIImage(named: "img-1"), UIImage(named: "img-2"), UIImage(named: "img-3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the NIB for UICollectionViewCell
        let nib = UINib(nibName: "ColCell", bundle: nil)
        colImage.register(nib, forCellWithReuseIdentifier: "ColCell")
        
        // Set up the UICollectionView
        colImage.dataSource = self
        colImage.delegate = self
        colImage.isPagingEnabled = true
        
        // Set up the Page Control
        vwPc.numberOfPages = arr.count // Set total pages here (example: 5)
        vwPc.currentPage = 0
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count // Number of pages/items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColCell", for: indexPath) as! ColCell
        // Configure your cell
        cell.configure(with: arr[indexPath.row]!)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return full size of the collection view to enable paging
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // MARK: - UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate current page and update page control
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        vwPc.currentPage = page
    }
}
