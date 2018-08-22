//
//  AlbumModel.swift
//  ExerciseProject
//
//  Created by onur çalışkan on 21.08.2018.
//  Copyright © 2018 InAudio. All rights reserved.
//

import UIKit

class AlbumModel {
    
    var id: Int
    var title: String
    var albumThumbnails: [String]
    
    //doing object mapping here from dictionary.
    init(_ dictionary: [String: Any],completion: @escaping (AlbumModel) -> ()) {
        self.id = dictionary["id"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.albumThumbnails = [""]
        completion(self)
    }
}
