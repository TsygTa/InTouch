//
//  UIViewController+ext.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 23.01.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
