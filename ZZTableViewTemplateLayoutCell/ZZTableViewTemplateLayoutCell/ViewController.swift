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
//        self.tableView.sectionHeaderHeight = 20
        
        self.buildTestDataThen { () -> () in
            
            self.feedEntitySections[0] = self.entitys
            self.tableView.reloadData()
            
        }
        // 检测帧数
        let fpsLabel = ZZFPSLabel(frame: CGRectMake(10, self.view.frame.width - 150 ,0,0))
        self.view.addSubview(fpsLabel)
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
    
    func randomEntity()->ZZFeedEntity{
       let randomNum = arc4random_uniform(UInt32(self.entitys.count))
       return self.entitys[Int(randomNum)]
    }
    
    
    @IBAction func doActions(sender: AnyObject) {
        
        let shareMenu = UIAlertController(title: nil, message: "Actions",
            preferredStyle: .ActionSheet)
        let insertRow = UIAlertAction(title: "添加一行", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.feedEntitySections[0].insert(self.randomEntity(), atIndex: 0)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        let insertSection = UIAlertAction(title: "添加一个Section", style:
            UIAlertActionStyle.Default){ (action) -> Void in
               self.feedEntitySections.insert([self.randomEntity()], atIndex: 0)
               self.tableView.insertSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        let deleteSection = UIAlertAction(title: "删除一个section", style:
            UIAlertActionStyle.Default){ (action) -> Void in
            
                if  self.feedEntitySections.count > 0{
                    
                    self.feedEntitySections.removeAtIndex(0)
                    self.tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,
            handler: nil)
        
        shareMenu.addAction(insertRow)
        shareMenu.addAction(insertSection)
        shareMenu.addAction(deleteSection)
        shareMenu.addAction(cancelAction)
        self.presentViewController(shareMenu, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            self.feedEntitySections[indexPath.section].removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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
        return self.feedEntitySections[section].count
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.cellHeightCacheEnabled {
            return tableView.zz_heightForCellWithIdentifier(String(ZZFeedCell), cacheByIndexPath: indexPath, configuration: { (cell) -> () in
                guard let cell = cell as? ZZFeedCell else { return }
                cell.entity = self.feedEntitySections[indexPath.section][indexPath.row]
            })
        }else{
            return tableView.zz_heightForCellWithIdentifier(String(ZZFeedCell), configuration: { (cell) -> () in
                guard let cell = cell as? ZZFeedCell else {return }
                cell.entity = self.feedEntitySections[indexPath.section][indexPath.row]
            })
        }
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}

