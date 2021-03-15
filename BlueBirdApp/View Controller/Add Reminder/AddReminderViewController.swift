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
    @IBOutlet weak var dateLabel: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var selectedDate = Date()
    
    let disposeBag = DisposeBag()
    
    let reminderTitle: BehaviorRelay = BehaviorRelay<String>(value: "")
    let reminderDate: BehaviorRelay = BehaviorRelay<String>(value: "")
    let reminderDesc: BehaviorRelay = BehaviorRelay<String>(value: "")
    
    var inputTitle: Observable<String> {
        return reminderTitle.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWidgetStyle()
        
        titleTF.rx.text.map { $0 ?? ""}.bind(to: addreminderVM.titleTextPublishSubject).disposed(by: disposeBag)

        descTV.rx.text.map { $0 ?? ""}.bind(to: addreminderVM.descTextPublishSubject).disposed(by: disposeBag)

        
        addreminderVM.isValid(title: reminderTitle.value, desc: reminderDesc.value, date: reminderDate.value)
        .bind(to: submitBtn.rx.isEnabled)
        .disposed(by: disposeBag)

        addreminderVM.isValid(title: reminderTitle.value, desc: reminderDesc.value, date: reminderDate.value)
            .map { $0 ? 1 : 0.1 }
            .bind(to: submitBtn.rx.alpha)
            .disposed(by: disposeBag)

        
        dateLabel.addTarget(self, action: #selector(datePickerShowsup), for: .editingDidBegin)
        
        if reminderDate.value != "" {
            bindValueToWidget()
        }

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc func datePickerShowsup() {
        // Create a DatePicker
        let datePicker: UIDatePicker = UIDatePicker()
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 80, width: UIScreen.main.bounds.width, height: 300)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        
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
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.selectedDate = sender.date
        
        sender.setDate(self.selectedDate, animated: false)
        dateLabel.text = selectedDate
        
        addreminderVM.dateTextPublishSubject.onNext(selectedDate)
        sender.removeFromSuperview()
        
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        self.reminderTitle.accept(titleTF.text ?? "")
        
//        dismiss(animated: true, completion: {
//            print("sheet dismissed")
//        })
        
        let userDef = UserDefaults.standard
        userDef.setValue(self.titleTF.text, forKey: "NEW_TITLE")
        userDef.setValue(self.descTV.text, forKey: "NEW_DESC")
        userDef.setValue(self.dateLabel.text, forKey: "NEW_DATE")
        
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
