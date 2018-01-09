//
//  ToDoTableViewCell.swift
//  MAXM
//
//  Created by Max on 07.01.18.
//  Copyright © 2018 Max. All rights reserved.
//

import UIKit

protocol ToDoCellDelegate {
    func didRequestToggle (_ cell:ToDoTableViewCell)
    func didRequestDelete (_ cell:ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoCheckbox: BEMCheckBox!
    
    var delegate:ToDoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBAction func toggleTodo(_ sender: Any) {
        if let delegateObject = self.delegate {
            delegateObject.didRequestToggle(self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
