//
//  CustomTableViewCell.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/17/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelCaption: UILabel!
    @IBOutlet weak var labelCaption2: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var refreshTimer: UIKit.Timer? {
        didSet {
            refreshTimer?.fire()
        }
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UITableView {
    func dequeueReusableCustomCell(withIdentifier identifier: String, for indexPath: IndexPath) -> CustomTableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomTableViewCell
    }
    
    func customCellForRow(at indexPath: IndexPath) -> CustomTableViewCell? {
        return self.cellForRow(at: indexPath) as! CustomTableViewCell?
    }
}
