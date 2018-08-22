//
//  PhotoDetailViewController.swift
//  ExerciseProject
//
//  Created by onur çalışkan on 21.08.2018.
//  Copyright © 2018 InAudio. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var photoDetailImageView: UIImageView!
    var selectedPhoto = PhotosModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentScrollView.delegate = self
        self.photoDetailImageView.sd_setImage(with: URL(string: selectedPhoto.fullImageUrl), placeholderImage: UIImage(named: ""))
        contentScrollView.minimumZoomScale = 1.0
        contentScrollView.maximumZoomScale = 10.0//maximum zoom scale you want
        contentScrollView.zoomScale = 1.0
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoDetailImageView
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhotoDetailViewController : ZoomingViewController
{
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return photoDetailImageView
    }
}
