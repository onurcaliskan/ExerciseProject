//
//  PhotosModel.swift
//  ExerciseProject
//
//  Created by onur çalışkan on 21.08.2018.
//  Copyright © 2018 InAudio. All rights reserved.
//

import UIKit

class PhotosModel {
   
    var fullImageUrl: String
    var thumbnailUrl: String
    
    //doing object mapping here from dictionary.
    init(_ dictionary: [String: Any]) {
        self.fullImageUrl = dictionary["url"] as? String ?? ""
        self.thumbnailUrl = dictionary["thumbnailUrl"] as? String ?? ""
    
    }
    init() {
        self.fullImageUrl = ""
        self.thumbnailUrl = ""
    }
}
