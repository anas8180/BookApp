//
//  CustomTableViewCell.swift
//  BookApp
//
//  Created by MB Air 11 on 6/13/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var thumbImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
