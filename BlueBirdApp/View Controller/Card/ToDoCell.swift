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
    @IBOutlet weak var passedDateIndicator: UIView!
    
    func configure(viewModel: ToDoViewModel) {
        
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.dateTime
        descLabel.text = viewModel.desc
        
        
        
        let toDay = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        let date = dateFormatter.date(from:viewModel.dateTime)

        if date ?? Date() < toDay  || date == nil{
            passedDateIndicator.isHidden = false
        } else {
            passedDateIndicator.isHidden = true
        }
            
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
