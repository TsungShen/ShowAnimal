//
//  InfoViewController.swift
//  ShowAnimal
//
//  Created by 呂宗昇 on 2018/8/13.
//  Copyright © 2018年 TSL. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var animalNameFromTableView:String?
    var locationFromTableView: String?
    var distributionFromTableView:String?
    var pictureFromTableView:String?
    var detailTableViewController: DetailTableViewController?
    let urlSession = URLSession(configuration: .default)
    @IBOutlet weak var animalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableViewController?.locationlabel.text = locationFromTableView
        detailTableViewController?.distributionLabel.text = distributionFromTableView
        
        if let imageAddress = pictureFromTableView{
            if let imageURL = URL(string: imageAddress){
                let task = urlSession.downloadTask(with: imageURL, completionHandler: {
                    (url,response,error) in
                    if error != nil{
                        DispatchQueue.main.async {
                            self.popAlert(withTittle: "Sorry")
                        }
                        return
                    }
                    if let okURL = url{
                        do{
                            let downloadImage = UIImage(data: try Data(contentsOf: okURL))
                            DispatchQueue.main.async {
                                self.animalImage.image = downloadImage
                            }
                        }catch{
                            DispatchQueue.main.async {
                                self.popAlert(withTittle: "Sorry")
                            }
                        }
                    }
                })
                task.resume()
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    func popAlert(withTittle title:String){
        let alert = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            detailTableViewController = segue.destination as? DetailTableViewController
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
