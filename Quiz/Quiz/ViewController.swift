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
        
        // 8: bronze (Spring animation)
        UIView.animate(withDuration: 1.0,
                                   delay: 0,
                                   usingSpringWithDamping: 1.0, initialSpringVelocity:0.5,
                                   options: [],
                                   animations: {
                                    self.currentQuestionLabel.alpha = 1
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
        // end of task
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextQuestionLabel.alpha = 1
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
        view.isUserInteractionEnabled = true
    }
    
    // 8: silver
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            let screenWidth = self.view.frame.width
            self.currentQuestionLabelCenterXConstraint.constant = 0
            self.nextQuestionLabelCenterXConstraint.constant = -screenWidth
        }
    }
}
