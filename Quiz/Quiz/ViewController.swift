//
//  ViewController.swift
//  Quiz
//
//  Created by Pankova Mariya on 03.04.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var answerLabel: UILabel!
    
    let questions = ["From what is cognac made?",
                    "What is the capital of Russia?",
                    "What is 7+7?"]
    
    let answers = ["Grapes",
                   "Moscow",
                   "14"]
    
    var currentQuestionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentQuestionLabel.text = questions[currentQuestionIndex]
        updateOffScreenLabel()
    }
    
    @IBAction func showNextQuestion(_ sender: AnyObject) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_ sender: AnyObject) {
        let answer = answers[currentQuestionIndex]
        answerLabel.text = answer
        //animateAnswerLabel()

    }
    
    func animateLabelTransitions() {
        view.layoutIfNeeded()
        view.isUserInteractionEnabled = false
        
        let screenWidth = view.frame.width
        print(currentQuestionLabel.text)
        print(nextQuestionLabel.text)
        print()

        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth

//        UIView.animateWithDuration(1.0,
//                                   delay: 0,
//                                   options: [.CurveLinear],
//                                   animations: {
//                                    self.currentQuestionLabel.alpha = 0
//                                    self.nextQuestionLabel.alpha = 1
//                                    
//                                    self.view.layoutIfNeeded()
//                                    },
//                                   completion: { _ in
//                                    swap(&self.currentQuestionLabel,
//                                        &self.nextQuestionLabel)
//                                    swap(&self.currentQuestionLabelCenterXConstraint,
//                                        &self.nextQuestionLabelCenterXConstraint)
//                                    
//                                    self.updateOffScreenLabel()
//                                    })
        
        UIView.animate(withDuration: 1.0,
                                   delay: 0,
                                   usingSpringWithDamping: 1.0, initialSpringVelocity:0.5,
                                   options: [],
                                   animations: {
                                    self.currentQuestionLabel.alpha = 0
                                    self.nextQuestionLabel.alpha = 1
                                    self.view.layoutIfNeeded()
                                    },
                                   completion: { _ in
                                            swap(&self.currentQuestionLabel,
                                                &self.nextQuestionLabel)
                                            swap(&self.currentQuestionLabelCenterXConstraint,
                                                &self.nextQuestionLabelCenterXConstraint)
        
                                            self.updateOffScreenLabel()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextQuestionLabel.alpha = 0
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
        view.isUserInteractionEnabled = true
    }
}
