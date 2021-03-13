//
//  AddReminderViewController.swift
//  BlueBirdApp
//
//  Created by Irsyad Ashari on 09/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class AddReminderViewController: UIViewController {

    let addreminderVM = AddReminderViewModel()
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var datePickerBtn: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var selectedDate = Date()
    
    let disposeBag = DisposeBag()
    
//
//    var toDoListViewModel: ToDoListViewModel?
    var toDoViewModel: ToDoViewModel?
//
//    private let toDoListVMSubject = PublishSubject<ToDoListViewModel>()
//    var toDoListVM: Observable<ToDoListViewModel> {
//        return toDoListVMSubject.asObservable()
//    }
    
    let reminderTitle: BehaviorRelay = BehaviorRelay<String>(value: "")
    let reminderDate: BehaviorRelay = BehaviorRelay<String>(value: "")
    let reminderDesc: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWidgetStyle()
        
        titleTF.rx.text.map { $0 ?? ""}.bind(to: addreminderVM.titleTextPublishSubject).disposed(by: disposeBag)

        descTV.rx.text.map { $0 ?? ""}.bind(to: addreminderVM.descTextPublishSubject).disposed(by: disposeBag)

//        dateTimeLabel.rx.text.map { $0 ?? ""}.bind(to: addreminderVM.dateTextPublishSubject).disposed(by: disposeBag)
//
        addreminderVM.isValid(title: reminderTitle.value, desc: reminderDesc.value)
        .bind(to: submitBtn.rx.isEnabled)
        .disposed(by: disposeBag)
//
        addreminderVM.isValid(title: reminderTitle.value, desc: reminderDesc.value)
            .map { $0 ? 1 : 0.1 }
            .bind(to: submitBtn.rx.alpha)
            .disposed(by: disposeBag)
        
//        isValid()
//            .map { $0 ? 1 : 0.1 }
//            .bind(to: submitBtn.rx.alpha)
//            .disposed(by: disposeBag)
        
        if reminderDate.value != "" {
            bindValueToWidget()
        }
//
//        if reminderDate.value != "" && reminderTitle.value != "" && reminderDesc.value != "" {
//            toggleSubmitButtonAvailibility(toggle: true)
//        } else {
//            toggleSubmitButtonAvailibility(toggle: false)
//        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    
    }
    
  
    func isValid() -> Observable<Bool> {
        
        return Observable.combineLatest(reminderTitle.asObservable().startWith(""),
                                        reminderDesc.asObservable().startWith("")).map { title, desc in
                                            return title.count > 0 && desc.count > 0
                                        }.startWith(false)
        
    }
    
    
    func bindValueToWidget() {
        reminderTitle
            .map( {
                title in
                String(title)
            })
            .bind(to: titleTF
                    .rx
                    .text)
            .disposed(by: disposeBag)

        reminderDesc
            .map( {
                desc in
                String(desc)
            })
            .bind(to: descTV
                    .rx
                    .text)
            .disposed(by: disposeBag)

        reminderDate
            .map( {
                date in
                String(date)
            })
            .bind(to: dateTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @IBAction func datePickerBtnAction(_ sender: Any) {
        
        // Create a DatePicker
        let datePicker: UIDatePicker = UIDatePicker()
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        datePicker.preferredDatePickerStyle = .inline
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.setDate(self.selectedDate, animated: false)
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AddReminderViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.view.addSubview(datePicker)

        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.selectedDate = sender.date
        
        sender.setDate(self.selectedDate, animated: false)
        
        print("Selected value \(selectedDate)")
        dateTimeLabel.text = selectedDate
        sender.removeFromSuperview()
        
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        
        dismiss(animated: true, completion: {
            print("sheet dismissed")
        })
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func toggleSubmitButtonAvailibility(toggle: Bool) {
        
        if toggle {
            self.submitBtn.isEnabled = true
            self.submitBtn.backgroundColor = .blue
        } else {
            self.submitBtn.isEnabled = false
            self.submitBtn.backgroundColor = .gray
        }
       
    }
    
    func setWidgetStyle() {
        descTV.layer.borderWidth = 1
        descTV.layer.borderColor = UIColor.gray.cgColor
        descTV.layer.cornerRadius = 12
        
        submitBtn.layer.cornerRadius = 12
    }
        

}
