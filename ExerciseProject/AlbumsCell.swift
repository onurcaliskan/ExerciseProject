//
//  AlbumsCell.swift
//  ExerciseProject
//
//  Created by onur çalışkan on 22.08.2018.
//  Copyright © 2018 InAudio. All rights reserved.
//

import UIKit

class AlbumsCell: UICollectionViewCell {
    
    @IBOutlet weak var viewButtonOutlet: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumFirstThumbImageView: UIImageView!
    @IBOutlet weak var albumSecondThumbImageView: UIImageView!
    @IBOutlet weak var albumThirdThumbImageView: UIImageView!
    @IBOutlet weak var albumFourthThumbImageView: UIImageView!
    var addButtonTapAction : (()->())?
    @IBAction func viewAllPhotosClicked(_ sender: Any) {
        addButtonTapAction?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumFirstThumbImageView.layer.cornerRadius = 10
        albumSecondThumbImageView.layer.cornerRadius = 10
        albumThirdThumbImageView.layer.cornerRadius = 10
        albumFourthThumbImageView.layer.cornerRadius = 10
        albumFirstThumbImageView.layer.masksToBounds = true
        albumSecondThumbImageView.layer.masksToBounds = true
        albumThirdThumbImageView.layer.masksToBounds = true
        albumFourthThumbImageView.layer.masksToBounds = true
        viewButtonOutlet.layer.cornerRadius = 10
    
    }
}
