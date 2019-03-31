//
//  NewsArticlesListViewController.swift
//  NYTimes
//
//  Created by Sen Abraham on 3/31/19.
//  Copyright © 2019 Sen Abraham. All rights reserved.
//

import UIKit
import Alamofire

class NewsArticlesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var newsArticleTableView: UITableView!
    var articleArry = NSArray()
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var filteredArray   =   NSArray()
    
    var isSearchingKeyword  =   false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsArticleTableView.delegate   =   self
        newsArticleTableView.dataSource =   self
        
        searchTextfield.delegate        =   self
        
        newsArticleTableView.tableFooterView    =   nil
//        newsArticleTableView.separatorColor     =   UIColor.clear
        
        self.searchHideUnhide(isSearching:false)
        
        newsArticleTableView.reloadData()
        
        self.callNewsArticleListRequests(countValue: "1")
    }
    
    // DropDown
    
    func callOptionsDropDownAlert() {
        let alertController = UIAlertController(title: "Choose", message: "Fetch articles from NY Times for.", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Today", style: .default) { (action:UIAlertAction) in
            self.callNewsArticleListRequests(countValue: "1")
        }
        
        let action2 = UIAlertAction(title: "This Week", style: .default) { (action:UIAlertAction) in
            self.callNewsArticleListRequests(countValue: "7")
        }
        
        let action3 = UIAlertAction(title: "This Month", style: .default) { (action:UIAlertAction) in
            self.callNewsArticleListRequests(countValue: "30")
        }
        let action4 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in

        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func searchHideUnhide(isSearching:Bool) {
        if isSearching {
            self.searchTextfield.isHidden   =   false
            isSearchingKeyword  =   true
            searchTextfield.becomeFirstResponder()
            searchButton.isSelected  =   true
        }
        else{
            self.searchTextfield.isHidden   =   true
            isSearchingKeyword  =   false
            searchTextfield.resignFirstResponder()
            searchButton.isSelected  =   false
        }
    }
    
    func searchResultsBasedOnKeyword(searchText:String) {
        let resultPredicate = NSPredicate(format: "title contains[c] %@", searchText)
        filteredArray = self.articleArry.filter { resultPredicate.evaluate(with: $0) } as NSArray;
//        print("Request:\(filteredArray)")
        newsArticleTableView.reloadData()

    }
    
    //MARK: - Request Response
    
    func callNewsArticleListRequests(countValue:String) {
        
        
        let requeststring = String(format: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/%@.json?api-key=2QNT75wrN75APoNtAkyGOZoxwQB6uAYd", countValue)


//        let requeststring   =   "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/1.json?api-key=2QNT75wrN75APoNtAkyGOZoxwQB6uAYd"
        
        Alamofire.request(requeststring) .responseJSON { response in
            print("Request:\(String(describing: response.request))")
            
            if let value = response.value as? [String: AnyObject] {
                self.articleArry = (value["results"] as? NSArray)!

                print(value)
                self.newsArticleTableView.reloadData()
            }
            

        }
        
        
    }
    
    //MARK: - TableView Deleagtae
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if isSearchingKeyword{
            return self.filteredArray.count
        }

        return self.articleArry.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 110;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsArticleTableViewCell", for: indexPath) as! NewsArticleTableViewCell
        
        
        cell.articleImageView.backgroundColor   =   UIColor.darkGray
        cell.articleImageView.layer.cornerRadius    = 25.0
        
        var articleDict: NSDictionary = self.articleArry[indexPath.row] as! NSDictionary
        if isSearchingKeyword{
            articleDict = self.filteredArray[indexPath.row] as! NSDictionary
        }
        
        cell.articleTitleLabel.text =   articleDict.value(forKey: "title") as? String
        cell.aritcleNameLabel.text =   articleDict.value(forKey: "byline") as? String
        cell.articleDateLabel.text =   articleDict.value(forKey: "published_date") as? String



        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let contentVC:ArticleDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        
        var articleDict: NSDictionary = self.articleArry[indexPath.row] as! NSDictionary
        if isSearchingKeyword{
            articleDict = self.filteredArray[indexPath.row] as! NSDictionary
        }
        
        contentVC.articleURL    =   articleDict["url"] as! String
        self.navigationController?.pushViewController(contentVC, animated: true)

    }
    
    
    
    //MARK: - textfield Deleagtae

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            if (updatedText.count == 0){
                filteredArray = self.articleArry
                newsArticleTableView.reloadData()
                return true;

            }
            
            self.searchResultsBasedOnKeyword(searchText: updatedText)
        }
        return true;
    }
    
    //MARK: - button clicks

    @IBAction func optionsButtonClicked(_ sender: UIButton) {
        self.searchHideUnhide(isSearching:false)
        self.callOptionsDropDownAlert()
    }
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if isSearchingKeyword {
            self.searchHideUnhide(isSearching:false)
        }
        else{
            self.searchHideUnhide(isSearching:true)
        }

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
