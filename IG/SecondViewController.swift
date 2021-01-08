//
//  SecondViewController.swift
//  IG
//
//  Created by Leo on 2021/1/8.
//

import UIKit
import SafariServices
class SecondViewController: UIViewController {
    var secondSaveData  = [Results]()
    var number :Int!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameTwo: UILabel!
    @IBOutlet weak var secondImageView: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upload(data: secondSaveData, item: number)
        // Do any additional setup after loading the view.
    }
    
    func upload(data:[Results],item:Int){
        let itemData = data[item]
        guard let image = UIImage(data: try! Data(contentsOf: itemData.artworkUrl100))else{
            return
        }
        secondImageView.image = image
        artistName.text = "英文：" + itemData.artistName
        releaseDate.text = "下檔日期：" + itemData.releaseDate
        kind.text = itemData.kind
        name.text = "台灣翻譯：" + itemData.name
        nameTwo.text = "分類：" + itemData.genres[0].name
        
       
    }
    @IBAction func showMovie(_ sender: UIButton) {
      
        let controller = SFSafariViewController(url: secondSaveData[number].url)
        present(controller, animated: true, completion: nil)//顯示網址！！
               
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
