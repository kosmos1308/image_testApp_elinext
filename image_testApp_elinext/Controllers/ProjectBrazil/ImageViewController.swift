//
//  ImageViewController.swift
//  image_testApp_elinext
//
//  Created by pavel on 16.07.21.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let spacing: CGFloat = 2
    private let cellIdentifier = "cell"
    
    var arrayImages: [String] = []
    var image = Image(file: "loader")
    
    var timer = Timer()
    let networkService = NetworkService()
    let urlString = "https://loremflickr.com/json/g/320/240/brazil,rio/all"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer() //start timer
        showCollectionView()
        
        navigationItem.title = "Images"
    }
    
    
    func showCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    // MARK: - start Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAll), userInfo: nil, repeats: true)
    }
    
    
    // MARK: - request network service, update collectionView
    @objc func updateAll() {
        networkService.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let nameImage):
                self?.image.file = nameImage.file
                self?.appendItemsInArray() //add 140 elements to an array
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @objc func updateWhenAddOneImage() {
        networkService.request(urlString: urlString) { [weak self] (result) in
            switch result {
            case .success(let nameImage):
                self?.image.file = nameImage.file
                self?.appendOneItemInArray() //add one element to an array
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - the methods that add elements to an array
    // adds 140 images to an array
    func appendItemsInArray() {
        if arrayImages.count == 140 {
            timer.invalidate()
        } else {
            arrayImages.append(image.file) // add 140 images in array
        }
    }
    
    // adds one image to an array
    func appendOneItemInArray() {
        if arrayImages.last == image.file {
            updateWhenAddOneImage()
            timer.invalidate()
        } else {
            arrayImages.append(image.file)
            timer.invalidate() // stop Timer
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        let selectedItem = arrayImages[index.item]
        if segue.identifier == "detail" {
            guard let destinationVC = segue.destination as? DetailViewController else {
                return
            }
            destinationVC.selectedImage = selectedItem
        }
    }
    
    // MARK: - click "+" and "refresh" (add a new image to collectionView, refresh new images)
    @IBAction func clickAddBarButtonItem(_ sender: UIBarButtonItem) {
        appendOneItemInArray()
        let indexPath = IndexPath(row: arrayImages.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    
    @IBAction func clickRefreshBarButtonItem(_ sender: UIBarButtonItem) {
        arrayImages.removeAll()
        startTimer()
        collectionView.reloadData()
    }
}


// MARK: - extension CollectionView
extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell
        //cell.backgroundColor = .red
        cell.layer.cornerRadius = 7
        cell.imageView.contentMode = .scaleAspectFill
        let currentImageUrl = arrayImages[indexPath.item]
        guard let url = URL(string: currentImageUrl) else {
            return cell
        }
        cell.imageView.sd_setImage(with: url, completed: nil)
        cell.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "loader"), options: .continueInBackground, context: nil)
        
       
        return cell
    }
    
    
    // size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.bounds.size.width/5) - spacing, height: (collectionView.bounds.size.height/11) + spacing)
    }
   
    
   // the sizes between cells (top, left, bottom, right)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: spacing/2, left: spacing/2, bottom: spacing/2, right: spacing/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = arrayImages[indexPath.item]
        self.performSegue(withIdentifier: "detail", sender: selectedImage)
    }
}
