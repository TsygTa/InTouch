//
//  DataReloadable.swift
//  InTouch
//
//  Created by Tatiana Tsygankova on 04.03.2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit

protocol DataReloadable {
    func reloadRow(at indexPath: IndexPath)
}

extension UICollectionView: DataReloadable {
    func reloadRow(at indexPath: IndexPath) {
        self.reloadItems(at: [indexPath])
    }
}

extension UITableView: DataReloadable {
    func reloadRow(at indexPath: IndexPath) {
        self.reloadRows(at: [indexPath], with: .automatic)
    }
}
