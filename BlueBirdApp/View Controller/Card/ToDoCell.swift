//
//  TableViewCell.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 09/03/21.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func configure(viewModel: ToDoViewModel) {
        
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.dateTime
        descLabel.text = viewModel.desc
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
