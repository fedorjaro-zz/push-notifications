//
//  CellModelDataSource.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit

open class CellModelDataSource: NSObject {

    var cells: [CellModel]

    var configure: (Any, Any) -> ()
    var didSelect: ((CellModel, UITableViewCell?) -> ())? = nil

    init(cells: [CellModel], configure: @escaping (Any, Any) -> ()) {
        self.cells = cells
        self.configure = configure
    }
}

extension CellModelDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)

        configure(cell, item.model())
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
}

extension CellModelDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cells[indexPath.row].cellHeight
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cells[indexPath.row].highlighting
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = cells[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)

        didSelect?(cellModel, cell)
    }
}

extension CellModelDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)

        configure(cell, item.model())
        return cell
    }
}

extension CellModelDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = cells[indexPath.row]
        didSelect?(cellModel, nil)
    }
}
