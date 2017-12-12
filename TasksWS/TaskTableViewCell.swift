//
//  TaskTableViewCell.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 06/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTaskDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var iconStatus: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
