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

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var datePickerBtn: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var selectedDate = Date()
    
    let disposeBag = DisposeBag()
    
    var isSubmitAvailable = false
    
    var toDoListViewModel: ToDoListViewModel?
    var toDoViewModel: ToDoViewModel?
    
    private let toDoListVMSubject = PublishSubject<ToDoListViewModel>()
    var toDoListVM: Observable<ToDoListViewModel> {
        return toDoListVMSubject.asObservable()
    }
    
    let reminderTitle: BehaviorRelay = BehaviorRelay<String>(value: "")
    let reminderDate: BehaviorRelay = BehaviorRelay<String>(value: "")
    let reminderDesc: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWidgetStyle()
        
        if reminderDate.value != "" {
            bindValueToWidget()
        }
       
       
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
            .bind(to: datePickerBtn.rx.title())
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
    
    func toggleSubmitButtonAvailibility() {
        
        
        self.submitBtn.isEnabled.toggle()
        
        if isSubmitAvailable {
            self.submitBtn.backgroundColor = .blue
        } else {
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
