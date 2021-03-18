//
//  fiveDaysForecastsTableViewCell.swift
//  WorldWeather
//
//  Created by little tree on 3/17/21.
//

import UIKit

class fiveDaysForecastsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMaximumTemperature: UILabel!
    @IBOutlet weak var lblMinimumTemperature: UILabel!
    @IBOutlet weak var maximumTemperatureIcon: UIImageView!
    @IBOutlet weak var minimumTemperatureIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
