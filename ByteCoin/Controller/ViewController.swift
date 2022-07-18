//
//  ViewController.swift
//  ByteCoin
//
//  Created by Jacobo Corvalán on 18/07/2022.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    var coinManager = CoinManager()

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
    }

}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let price = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: price)
        self.currencyLabel.text = price
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdateCoin(coin: CoinModel) {
        DispatchQueue.main.async{
            self.bitcoinLabel.text = String(format: "%.2f", coin.rateValue)
        }
        
    }
    
    func didFailWhitError(error: Error) {
        print(error)
    }
}
