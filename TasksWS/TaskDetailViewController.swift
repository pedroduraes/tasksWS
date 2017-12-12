//
//  TaskDetailViewController.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 07/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import UIKit
import MBProgressHUD
import DatePickerDialog

class TaskDetailViewController: UIViewController, UITextFieldDelegate {

    var task : TaskItem?
    var IsNewTask = false
    let formatter = DateFormatter()
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var swtComplete: UISwitch!
    
    @IBAction func chooseDate(_ sender: Any) {
        datePickerTapped()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 40
        let currentString: NSString = txtTitle.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func datePickerTapped() {
        let picker = DatePickerDialog()
        var currentDate = Date()
        if self.task?.expirationdate != "" {
            currentDate = formatter.date(from: (self.task?.expirationdate)!)!
        }
        //picker.datePicker.setDate(currentDate, animated: false)
        
        picker.show("DatePicker", doneButtonTitle: "Ok", cancelButtonTitle: "Cancelar", defaultDate: currentDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.task?.expirationdate = self.formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        self.task?.title = txtTitle.text
        self.task?.descriptionTask = txtDetail.text
        self.task?.iscomplete = swtComplete.isOn
        // verificar ao incluir uma task, pois falta campos
        if self.IsNewTask {
            self.task?.id = ""
            //self.task?.expirationdate = "2018-01-01"
        }
        saveItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.delegate = self
        formatter.dateFormat = "yyyy-MM-dd"
        detailTask()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detailTask()  {
        if self.task != nil {
            self.txtTitle.text = self.task?.title
            self.txtDetail.text = self.task?.descriptionTask
            self.swtComplete.setOn((self.task?.iscomplete)!, animated: false)
            
        }else {
            self.swtComplete.isOn = false
            self.task = TaskItem()
            self.IsNewTask = true
            self.task?.expirationdate = self.formatter.string(from: Date())
        }
    }

    func saveItem()  {
        showProgress()
        PostService().save(item:  self.task! , onSuccess: { response in
            self.task = response?.body
            self.task?.isSyncronized = true
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { _ in
            //print("Falha ao realizar login para o usuario
            self.task?.isSyncronized = false
            self.showMessage("Falha ao salvar task. Salvando off-line.")
        }, always: {
            //hide loading
            self.task = self.task?.toTaskDB().save().toTaskItem()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    
    func showProgress()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.animationType = .zoom
        hud.contentColor = UIColor.red
        hud.mode = .indeterminate
        hud.label.text  = "Salvando task..."
    }
    
    func showMessage(_ msg:String) {
        let myalert = UIAlertController(title: "Mensagem", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            
            myalert.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        })
        self.present(myalert, animated: true)
    }

}
