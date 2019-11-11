//
//  CityShortTableViewCell.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 05/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit

class CityShortTableViewCell: UITableViewCell {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
