//
//  UserTableViewCell.swift
//  DiffableDataSourceSampleProject
//
//  Created by Denys Danyliuk on 04.03.2021.
//

import UIKit

final class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        selectionStyle = .none
    }
    
    func configure(with user: User) {
        
        nameLabel.text = user.name
        ageLabel.text = "\(user.age)"
    }
}
