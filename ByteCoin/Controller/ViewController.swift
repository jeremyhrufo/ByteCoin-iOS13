//
//  ViewController.swift
//  ByteCoin
//
//  Created by Jeremy Rufo
//  Copyright © 2020 Jeremy H Rufo
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var coinManager: CoinManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoinManager()
        setupDataSourcePicker()
        setupPickerDelegate()
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func setupDataSourcePicker() {
        currencyPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func setupPickerDelegate() {
        currencyPicker.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let temp: String = Constants.currencyArray[row]
        self.coinManager?.getCoinPrice(forCurrency: temp)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func setupCoinManager() {
        self.coinManager = CoinManager()
        self.coinManager?.delegate = self
        
        self.errorLabel.isHidden = true
        self.errorLabel.text = ""
    }
    
    func didUpdateData(_ coinManager: CoinManager, currency: CoinModel) {
        DispatchQueue.main.async {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale.current
            self.bitcoinLabel.text = currencyFormatter.string(from: NSNumber(value: currency.rate ?? 0.0))!
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            //self.hideUI()
            
            self.errorLabel.text = "Error"
            self.errorLabel.isHidden = false
            
            print(error)
        }
    }
}
