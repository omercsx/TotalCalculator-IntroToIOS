//
//  AgeCalculatorViewController.swift
//  TotalCalculator
//
//  Created by Omer Cagri Sayir on 26.11.2024.
//

import UIKit

class AgeCalculatorViewController: UIViewController {

    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ageLabel.isHidden = true
    }
    
    @IBAction func ageChanged(_ sender: UIDatePicker) {
        let age = calculateAge(birthDate: sender.date)
        ageLabel.text = "You are \(age) years old"
        ageLabel.isHidden = false
    }
    
    func calculateAge(birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
}
