//
//  ViewController.swift
//  InfinteScrolling
//
//  Created by Nishant Sharma on 1/9/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

extension Date {
    func dateFromDays(_ days: Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: PagingTableView!
    
    let cellHeight: CGFloat = 44
    
    let dateFormatter = DateFormatter()
    var start = 0
    let daysToAdd = 30
    let margin = 10
    let cellBuffer: CGFloat = 2
    var newsViewModel: NewsMainViewModel?
    var queryStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.pagingDelegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}
extension ViewController: PagingTableViewDelegate {
    func didPaginate(_ tableView: PagingTableView, to page: Int) {
        
    }
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
        self.tableView.isLoading = true
        newsViewModel?.loadData(at: page, withQuery: queryStr) { contents in
            self.newsViewModel?.newsData.append(contentsOf: contents)
            self.tableView.isLoading = false
        }
    }
    
    
}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel?.newsData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) 
        cell.textLabel?.numberOfLines = 0
        cell.textLabel!.text = newsViewModel?.newsData[(indexPath as NSIndexPath).row].title ?? ""
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
}


extension ViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true == true {
            queryStr = ""
        }else{
            queryStr = searchBar.text ?? ""
        }
        self.reloadSearchedData()
        searchBar.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        queryStr = ""
        self.reloadSearchedData()
        searchBar.text =  ""
        searchBar.endEditing(true)
    }
   
    func reloadSearchedData() {
        self.tableView.isLoading = true
        self.tableView.reset()
        newsViewModel?.loadData(at: 0, withQuery: queryStr) { contents in
            self.newsViewModel?.newsData.removeAll()        
            self.newsViewModel?.newsData.append(contentsOf: contents)
            self.tableView.isLoading = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

