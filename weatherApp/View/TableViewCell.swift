//
//  TableViewCell.swift
//  weatherApp
//
//  Created by Timur Israilov on 21/01/21.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell {
//    MARK: Variables

    @IBOutlet weak var degreesLabel: UILabel!
   
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


