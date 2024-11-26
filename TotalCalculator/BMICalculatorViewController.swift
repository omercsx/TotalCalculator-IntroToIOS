//
//  BMICalculatorViewController.swift
//  TotalCalculator
//
//  Created by Omer Cagri Sayir on 26.11.2024.
//

import UIKit

class BMICalculatorViewController: UIViewController {
    
    // UI Elements
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter weight (kg)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter height (cm)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate BMI", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Your BMI: --"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category: --"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "BMI Categories:\nUnderweight: < 18.5\nNormal weight: 18.5-24.9\nOverweight: 25-29.9\nObese: ≥ 30"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        calculateButton.addTarget(self, action: #selector(calculateBMI), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "BMI Calculator"
        
        view.addSubview(stackView)
        
        [weightTextField, heightTextField, calculateButton, resultLabel, categoryLabel, infoLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            calculateButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func calculateBMI() {
        guard let weightText = weightTextField.text,
              let heightText = heightTextField.text,
              let weight = Double(weightText),
              let height = Double(heightText) else {
            showAlert(message: "Please enter valid weight and height")
            return
        }
        
        // Convert height from cm to meters
        let heightInMeters = height / 100
        
        // Calculate BMI
        let bmi = weight / (heightInMeters * heightInMeters)
        
        // Update UI
        resultLabel.text = String(format: "Your BMI: %.1f", bmi)
        categoryLabel.text = "Category: \(getBMICategory(bmi))"
        
        // Animate the result
        UIView.animate(withDuration: 0.3) {
            self.resultLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.resultLabel.transform = .identity
            }
        }
    }
    
    private func getBMICategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal weight"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
