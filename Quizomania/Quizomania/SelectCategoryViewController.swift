//
//  SelectCategoryViewController.swift
//  Quizomania
//
//  Copyright © 2016 Mariusz Czeszejko-Sochacki. All rights reserved.
//

import UIKit
import CoreData
class SelectCategoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    var arrayOfCategories: [Dictionary<String, AnyObject>] = []
    var arrayOfQuestions: [Dictionary<String, AnyObject>] = []
    var people = [NSManagedObject]()
    var question: String!
    var username: String!
    var answer: String!
    var category: String = "Politics"
    var urlQuestionsString: String = "http://jservice.io/api/clues?category=1"
    typealias DownloadComplete = () -> ()
    var managedObjectContext: NSManagedObjectContext!
    let categories = ["politics","baseball","odd jobs","movies","australia","cat","us cities","time","dining out","children's","trivia","ac/dc","inventions","ancient worlds","hollywood","cars","u.s. states","hard","landmarks","comedians","animals","number please","awards","movie trivia","science","fashion","silly songs","presidential firsts","andy","starts with b","the bible","toys"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        self.categoryPicker.selectRow(0, inComponent: 0, animated: true)
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        downloadQuestionsAsyn({}, urlString: urlQuestionsString)
        let database = Database()
        people = database.fetchScores(managedObjectContext)
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: "ScoreCell")
    }

    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("ScoreCell")
        
        let person = people[indexPath.row]
        
        cell!.textLabel!.text =
            person.valueForKey("username") as? String
                print(people)
        return cell!
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.urlQuestionsString = "http://jservice.io/api/clues?category=" + (row+1).description
        self.category = categories[row]
        downloadQuestionsAsyn({}, urlString: urlQuestionsString)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        if (segue.identifier == "segueQuiz") {
            let quiz = segue.destinationViewController as! QuizViewController
            quiz.arrayOfQuestions = self.arrayOfQuestions
            quiz.category = category
            quiz.username = username
         }
    }
    
    
    func downloadQuestionsAsyn( completed: DownloadComplete, urlString: String!) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
    
        dispatch_async(dispatch_get_main_queue()) { 
            self.downloadQuestions(url, session: session, completed: {

            })
        }
        completed()
    }

    
    func downloadQuestions(url: NSURL ,session: NSURLSession ,completed: DownloadComplete) {

        session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseData = data {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    
                    self.arrayOfQuestions = json as! [Dictionary<String, AnyObject>]
                    
                } catch let err as NSError {
                    print(err.debugDescription)
                }
                completed()
            }
        }.resume()
    }
}