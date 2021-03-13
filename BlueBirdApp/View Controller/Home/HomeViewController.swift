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
    
    override func viewDidDisappear(_ animated: Bool) {
//        print("disappear home view")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("appear home view")
        
//        let addReminderVC = self.navigationController?.viewControllers.first as? AddReminderViewController
         
//        addReminderVC?.toDoListVM.subscribe(onNext: {[weak self] listViewModel in
//            print(listViewModel.toDos)
//        }).disposed(by: disposeBag)
        
    }
    
    @objc func addReminderBtn() {
        print("Menambahkan Item")
        let secondVC = AddReminderViewController(nibName: "AddReminderVC", bundle: nil)
        self.navigationController?.pushViewController(secondVC, animated: true)
//        present(secondVC, animated: true, completion: nil)
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
        
//        toDosTableView
//            .rx
//            .modelSelected(ToDo.self)
//            .subscribe(onNext: { toDoObject in
//
//                let secondVC = AddReminderViewController(nibName: "AddReminderVC", bundle: nil)
//
//                secondVC.modalPresentationStyle = .pageSheet
//
//                self.present(secondVC, animated: true, completion: nil)
//
//
//            }).disposed(by: disposeBag)
        
//
//        toDosTableView
//            .rx
//            .itemSelected
//            .subscribe(onNext: { indexPath in
//                let secondVC = AddReminderViewController(nibName: "AddReminderVC", bundle: nil)
//
//                secondVC.toDoListViewModel = self.toDoListViewModel
//                secondVC.itemIndex = indexPath.row
//                secondVC.modalPresentationStyle = .pageSheet
//
//                self.present(secondVC, animated: true, completion: nil)
//            }).disposed(by: disposeBag)
        
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
//        secondVC.toDoListViewModel = self.toDoListViewModel
//        secondVC.toDoViewModel = toDoViewModel
        secondVC.reminderTitle.accept(toDoViewModel?.title ?? "")
        secondVC.reminderDate.accept(toDoViewModel?.dateTime ?? "")
        secondVC.reminderDesc.accept(toDoViewModel?.desc ?? "")
        
        self.navigationController?.pushViewController(secondVC, animated: true)
//        present(secondVC, animated: true, completion: nil)
        
    }
}
