//
//  NormalCalculatorViewController.swift
//  TotalCalculator
//
//  Created by Omer Cagri Sayir on 29.11.2024.
//

import UIKit

class NormalCalculatorViewController: UIViewController {
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 60, weight: .regular)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var firstNumber: Double = 0
    private var currentOperation: String = ""
    private var shouldResetNumber = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Add display label
        view.addSubview(displayLabel)
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add buttons stack view
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // Create button rows
        let buttonData = [
            ["AC", "±", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"],
            ["0", ".", "="]
        ]
        
        for row in buttonData {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .fillEqually
            
            for title in row {
                let button = createButton(title: title)
                rowStack.addArrangedSubview(button)
                
                if title == "0" {
                    button.widthAnchor.constraint(equalTo: rowStack.widthAnchor, multiplier: 0.5).isActive = true
                }
            }
            
            buttonsStackView.addArrangedSubview(rowStack)
        }
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32)
        button.backgroundColor = getButtonColor(for: title)
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func getButtonColor(for title: String) -> UIColor {
        switch title {
        case "AC", "±", "%":
            return .lightGray
        case "÷", "×", "-", "+", "=":
            return .systemOrange
        default:
            return .darkGray
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        
        switch title {
        case "0"..."9", ".":
            if shouldResetNumber {
                displayLabel.text = title
                shouldResetNumber = false
            } else {
                displayLabel.text = displayLabel.text! + title
            }
            
        case "+", "-", "×", "÷":
            firstNumber = Double(displayLabel.text!) ?? 0
            currentOperation = title
            shouldResetNumber = true
            
        case "=":
            let secondNumber = Double(displayLabel.text!) ?? 0
            var result: Double = 0
            
            switch currentOperation {
            case "+": result = firstNumber + secondNumber
            case "-": result = firstNumber - secondNumber
            case "×": result = firstNumber * secondNumber
            case "÷": result = firstNumber / secondNumber
            default: break
            }
            
            displayLabel.text = String(format: "%g", result)
            shouldResetNumber = true
            
        case "AC":
            displayLabel.text = "0"
            firstNumber = 0
            currentOperation = ""
            shouldResetNumber = true
            
        case "±":
            if let text = displayLabel.text, let number = Double(text) {
                displayLabel.text = String(format: "%g", -number)
            }
            
        case "%":
            if let text = displayLabel.text, let number = Double(text) {
                displayLabel.text = String(format: "%g", number / 100)
            }
            
        default:
            break
        }
    }
}
