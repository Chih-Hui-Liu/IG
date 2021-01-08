//
//  FirstCollectionViewController.swift
//  IG
//
//  Created by Leo on 2021/1/6.
//

import UIKit

private let reuseIdentifier = "Cell"
   
class FirstCollectionViewController: UICollectionViewController {
    var finalSaveData  = [Results]()//下載資料存放陣列
    var timer :Timer?
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var titleT: UILabel!
    @IBOutlet weak var updated: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var movieReplace: UIImageView!
    @IBOutlet weak var loadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadActivityIndicatorTwo: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        showView.translatesAutoresizingMaskIntoConstraints = false
        //在所有有繼承自 UIView 的 object 中都會有一個名為 “translatesAutoresizingMaskIntoConstraints”的 property，這 property 的用途是告訴 iOS 自動建立放置位置的約束條件，而第一步是須明確告訴它不要這樣做，因此需設為false。
        collectionView.addSubview(showView) //加進去collectionView當中
        showView.heightAnchor.constraint(equalToConstant: 415).isActive = true
        //設定視圖高度為413
        
        showView.leadingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.leadingAnchor).isActive = true
        showView.trailingAnchor.constraint(equalTo: collectionView.frameLayoutGuide.trailingAnchor).isActive = true
        //設定視圖左右與collectionView左右無間距
        let topConstraint = showView.topAnchor.constraint(equalTo: collectionView.contentLayoutGuide.topAnchor)
        topConstraint.priority = UILayoutPriority(999)
        topConstraint.isActive = true
        // 設定top與contentLayoutGuide top無間距, 並設定Priority為999, 發生衝突時將犧牲此約束條件
        showView.bottomAnchor.constraint(greaterThanOrEqualTo: collectionView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        // 底部要留多少剛好卡住
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return finalSaveData.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FirstCell", for: indexPath) as! FirstCollectionViewCell //轉型自行定義的cell
        let item = finalSaveData[indexPath.item]
        cell.imageView.image = UIImage(data: try! Data(contentsOf: item.artworkUrl100))//讀取圖片
        loadActivityIndicatorTwo.isHidden = true //隱藏loadActivityIndicator
        return cell
    }
    @IBSegueAction func pictureSelect(_ coder: NSCoder) -> SecondViewController? {
        let controller = SecondViewController(coder: coder)
        let item = collectionView.indexPathsForSelectedItems?.first?.item
        controller?.secondSaveData = finalSaveData //丟存放的陣列資料及第幾項
        controller?.number = item!
        return controller
    }
    @objc func movieChange(){
        loadActivityIndicator.isHidden = true
        let number = Int.random(in: 0...39)
        let item = finalSaveData[number]
        movieReplace.image = UIImage(data: try! Data(contentsOf: item.artworkUrl100))//讀取圖片並更換
    }
    
    
    
    func fetchData(){
        loadActivityIndicatorTwo.startAnimating()
        loadActivityIndicator.startAnimating()//等待下載！
        let urlStr = "https://rss.itunes.apple.com/api/v1/tw/movies/top-movies/all/100/explicit.json"
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data{
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    do {
                        let movieData = try decoder.decode(MovieData.self, from: data)
                        self.finalSaveData = movieData.feed.results //解析存在一開始宣告的陣列
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()//加載！
                            self.country.text = "國家：" + movieData.feed.country
                            self.updated.text = "資料跟新時間：" + movieData.feed.updated
                            self.titleT.text = movieData.feed.title + " : 100"
                            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.movieChange), userInfo: nil, repeats: true)
                            self.loadActivityIndicatorTwo.stopAnimating()
                            self.loadActivityIndicator.stopAnimating()
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    
  
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */


}
