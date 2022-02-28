//
//  UserTableViewCell.swift
//  LentItChat
//
//  Created by macbook on 28/2/2565 BE.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet var userText: UILabel!
    static let identifield = "userCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(text: String) {
        userText.text = text
    }

}
