//
//  HomeViewController.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 09/03/21.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    var toDoListViewModel = ToDoListViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var toDosTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reminder App";
        self.registerObserver()
        self.setupTableView()
        
    }
    
    func registerObserver() {
        
        toDoListViewModel.toDos.drive(onNext: { [unowned self] (todos) in
            self.toDosTableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        toDoListViewModel.error.drive(onNext: { [unowned self] (error) in
            self.infoLabel.isHidden = !self.toDoListViewModel.hasError
            self.infoLabel.text = error
            
        }).disposed(by: disposeBag)
        
        toDoListViewModel.isFetching.drive(activityIndicator.rx.isHidden).disposed(by: disposeBag)
        
        
    }
    
    func setupTableView() {
        toDosTableView.delegate = self
        toDosTableView.dataSource = self
        toDosTableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "todoCell")
    }
    
    
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoListViewModel.numberOfList == 0 {
            print("KOSONG")
        }
        return toDoListViewModel.numberOfList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return toDoListViewModel.prepareCellForDisplay(tableView: tableView, indexPath: indexPath)
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = false
        
    }
}
