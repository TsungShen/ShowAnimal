//
//  AnimalTableViewController.swift
//  ShowAnimal
//
//  Created by 呂宗昇 on 2018/8/2.
//  Copyright © 2018年 TSL. All rights reserved.
//

import UIKit

struct Animal{
    var name: String
    var location: String
    var distribution:String
    var picture:String
}

struct JsonData: Decodable {
    var result: JsonAnimal
}
struct JsonAnimal: Decodable {
    var count: Double
    var limit: Double
    var results: [Result]
}
struct Result: Decodable {
    var _id: String
    var A_Name_Ch: String
    var A_Location: String
    var A_Distribution: String
    var A_Pic01_URL: String
}

class AnimalTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
//    let animalArray1 = ["cat","chicken","dog","elephant","fox","goat","kangaroo","monkey","mouse","penguin","rabbit","snail"]
    var shouldShowSearchResults = false
    var animalArray:Array = [String?]()
    var object:Array = [Animal]()
    var searchArray:Array = [String]()
    
    //make searchTool
    var searchController:UISearchController?
    var searchResults:Array = [Animal]()
    
//    let apiAddress = "https://randomuser.me/api"
    let apiAddress = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613&limit=200"
    let urlSession = URLSession(configuration: .default)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadInfo(withAddress: apiAddress)
        configureSearchController()
    }

    func downloadInfo(withAddress webAddress:String){
        if let url = URL(string: webAddress){
            let task = urlSession.dataTask(with: url, completionHandler: {
                (data,response,error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async {
                            self.popAlert(withTittle: "No Interent connection")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.popAlert(withTittle: "Something Error")
                        }
                    }
                    
                    return
                }
                if let loadedData = data{
//                    print(loadedData)
                    do{
                        let okData = try JSONDecoder().decode(JsonData.self, from: loadedData)
                        
                        for i in 0...Int(okData.result.limit) - 1 {
                            let animalName = okData.result.results[i].A_Name_Ch
                            let animalLocation = okData.result.results[i].A_Location
                            let animalDistribution = okData.result.results[i].A_Distribution
                            let animalPicture = okData.result.results[i].A_Pic01_URL
                            
                            let aAnimal = Animal(name: animalName, location: animalLocation, distribution: animalDistribution, picture: animalPicture)
                            self.object.append(aAnimal)
//                            self.searchArray.append(animalName)
                        }
                        print(self.object.count)
                        print(self.object)
//                        print(self.searchArray)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }catch{
                        DispatchQueue.main.async {
                            self.popAlert(withTittle: "Something Error")
                        }
                        
                    }
                }
            })
            task.resume()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return animalArray1.count
        if shouldShowSearchResults == false{
            return object.count
        }else if shouldShowSearchResults == true{
            return (searchResults.count)
        }else{
            return object.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as? AnimalTableViewCell
        if shouldShowSearchResults == false{
            cell?.animalLabel.text = object[indexPath.row].name
        }else if shouldShowSearchResults == true{
            cell?.animalLabel.text = searchResults[indexPath.row].name
        }
        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo"{
            if let dvc = segue.destination as? InfoViewController{
                if let selectRow = tableView.indexPathForSelectedRow?.row{
                    if shouldShowSearchResults == false{
                    dvc.animalNameFromTableView = object[selectRow].name
                    dvc.locationFromTableView = object[selectRow].location
                    dvc.distributionFromTableView = object[selectRow].distribution
                    dvc.pictureFromTableView = object[selectRow].picture
                    dvc.navigationItem.title = object[selectRow].name
                    }else if shouldShowSearchResults == true{
                        dvc.animalNameFromTableView = searchResults[selectRow].name
                        dvc.locationFromTableView = searchResults[selectRow].location
                        dvc.distributionFromTableView = searchResults[selectRow].distribution
                        dvc.pictureFromTableView = searchResults[selectRow].picture
                        dvc.navigationItem.title = searchResults[selectRow].name
                    }
                }
            }
        }
    }
    
    func popAlert(withTittle title:String){
        let alert = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
//    func filterContent(for searchText: String){
//        searchResults = searchArray.filter({
//            (searchResult) -> Bool in
////             let name = searchResult.localizedCaseInsensitiveContains(searchText)
//                let isMatch = searchResult.localizedCaseInsensitiveContains(searchText)
//                return isMatch
//
//        })
//    }
    
    
    
    func configureSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        searchController?.searchBar.placeholder = "輸入您想找的動物"
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController?.searchBar
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults{
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        searchController?.searchBar.resignFirstResponder()
    }
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else {
//            return
//        }
//        print("keyWord: \(searchText)")
//        searchResults = searchArray.filter({
//            (animal) -> Bool in
//            let animalText = animal
//            let isMatch = animalText.localizedCaseInsensitiveContains(searchText)
//            return isMatch
//        })
//
//    }
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
            }
            print("keyWord: \(searchText)")
            searchResults = object.filter({
                (animal) -> Bool in
                let animalText = animal.name
                let isMatch = animalText.localizedCaseInsensitiveContains(searchText)
                return isMatch
            })
            print(searchResults)
        }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInfo", sender: nil)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
