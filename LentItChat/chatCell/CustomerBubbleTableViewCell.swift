//
//  CustomerBubbleTableViewCell.swift
//  LentItChat
//
//  Created by macbook on 28/2/2565 BE.
//

import UIKit

class CustomerBubbleTableViewCell: UITableViewCell {

    @IBOutlet var chatText: UILabel!
    static let identifield = "customerCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
