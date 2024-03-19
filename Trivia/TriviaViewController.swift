//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit


// Extension to decode HTML entities in a String
extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return self }
        return attributedString.string
    }
}

class TriviaViewController: UIViewController {
    
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        // TODO: FETCH TRIVIA QUESTIONS HERE
        fetchTriviaQuestions()
    }
    
    private func fetchTriviaQuestions() {
        TriviaQuestionService.fetchTriviaQuestions { [weak self] result in
            switch result {
            case .success(let questions):
                if questions.count == 7 {
                    DispatchQueue.main.async {
                        self?.questions = questions
                        // Update UI with the first question
                        self?.updateQuestion(withQuestionIndex: 0)
                    }
                } else {
                    // Handle the case where the number of questions received is not 7
                    DispatchQueue.main.async {
                        // Display an error message or retry the API request
                        // For example:
                        self?.showErrorMessage(message: "Unexpected number of questions received.")
                    }
                }
            case .failure(let error):
                print("Error fetching trivia questions: \(error)")
                // Handle the case where fetching questions failed
                DispatchQueue.main.async {
                    // Display an error message to the user
                    self?.showErrorMessage(message: "Failed to fetch trivia questions.")
                }
            }
        }
    }

    private func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        guard questionIndex < questions.count else {
            // Handle the case where the question index is out of range
            return
        }
        
        // Update current question number label
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        
        // Decode HTML entities for question text
        let decodedQuestion = questions[questionIndex].question.htmlDecoded
        
        // Update question label
        questionLabel.text = decodedQuestion
        
        // Decode HTML entities for category text
        let decodedCategory = questions[questionIndex].category.htmlDecoded
        
        // Update category label
        categoryLabel.text = decodedCategory
        
        if questions[questionIndex].type == "boolean" {
            // For true or false questions, only display true and false options
            answerButton0.setTitle("True", for: .normal)
            answerButton1.setTitle("False", for: .normal)
            // Hide other answer buttons
            answerButton2.isHidden = true
            answerButton3.isHidden = true
        } else {
            // Decode HTML entities for answer options
            let decodedCorrectAnswer = questions[questionIndex].correctAnswer.htmlDecoded
            let decodedIncorrectAnswers = questions[questionIndex].incorrectAnswers.map { $0.htmlDecoded }
            
            // Combine correct answer and incorrect answers
            let decodedAnswers = decodedIncorrectAnswers + [decodedCorrectAnswer]
            
            // Shuffle the answer options
            let shuffledAnswers = decodedAnswers.shuffled()
            
            // Update button titles with shuffled answer options
            answerButton0.setTitle(shuffledAnswers[0], for: .normal)
            answerButton1.setTitle(shuffledAnswers[1], for: .normal)
            answerButton2.setTitle(shuffledAnswers[2], for: .normal)
            answerButton3.setTitle(shuffledAnswers[3], for: .normal)
            
            // Show all answer buttons
            answerButton2.isHidden = false
            answerButton3.isHidden = false
        }
    }


    
    
    // Function to handle tapping on answer buttons
    @IBAction func didTapAnswerButton(_ sender: UIButton) {
        let selectedAnswer = sender.titleLabel?.text ?? ""
        updateToNextQuestion(answer: selectedAnswer)
    }
    
    private func updateToNextQuestion(answer: String) {
        // Check if currQuestionIndex is within the bounds of the questions array
        guard currQuestionIndex < questions.count else {
            // Handle the case where currQuestionIndex is out of range
            return
        }
        
        // Now it's safe to access questions[currQuestionIndex]
        let isCorrect = answer == questions[currQuestionIndex].correctAnswer
        
        // Increment the score if the answer is correct
        if isCorrect {
            numCorrectQuestions += 1
        }
        
        // Display feedback to the user
        let feedbackMessage = isCorrect ? "Correct!" : "Incorrect!"
        let alertController = UIAlertController(title: feedbackMessage, message: nil, preferredStyle: .alert)
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                alertController.dismiss(animated: true) {
                    // Continue to the next question
                    if self.currQuestionIndex + 1 < self.questions.count {
                        // Move to the next question
                        self.currQuestionIndex += 1
                        self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
                    } else {
                        // Show final score
                        self.showFinalScore()
                    }
                }
            }
        }
    }

    
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game Over",
                                                message: "Final Score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            // Reset the game
            self.currQuestionIndex = 0
            self.numCorrectQuestions = 0
            self.fetchTriviaQuestions()
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}

