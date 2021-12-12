//
//  ProductListController.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import UIKit
import RealmSwift

class ProductListController: UIViewController {
    private var productListViewModel : ProductListViewModel!
    private var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        productListViewModel = ProductListViewModel()
        productListViewModel.delegate = self
    }

    func addNotificationListnerToProductList () {
        self.notificationToken = self.productListViewModel.productsList.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .none)
                    tableView.endUpdates()
                    // Query results have changed, so apply them to the UITableView
                }
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        })
    }
}


extension ProductListController : ViewModelProtocol {
    
    func retrivedDataFromServer() {
        self.tableView.reloadData()
    }
    
    func retrivedDataFromLocalDatabase() {
//        if notificationToken != nil {
//            self.notificationToken?.invalidate()
//            self.notificationToken = nil
//        }
//        self.addNotificationListnerToProductList()
        self.tableView.reloadData()
    }
    
}


extension ProductListController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productListViewModel == nil || self.productListViewModel.productsList == nil {
            return 0
        }
        return self.productListViewModel.productsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default , reuseIdentifier: "cell")
        cell.textLabel?.text = self.productListViewModel.productsList[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        headerView.backgroundColor = .clear
        label.textAlignment = .left
        label.text = "Products"
        label.font = .boldSystemFont(ofSize: 25)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openUrl(url: URL(string: self.productListViewModel.productsList[indexPath.row].permalink))
    }
    
    
    func openUrl (url : URL?) {
        if url == nil {
            return
        }
        var stringUrl = url!.absoluteString
        let first = String(stringUrl.prefix(5))
        if first.lowercased().contains("http") {
            if first.lowercased() == "https" {
                // nothing should be added containing https
            }
            else{
                // nothing should be added containing http
            }
        }
        else{
            // add https to url
            stringUrl = "https://" + stringUrl
        }
        
        if let mainUrl = URL(string: stringUrl) {
            print("DEBUG : url to go -> \(mainUrl)")
            DispatchQueue.main.async {
                UIApplication.shared.open(mainUrl)
            }
        }
    }
}
