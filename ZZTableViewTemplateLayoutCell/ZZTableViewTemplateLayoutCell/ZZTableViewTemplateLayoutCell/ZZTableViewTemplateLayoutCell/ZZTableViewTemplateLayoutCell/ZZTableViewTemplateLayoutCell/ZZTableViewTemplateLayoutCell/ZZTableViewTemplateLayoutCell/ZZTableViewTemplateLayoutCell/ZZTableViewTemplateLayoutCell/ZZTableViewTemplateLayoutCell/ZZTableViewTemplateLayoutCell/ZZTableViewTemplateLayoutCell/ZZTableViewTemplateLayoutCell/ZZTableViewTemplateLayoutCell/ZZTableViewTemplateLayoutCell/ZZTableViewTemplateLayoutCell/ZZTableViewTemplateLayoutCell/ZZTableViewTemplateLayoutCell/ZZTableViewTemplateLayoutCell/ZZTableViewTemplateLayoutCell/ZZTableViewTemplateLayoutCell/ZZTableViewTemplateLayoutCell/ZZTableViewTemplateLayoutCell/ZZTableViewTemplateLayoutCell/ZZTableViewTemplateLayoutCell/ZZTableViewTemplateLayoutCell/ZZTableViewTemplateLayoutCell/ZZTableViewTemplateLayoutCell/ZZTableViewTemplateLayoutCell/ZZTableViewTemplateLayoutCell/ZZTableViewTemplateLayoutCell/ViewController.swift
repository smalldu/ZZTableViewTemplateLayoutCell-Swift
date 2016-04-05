//
//  ViewController.swift
//  ZZTableViewTemplateLayoutCell
//
//  Created by duzhe on 16/4/4.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var entitys:[ZZFeedEntity] = []
    var feedEntitySections:[[ZZFeedEntity]] = [[]]
    var cellHeightCacheEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200
        self.tableView.zz_debugLogEnabled = true
        
        self.buildTestDataThen { () -> () in
            
            self.feedEntitySections[0] = self.entitys
            self.tableView.reloadData()
            
        }
    }

    @IBAction func shouldCache(sender: UISwitch) {
        cellHeightCacheEnabled = sender.on
    }
    
    func buildTestDataThen(finish:(()->())?){
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            guard let dataFilePath = NSBundle.mainBundle().pathForResource("data", ofType: "json") else {return}
            guard let data = NSData(contentsOfFile: dataFilePath) else { return }
            var rootDict:NSDictionary!
            do{
            
                rootDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                
            }catch let err{
                print(err)
            }
            let feedDicts = rootDict["feed"] as! [NSDictionary]
            var entities = [ZZFeedEntity]()
            feedDicts.forEach({ (dic) -> () in
                
                entities.append(ZZFeedEntity(dic: dic))
                
            })
            
            self.entitys = entities
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                finish?()
            })
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension ViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ZZFeedCell), forIndexPath: indexPath) as! ZZFeedCell
        cell.entity = self.feedEntitySections[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.feedEntitySections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        return self.feedEntitySections[section].count
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.cellHeightCacheEnabled {
            return tableView.zz_heightForCellWithIdentifier(String(ZZFeedCell), cacheByIndexPath: indexPath, configuration: { (cell) -> () in
                guard let cell = cell as? ZZFeedCell else {return }
                cell.entity = self.feedEntitySections[indexPath.section][indexPath.row]
            })
        }else{
            return tableView.zz_heightForCellWithIdentifier(String(ZZFeedCell), configuration: { (cell) -> () in
                guard let cell = cell as? ZZFeedCell else {return }
                cell.entity = self.feedEntitySections[indexPath.section][indexPath.row]
            })
        }
    }

}

