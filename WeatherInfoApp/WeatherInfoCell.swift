//
//  WeatherInfoCell.swift
//  WeatherInfo
//
//  Created by Vinay Kumar on 21/11/19.
//  Copyright © 2019 Vinay Kumar. All rights reserved.
//

import UIKit

class WeatherInfoCell: UITableViewCell {

    @IBOutlet var name : UILabel?
    @IBOutlet var temperature : UILabel?
    @IBOutlet var windSpeed : UILabel?
    @IBOutlet var humidity : UILabel?
    @IBOutlet var clouds : UILabel?
    @IBOutlet var pressure : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

