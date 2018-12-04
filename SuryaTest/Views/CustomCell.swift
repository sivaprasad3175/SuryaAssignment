//
//  customCell.swift
//  SuryaTest
//
//  Created by Siva on 04/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import UIKit
import Kingfisher

class CustomCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mailId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = profileImage.frame.width/2
    }

    var user: User? {
        didSet {
            guard let user = user else {return}
            name.text = (user.firstName ?? "")+" "+(user.lastName ?? "")
            mailId.text = user.emailId
            guard let imageUrl = user.imageUrl else { return  }
            let url = URL(string: imageUrl)
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_pic_placeHolder_icon"))
        }
    }
}
