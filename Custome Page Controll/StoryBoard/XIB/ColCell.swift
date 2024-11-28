//
//  ColCell.swift
//  Custome Page Controll
//
//  Created by Richa Rich on 26/11/24.
//

import UIKit

class ColCell: UICollectionViewCell {

    @IBOutlet weak var imgMain: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with img: UIImage) {
        imgMain.image = img
        }

}
