//
//  CustomCollectionViewCell.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/6/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

@objc
protocol CustomCollectionViewCellDelegate {
    @objc optional func custom(cell: CustomCollectionViewCell, didLongPress gesture: UILongPressGestureRecognizer)
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelSubtitle: UILabel!
    
    var delegate: CustomCollectionViewCellDelegate?
    
    override var isSelected: Bool {
        didSet {
            self.gestureRecognizers?.first?.isEnabled = isSelected.inverse //prevents long presses when the cell is pressed while isSelected = true
        }
    }
    
    @objc func longGestureRecognizer(gesture: UILongPressGestureRecognizer) {
        delegate?.custom!(cell: self, didLongPress: gesture)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureRecognizer(gesture:)))
        self.addGestureRecognizer(gesture)
    }
}
