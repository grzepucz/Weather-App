//
//  SearchLocationTableViewCell.swift
//  PuczekWeather
//
//  Created by Grzegorz Puczkowski on 05/11/2019.
//  Copyright © 2019 Grzegorz Puczkowski. All rights reserved.
//

import UIKit

class SearchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UIView!
    
    let lat: Double? = nil
    let long: Double? = nil
    let city: String? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        appDelegate.location.append(Coordinates(latitude: lat!, longitude: long!, name: city!))
    }

}
