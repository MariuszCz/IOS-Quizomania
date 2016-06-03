//
//  QuizViewController.swift
//  Quizomania
//
//  Copyright © 2016 Mariusz Czeszejko-Sochacki. All rights reserved.
//

import UIKit
import CoreData
class QuizViewController: UIViewController {
    
    
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var answerA: UIButton!
    @IBOutlet weak var answerB: UIButton!
    @IBOutlet weak var answerC: UIButton!
    @IBOutlet weak var answerD: UIButton!
    
    var arrayOfDicts: [Dictionary<String, AnyObject>] = []
    var arrayOfQuestions: [Dictionary<String, AnyObject>] = []
    var category: String!
    var username: String!
    var question: String!
    var answer: String!
    var randomCorrect: Int!
    var numberOfTrials: Int! = 0
    var scores: Int! = 0
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        getRandomQuestion()
        setQuestionAndCategoryText()
    
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            let database = Database()
            database.saveUserName(managedObjectContext, username: username, scores: scores)
        }
    }
    
    
    func setQuestionAndCategoryText() {
        if(question != nil) {
            questionTextView.text = question
            setAnswersText()
            categoryLabel.text = category
        }
    }
    
    func setAnswersText() {
        randomCorrect = getRandomCorrectAnswer()
        if(randomCorrect == 0) {
            answerA.setTitle(answer, forState: .Normal) }
        else { answerA.setTitle(getRandomWrongAnswer(), forState: .Normal) }

        if(randomCorrect == 1) {
            answerB.setTitle(answer, forState: .Normal) }
        else { answerB.setTitle(getRandomWrongAnswer(), forState: .Normal) }
       
        if(randomCorrect == 2) { answerC.setTitle(answer, forState: .Normal) }
        else { answerC.setTitle(getRandomWrongAnswer(), forState: .Normal) }
       
        if(randomCorrect == 3) {
            answerD.setTitle(answer, forState: .Normal) }
        else { answerD.setTitle(getRandomWrongAnswer(), forState: .Normal) }
    }
    
    
    func getRandomQuestion() {
        let randomQuestion = Int(arc4random_uniform(UInt32(self.arrayOfQuestions.count)))
        self.question = String(self.arrayOfQuestions[randomQuestion]["question"]!)
        self.answer = String(self.arrayOfQuestions[randomQuestion]["answer"]!)
    }
    
    func getRandomCorrectAnswer() -> Int! {
        return Int(arc4random_uniform(UInt32(4)))
    }
    
    func getRandomWrongAnswer() -> String! {
        let randomQuestion = Int(arc4random_uniform(UInt32(self.arrayOfQuestions.count)))
        return String(self.arrayOfQuestions[randomQuestion]["answer"]!)
    }
    
    @IBAction func onAnswerAClicked(sender: AnyObject) {
        numberOfTrials = numberOfTrials + 1
        if(randomCorrect == 0) {
            answerA.backgroundColor = UIColor.greenColor()
            addScoresIfFirstTrial()
        } else {
            answerA.backgroundColor = UIColor.redColor()
        }
    }
    
    @IBAction func onAnswerBClicked(sender: AnyObject) {
        numberOfTrials = numberOfTrials + 1
        if(randomCorrect == 1) {
            answerB.backgroundColor = UIColor.greenColor()
            addScoresIfFirstTrial()
        } else {
            answerB.backgroundColor = UIColor.redColor()
        }
    }
    
    @IBAction func onAnswerCClicked(sender: AnyObject) {
        numberOfTrials = numberOfTrials + 1
        if(randomCorrect == 2) {
            answerC.backgroundColor = UIColor.greenColor()
            addScoresIfFirstTrial()
        } else {
            answerC.backgroundColor = UIColor.redColor()
        }
    }
    
    @IBAction func onAnswerDClicked(sender: AnyObject) {
        numberOfTrials = numberOfTrials + 1
        if(randomCorrect == 3) {
            answerD.backgroundColor = UIColor.greenColor()
            addScoresIfFirstTrial()
        } else {
            answerD.backgroundColor = UIColor.redColor()
        }
    }
    
    func addScoresIfFirstTrial() {
        if(numberOfTrials == 1) {
            scores = scores + 10
            scoresLabel.text = String(self.scores)
        }
    }
    
    @IBAction func onNextButtonClicked(sender: AnyObject) {
        getRandomQuestion()
        setQuestionAndCategoryText()
        setDefaultButtonsBackgroundColor()
        numberOfTrials = 0
    }
    
    func setDefaultButtonsBackgroundColor() {
        answerA.backgroundColor = UIColor.clearColor()
        answerB.backgroundColor = UIColor.clearColor()
        answerC.backgroundColor = UIColor.clearColor()
        answerD.backgroundColor = UIColor.clearColor()
    }
}