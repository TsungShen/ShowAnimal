//
//  AnimalTableViewCell.swift
//  ShowAnimal
//
//  Created by 呂宗昇 on 2018/8/2.
//  Copyright © 2018年 TSL. All rights reserved.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var animalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
