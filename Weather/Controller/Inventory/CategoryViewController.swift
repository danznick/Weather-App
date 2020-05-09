//
//  CategoryViewController.swift
//  Weather
//
//  Created by Daniel Gomes on 27/03/20.
//  Copyright © 2020 Daniel Gomes. All rights reserved.
//

import UIKit
protocol CategoryData: class{
	func categoryValues(name: String, cloValue: String)
}
class CategoryViewController: UIViewController {
	
	@IBOutlet weak var tblView: UITableView!
	weak var category: CategoryData?
	override func viewDidLoad() {
		super.viewDidLoad()
		tblView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
	}
}

extension CategoryViewController: UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		CategoryModel.arrCategory.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else { return UITableViewCell() }
		cell.modelCategory = CategoryModel.arrCategory[indexPath.row]
		return cell
	}
}

extension CategoryViewController: UITableViewDelegate{
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		category?.categoryValues(name: CategoryModel.arrCategory[indexPath.row].name, cloValue: CategoryModel.arrCategory[indexPath.row].cloValue)
		self.navigationController?.popViewController(animated: true)
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 95
	}
}

extension CategoryViewController{
	static func shareInstance() -> CategoryViewController{
		return CategoryViewController.instantiateFromStoryboard()
	}
}
