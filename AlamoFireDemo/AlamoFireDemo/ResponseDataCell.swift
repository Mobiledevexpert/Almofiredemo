//
//  ResponseDataCell.swift
//  AlamoFireDemo
//
//  Created by Harry PC on 3/20/17.
//  Copyright © 2017 Harry. All rights reserved.
//

import UIKit

class ResponseDataCell: UITableViewCell {

    @IBOutlet var viewMain: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
