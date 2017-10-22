//
//  CustomTableViewCell.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

@objc
protocol CustomTableViewCellDelegate {
    @objc optional func customCell(_ cell: CustomTableViewCell, switchDidChange switcher: UISwitch)
}

class CustomTableViewCell: UITableViewCell {

    var delegate: CustomTableViewCellDelegate?

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

    @IBOutlet weak var switcher: UISwitch!
    @IBAction func switchDidChange(_ sender: UISwitch) {
        delegate?.customCell!(self, switchDidChange: sender)
    }

    @IBOutlet weak var imageViewPrefix: UIImageView!

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
