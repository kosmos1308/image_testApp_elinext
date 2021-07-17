//
//  ViewController.swift
//  image_testApp_elinext
//
//  Created by pavel on 13.07.21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let cellIdentifier = "cell" //identifier
    private let spacing: CGFloat = 2    //between images - pt 2
    
    var images = [Data]()
    let urlString = "https://loremflickr.com/200/200/" // url string
    var timer = Timer()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        showCollectionView()
        startTimer()
    }

    
    // MARK: - collectionView delegate, dataSource, paginEnabled, layout
    func showCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        layout.sectionInset = UIEdgeInsets(top: spacing/2, left: spacing/2, bottom: spacing/2, right: spacing/2)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    
    // MARK: - start timer, get data, appends 140 elements to an array
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
    }
  
    
    @objc func getData() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                if self.images.count != 140 {
                    self.images.append(data)
                    self.collectionView.reloadData()
                } else if self.images.count == 140 {
                    self.timer.invalidate()
                    self.collectionView.reloadData()
                    print(self.images.count)
                }
            }
        }.resume()
    }
    
    
    // MARK: - get data and append 1 element to an array
    func getOneImage() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                if self.images.count != 0 {
                    self.images.append(data)
                }
            }
        }.resume()
    }

    
    // MARK: - "Add" and "Reload" buttons
    @IBAction func reloadButton(_ sender: UIBarButtonItem) {
        images.removeAll()
        startTimer()
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: images.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
        getOneImage()
        collectionView.reloadData()
    }
}


// MARK: - extensions CollectionView
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.layer.cornerRadius = 7
        
        let currentData = images[indexPath.item]
        cell.imageView.image = UIImage(data: currentData)
        cell.imageView.contentMode = .scaleToFill
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.size.width/5) - spacing, height: (collectionView.bounds.size.height/11) + spacing)
    }
}
