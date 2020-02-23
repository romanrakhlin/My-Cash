//
//  MyTableViewCell.swift
//  My Cash
//
//  Created by Roman Rakhlin on 17.12.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    // UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(title: String, percentage: String) {
        self.titleLabel.text = title
        self.percentageLabel.text = percentage
    }
}
