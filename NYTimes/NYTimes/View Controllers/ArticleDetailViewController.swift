//
//  ArticleDetailViewController.swift
//  NYTimes
//
//  Created by Sen Abraham on 3/31/19.
//  Copyright © 2019 Sen Abraham. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    var articleURL: String = ""
    
    @IBOutlet weak var articleWebview: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url : URL = URL.init(string: articleURL){
            self.articleWebview.loadRequest(URLRequest.init(url: url))
        }
        
    }
    
    @IBAction func backArrowButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
