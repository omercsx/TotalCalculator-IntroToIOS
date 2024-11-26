//
//  GravityCalculatorViewController.swift
//  TotalCalculator
//
//  Created by Omer Cagri Sayir on 26.11.2024.
//

import UIKit

class GravityCalculatorViewController: UIViewController {
    
    // UI Elements
    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter weight (kg)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Planet Labels
    private var mercuryLabel = UILabel()
    private var venusLabel = UILabel()
    private var marsLabel = UILabel()
    private var jupiterLabel = UILabel()
    private var saturnLabel = UILabel()
    private var uranusLabel = UILabel()
    private var neptuneLabel = UILabel()
    
    // Gravity relative to Earth
    private let gravityFactors = [
        "Mercury": 0.38,
        "Venus": 0.91,
        "Mars": 0.38,
        "Jupiter": 2.34,
        "Saturn": 1.06,
        "Uranus": 0.92,
        "Neptune": 1.19
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Gravity Calculator"
        
        view.addSubview(weightTextField)
        view.addSubview(calculateButton)
        view.addSubview(stackView)
        
        // Setup planet labels
        let planets = ["Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
        [mercuryLabel, venusLabel, marsLabel, jupiterLabel, saturnLabel, uranusLabel, neptuneLabel].enumerated().forEach { index, label in
            label.text = "\(planets[index]): --"
            label.textAlignment = .left
            stackView.addArrangedSubview(label)
        }
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            calculateButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 20),
            calculateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalToConstant: 44),
            
            stackView.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func calculateButtonTapped() {
        guard let weightText = weightTextField.text,
              let weight = Double(weightText) else {
            showAlert(message: "Please enter a valid weight")
            return
        }
        
        // Update labels with calculated weights
        mercuryLabel.text = "Mercury: \(calculateWeight(weight, for: "Mercury")) kg"
        venusLabel.text = "Venus: \(calculateWeight(weight, for: "Venus")) kg"
        marsLabel.text = "Mars: \(calculateWeight(weight, for: "Mars")) kg"
        jupiterLabel.text = "Jupiter: \(calculateWeight(weight, for: "Jupiter")) kg"
        saturnLabel.text = "Saturn: \(calculateWeight(weight, for: "Saturn")) kg"
        uranusLabel.text = "Uranus: \(calculateWeight(weight, for: "Uranus")) kg"
        neptuneLabel.text = "Neptune: \(calculateWeight(weight, for: "Neptune")) kg"
    }
    
    private func calculateWeight(_ weight: Double, for planet: String) -> String {
        guard let factor = gravityFactors[planet] else { return "N/A" }
        return String(format: "%.2f", weight * factor)
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
