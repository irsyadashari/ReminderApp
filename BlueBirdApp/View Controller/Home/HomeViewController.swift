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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let defaults = UserDefaults.standard
    
    var toDoListViewModel = ToDoListViewModel()
    
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
        
        // Because this project requires no Storyboard, so I lost access to subscribe the segue movement in this app cycle, so I use UserDefaults as a force solution
        
        guard let title = defaults.string(forKey: "NEW_TITLE") else { return}
        guard let date = defaults.string(forKey: "NEW_DATE") else { return}
        guard let desc = defaults.string(forKey: "NEW_DESC") else { return}
        guard let mode = defaults.string(forKey: "MODE") else { return}
        
        if title != "" && date != "" && desc != "" && mode == "createNew" {
            
            self.toDoListViewModel.addNewObject(title: title, desc: desc, dateTime: date)
            defaults.setValue("", forKey: "NEW_TITLE")
            defaults.setValue("", forKey: "NEW_DESC")
            defaults.setValue("", forKey: "NEW_DATE")
            defaults.setValue("", forKey: "MODE")
        } else if mode == "edit" {
            self.toDoListViewModel.editAnObject(title: title, desc: desc, date: date)
            
            defaults.setValue("", forKey: "MODE")
            self.toDoListViewModel.selectedIndex = nil
        }
        


    }
    
    @objc func addReminderBtn() {
        
        defaults.setValue("createNew", forKey: "MODE")
        let secondVC = AddReminderViewController(nibName: "AddReminderVC", bundle: nil)
        secondVC.myMode = .create
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
       
        defaults.setValue("edit", forKey: "MODE")
        self.toDoListViewModel.selectedIndex = indexPath.row
        self.navigationController?.pushViewController(secondVC, animated: true)
        
//        present(secondVC, animated: true, completion: nil)
        
    }
}
