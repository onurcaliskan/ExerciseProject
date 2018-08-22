//
//  PhotosViewController.swift
//  ExerciseProject
//
//  Created by onur çalışkan on 21.08.2018.
//  Copyright © 2018 InAudio. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var selectedAlbum = [AlbumModel]()
    var photosArray = [PhotosModel]()
    var selectedIndexPath : IndexPath!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedAlbum[0].title)
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MyCell")
        self.photosCollectionView!.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
       
        Loader.addLoaderToViews([self.photosCollectionView])

        getPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! PhotosCollectionViewCell
        
        
        cell.photosImageView?.sd_setImage(with: URL(string: photosArray[indexPath.row].fullImageUrl), placeholderImage: UIImage(named: ""))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "photosToDetail", sender: indexPath)

    }
    //This method fetches all photos from selected album.
    func getPhotos() {
        
        do {
            let urlString = "https://jsonplaceholder.typicode.com/photos/?albumId="+String(selectedAlbum[0].id)
            if let url = URL(string: urlString) {
                let urlRequest = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
                
                urlRequest.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error in
                    guard error == nil else {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    do {
                        //create json object from data
                        let root: [[String:Any]] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                        
                        for doc in root {
                            let photosModel: PhotosModel = PhotosModel.init(doc as! [String : Any])
                            self.photosArray.append(photosModel)
                        }
                        DispatchQueue.main.async {
                            self.photosCollectionView.reloadData()
                            self.photosCollectionView.layoutIfNeeded()
                            Loader.removeLoaderFromViews([self.photosCollectionView])
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
        }catch{ }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photosToDetail" {
            if let vc:PhotoDetailViewController = segue.destination as? PhotoDetailViewController {
                vc.selectedPhoto = self.photosArray[(selectedIndexPath.row)]
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// this delegate is for smooth transitioning after selecting a cell.
extension PhotosViewController : ZoomingViewController
{
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView?
    {
        if let indexPath = selectedIndexPath {
            let cell = self.photosCollectionView?.cellForItem(at: indexPath) as! PhotosCollectionViewCell
            return cell.photosImageView
        } else {
            return nil
        }
    }
}
