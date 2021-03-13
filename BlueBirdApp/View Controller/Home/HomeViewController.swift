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
    
    let defaults = UserDefaults.standard
    
    var toDoListViewModel = ToDoListViewModel()
    
    let tableViewItems = BehaviorRelay.init(value: [])
    
//    let toDoListViewModel = Observable.just(ToDoListViewModel())
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toDosTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reminder App";
        self.registerObserver()
        self.setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReminderBtn))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        print("appear home view")
        
        guard let newTitle = defaults.string(forKey: "NEW_TITLE") else { return}
        guard let newDate = defaults.string(forKey: "NEW_DATE") else { return}
        guard let newDesc = defaults.string(forKey: "NEW_DESC") else { return}
        
        if newTitle != "" && newDate != "" && newDesc != "" {
            
            self.toDoListViewModel.addViewModel(title: newTitle, desc: newDesc, dateTime: newDate)
            defaults.setValue("", forKey: "NEW_TITLE")
            defaults.setValue("", forKey: "NEW_DESC")
            defaults.setValue("", forKey: "NEW_DATE")
        }
        
        print("LISTVM : \(self.toDoListViewModel.getAllToDos())")

    }
    
    @objc func addReminderBtn() {
        print("Menambahkan Item")
        let secondVC = AddReminderViewController(nibName: "AddReminderVC", bundle: nil)
        secondVC.myMode = .create
//        present(secondVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(secondVC, animated: true)

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
        
        let toDoViewModel = toDoListViewModel.getViewModelAtIndex(at: indexPath.row)
        
        let secondVC = AddReminderViewController(nibName: "AddReminderVC", bundle: nil)
        
        secondVC.modalPresentationStyle = .pageSheet
        secondVC.reminderTitle.accept(toDoViewModel?.title ?? "")
        secondVC.reminderDate.accept(toDoViewModel?.dateTime ?? "")
        secondVC.reminderDesc.accept(toDoViewModel?.desc ?? "")
        secondVC.myMode = .edit
        self.navigationController?.pushViewController(secondVC, animated: true)
        
//        present(secondVC, animated: true, completion: nil)
        
    }
}
