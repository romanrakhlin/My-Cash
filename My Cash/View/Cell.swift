//
//  Cell.swift
//  My Cash
//
//  Created by Roman Rakhlin on 08.10.2019.
//  Copyright © 2019 Roman Rakhlin. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!    
    @IBOutlet var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
