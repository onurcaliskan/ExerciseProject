//
//  AlbumViewController.swift
//  ExerciseProject
//
//  Created by onur çalışkan on 21.08.2018.
//  Copyright © 2018 InAudio. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let limit = 10
    var startsFrom = 0
    var albumArray = [AlbumModel]()
    var selectedAlbum = [AlbumModel]()
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        //starting infinite scrolling for pagination.
        weak var weakSelf = self
        albumCollectionView.addInfiniteScroll { (collectionView) -> Void in
            // finish infinite scroll animation
            weakSelf?.getAlbumList({
                // Finish infinite scroll animations
                self.albumCollectionView.finishInfiniteScroll()
            })
            self.albumCollectionView.finishInfiniteScroll()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let timer = Timer(timeInterval: 0.4, repeats: true) { _ in self.navigationController?.view.layer.removeAnimation(forKey: "maskAnimation") }
        self.albumCollectionView.beginInfiniteScroll(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return self.albumArray.count
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 22
        return CGSize(width: width, height: 180)
    }
    //resizing album collection view item size after rotation.
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
            let layout = albumCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.height - 22
            layout.itemSize = CGSize(width: width - 16, height: 180)
            layout.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
            let layout = albumCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = view.frame.width - 22
            layout.itemSize = CGSize(width: width , height: 180)
            layout.invalidateLayout()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumsCell
        
        //Loading cells asynchronously
        cell.titleLabel?.text = self.albumArray[indexPath.section].title.uppercased()
        cell.albumFirstThumbImageView?.sd_setImage(with: URL(string: albumArray[indexPath.section].albumThumbnails[1]), placeholderImage: UIImage(named: ""))
        cell.albumSecondThumbImageView?.sd_setImage(with: URL(string: albumArray[indexPath.section].albumThumbnails[2]), placeholderImage: UIImage(named: ""))
        cell.albumThirdThumbImageView?.sd_setImage(with: URL(string: albumArray[indexPath.section].albumThumbnails[3]), placeholderImage: UIImage(named: ""))
        cell.albumFourthThumbImageView?.sd_setImage(with: URL(string: albumArray[indexPath.section].albumThumbnails[4]), placeholderImage: UIImage(named: ""))
        
        cell.addButtonTapAction = {
            self.selectedAlbum = [self.albumArray[indexPath.section]]
            self.performSegue(withIdentifier: "albumsToPhotos", sender: self)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
   //this method is for fetching data from server. I didn't want to use Alamofire or JSON Parser, customized my own url request and object&model mapping. Also used pagination just in case.
    func getAlbumList(_ completion: @escaping () -> Void) {
        do {
            if let url = URL(string: "https://jsonplaceholder.typicode.com/albums?_start="+String(self.startsFrom)+"&_limit="+String(self.limit) ) {
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
                        let root: NSArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
                        for doc in root {
                            let _: AlbumModel = AlbumModel.init(doc as! [String : Any]){ (album) in
                                self.getAlbumThumbs(album)
                            }
                        }
                        //incrementing starting point for pagination. Fetch number of n entities at a time.
                        self.startsFrom += self.limit
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
           
        }catch{ }
    }
    // I wanted to add thumbnail future for album list controller. That's why i fetched first four photos' thumbnails from corresponding albums.
    func getAlbumThumbs(_ currentAlbum: AlbumModel) {
        
        do {
            let urlString = "https://jsonplaceholder.typicode.com/photos/?albumId="+String(currentAlbum.id)+"&_limit=4"
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
                            currentAlbum.albumThumbnails.append(doc["thumbnailUrl"] as! String)
                        }
                        DispatchQueue.main.async {
                            self.albumArray.append(currentAlbum)
                            self.albumCollectionView.reloadData()
                            self.albumCollectionView.layoutIfNeeded()
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
        if segue.identifier == "albumsToPhotos" {
            if let vc:PhotosViewController = segue.destination as? PhotosViewController {
                 vc.selectedAlbum = self.selectedAlbum
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

