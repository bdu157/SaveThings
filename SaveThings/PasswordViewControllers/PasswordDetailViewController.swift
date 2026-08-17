//
//  PasswordDetailViewController.swift
//  RememBasket
//
//  Created by Dongwoo Pae on 11/14/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class PasswordDetailViewController: UIViewController {
    
    //MARK: Properties and Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    //Buttons
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonsViewInUpdateView: UIView!
    
    //Date Labels
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    @IBOutlet weak var modifiedLabel: UILabel!
    
    
    //MARK: Private Properties
    //Private Properties for showHideButton
    private var showHideButton: UIButton = UIButton()
    private var hidePassword: Bool = false
    
    //Private Properties for setUpLogoImage
    private var logoRightLabel: UILabel = UILabel()
    private var logoRightView: UIView = UIView()
    private var rightViewBackgroundColor: UIColor!
    
    //Private Properties for textFields placeholder animation
    private var titleLabel: UILabel = UILabel()
    private var userNameLabel: UILabel = UILabel()
    private var passwordInputLabel: UILabel = UILabel()
    private var chosenLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
        
        self.setUpButtonsUIView()
        self.setUpNotesTextView()
        self.setUpTextFields()
        self.addDoneButtonToKeyboard()
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        //TextFields Delegates are set up through storyboard
    }
    
    var password: Password? {
        didSet {
            self.updateViews()
        }
    }
    
    var passwordController: PasswordController?
    
    //MARK: Save Button Action
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = self.titleTextField.text,
            let userName = self.userNameTextField.text,
            let passwordInput = self.passwordTextField.text else {return}
        
        if title.isEmpty {
            self.titleTextField.shake()
        }
        
        if userName.isEmpty {
            self.userNameTextField.shake()
        }
        
        if passwordInput.isEmpty {
            self.passwordTextField.shake()
        }
        
        guard let passwordController = self.passwordController,
            let notes = self.notesTextView.text,
            let logoViewbgColor = self.rightViewBackgroundColor else {return}
        
        if !title.isEmpty && !userName.isEmpty && !passwordInput.isEmpty {
            passwordController.createPassword(title: title, userName: userName, password: passwordInput, notes: notes, imageURLString: nil, logoViewbgColor: logoViewbgColor.rgbUIColorToHexString()) //convert UIColor(RGB) to String (Hex) for CoreData
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: Update Button Action on UpdateView
    @IBAction func saveButtonFromUpdateView(_ sender: Any) {
        
        guard let title = self.titleTextField.text,
            let userName = self.userNameTextField.text,
            let passwordInput = self.passwordTextField.text,
            let passwordController = self.passwordController,
            let logoViewbgColor = self.rightViewBackgroundColor,
            let notes = self.notesTextView.text,
            let password = self.password else {return}
        
        if title.isEmpty {
            self.titleTextField.shake()
        }
        
        if userName.isEmpty {
            self.userNameTextField.shake()
        }
        
        if passwordInput.isEmpty {
            self.passwordTextField.shake()
        }
        
        if !title.isEmpty && !userName.isEmpty && !passwordInput.isEmpty {
            passwordController.updatePassword(for: password, changeTitleTo: title, changeUserNameTo: userName, changePasswordTo: passwordInput, changeNotesTo: notes, modifiedDate: Date(), changeImageURLStringTo: nil, logoViewbgColor: logoViewbgColor.rgbUIColorToHexString()) //convert UIColor(RGB) to String (Hex) for CoreData
            NotificationCenter.default.post(name: .needtoReloadData, object: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Cancel Button Action on UpdateView
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Private Methods
    private func updateViews() {
        if let password = self.password, isViewLoaded {
   
            self.titleTextField?.text = password.title
            self.userNameTextField?.text = password.username
            self.passwordTextField?.text = password.password
            self.notesTextView?.text = password.notes
            
            //Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            let dateFromCoreData = password.timestamp
            let createdDate = dateFormatter.string(from: dateFromCoreData!)
            dateFormatter.timeZone = NSTimeZone.local
            
            //Created Date
            self.createdDateLabel.text = createdDate
            
            //Labels UISetUp
            self.buttonsViewInUpdateView?.isHidden = false
            self.createdDateLabel?.isHidden = false
            self.createdLabel.isHidden = false
            self.modifiedDateLabel?.isHidden = true
            self.modifiedLabel?.isHidden = true

            //Handle Modified Date
            if password.modifiedDate != nil {
                
                //Labels UISetUp
                self.modifiedDateLabel?.isHidden = false
                self.modifiedLabel?.isHidden = false
                
                //DateFormatter
                let dateFormatterModified = DateFormatter()
                dateFormatterModified.dateFormat = "MM/dd/yyyy HH:mm:ss"
                let modifiedDateFromCoreData = password.modifiedDate
                let modifiedDate = dateFormatter.string(from: modifiedDateFromCoreData!)
                dateFormatter.timeZone = NSTimeZone.local
                
                //Modified Date
                self.modifiedDateLabel.text = modifiedDate
            }
            
            self.logoRightLabel.text = String(password.title!.prefix(1).capitalized)
            self.logoRightView.backgroundColor = UIColor(hexString: password.logoViewbgColor!)
            self.rightViewBackgroundColor = UIColor(hexString: password.logoViewbgColor!)
            
        } else {
            self.title = "Add Password"
            
            //Labels UISetUp
            self.buttonsViewInUpdateView?.isHidden = true
            self.createdDateLabel?.isHidden = true
            self.modifiedDateLabel?.isHidden = true
            self.createdLabel?.isHidden = true
            self.modifiedLabel?.isHidden = true
        }
    }
    

    //MARK: ButtonView Set Up
    //ButtonView SetUp
    private func setUpButtonsUIView() {
        self.buttonsViewInUpdateView.shapeButtonsViewInUpdateView()
    }
    
    //MARK: Notes TextView Set Up
    //TextView SetUp
    private func setUpNotesTextView() {
    
        notesTextView.tintColor = .orange
        notesTextView.textColor = .black
        notesTextView.layer.cornerRadius = 8
        notesTextView.layer.borderWidth = 0.6
        
        //shadow
        notesTextView.layer.shadowOpacity = 0.6
        notesTextView.clipsToBounds = false
        notesTextView.layer.shadowOffset = CGSize.zero
        notesTextView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    //MARK: TextFields Set Up
    private func setUpTextFields() {
        
        //MARK: Title TextFields Set Up
        titleTextField.shapeTextField()
        //Placeholder SetUp
        titleLabel.frame = CGRect(x: 40, y: 15, width: 40, height: 40)
        titleLabel.setUpPlaceHolderLabels(for: "Title")
        self.titleTextField.addSubview(titleLabel)
        //RightLogoView SetUp
        self.addRightLogoView()
        //Title Image
        let titleIcon = UIImage(named: "title")!
        self.titleTextField.addLeftImage(image: titleIcon)
        
        
        //MARK: Username TextFields Set Up
        userNameTextField.shapeTextField()
        //Placeholder SetUp
        userNameLabel.frame = CGRect(x: 40, y: 15, width: 80, height: 40)
        userNameLabel.setUpPlaceHolderLabels(for: "Username")
        self.userNameTextField.addSubview(userNameLabel)
        //Username Image
        let userNameIcon = UIImage(named: "userName")!
        self.userNameTextField.addLeftImage(image: userNameIcon)
        

        //MARK: Password TextFields Set Up
        passwordTextField.shapeTextField()
        //Placeholder SetUp
        passwordInputLabel.frame = CGRect(x: 40, y: 15, width: 80, height: 40)
        passwordInputLabel.setUpPlaceHolderLabels(for: "Password")
        self.passwordTextField.addSubview(passwordInputLabel)
        //Lock Image
        let lockIcon = UIImage(named: "lock")!
        self.passwordTextField.addLeftImage(image: lockIcon)
        //Eye Image
        let eyesClosed = UIImage(named: "eyes-closed")!
        self.setUpShowHidePasswordButton(image: eyesClosed)
    }
    
    //SetUp ShowHideButton
    private func setUpShowHidePasswordButton(image: UIImage) {
        showHideButton = UIButton(frame: CGRect(x: 3.0, y: 3.0, width: 30.0, height: 30.0))
        showHideButton.setImage(image, for: .normal)
        showHideButton.tintColor = UIColor.black
        let iconContainer: UIView = UIView(frame: CGRect(x: 5.0, y: 0, width: 40, height: 30))
        iconContainer.addSubview(showHideButton)
        
        self.passwordTextField.rightView = iconContainer
        self.passwordTextField.rightViewMode = .always
        
        showHideButton.addTarget(self, action: #selector(showHideButtonImageTapped), for: .touchUpInside)
    }
    
    @objc func showHideButtonImageTapped() {
        if hidePassword {
            self.showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
            self.passwordTextField.isSecureTextEntry = true
            hidePassword = false
        } else {
            self.showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
            self.passwordTextField.isSecureTextEntry = false
            hidePassword = true
        }
    }
    
    
    //Set Up Right LogoView in Title TextField
    private func addRightLogoView() {
        logoRightLabel.frame = CGRect(x: 12.0, y: 6.0, width: 30.0, height: 30.0)
        logoRightLabel.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        logoRightLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        //give constraints for the label
        logoRightView.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        logoRightView.layer.cornerRadius = 10
        logoRightView.layer.borderWidth = 1.5
        logoRightView.layer.borderColor = UIColor.black.cgColor
        
        logoRightView.addSubview(logoRightLabel)
        
        //add padding by adding another uiview with bigger width
        let logoRightViewWithPadding: UIView = UIView(frame: CGRect(x: 0.0, y: 0, width: 50, height: 40))
        logoRightViewWithPadding.addSubview(logoRightView)
        
        self.titleTextField.rightView = logoRightViewWithPadding
        self.titleTextField.rightViewMode = .always
        
    }
    
}


//MARK: UITextFieldDelegate Methods
extension PasswordDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("UIResponder.keyboardWillShow/HideNotification are removed")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
        return true
    }
    
    
    //When TextField is being edited
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        let chosenTextField = textField
        switch chosenTextField {
        case self.titleTextField:
            self.chosenLabel = self.titleLabel
        case self.userNameTextField:
            self.chosenLabel = self.userNameLabel
        case self.passwordTextField:
            self.chosenLabel = self.passwordInputLabel
        default:
            self.chosenLabel = self.titleLabel
        }
        
        if !newText.isEmpty {
            
            UILabel.animate(withDuration: 0.1, animations: {
                self.chosenLabel.alpha = 1
                self.chosenLabel.frame.origin.x = 40
                self.chosenLabel.frame.origin.y = -5
               
                if self.chosenLabel == self.titleLabel {
                    self.logoRightView.alpha = 1
                    self.logoRightLabel.alpha = 1
                    self.logoRightLabel.text = String(newText.prefix(1).capitalized)
                    self.logoRightView.backgroundColor = UIColor(red: CGFloat(Int.random(in: 0...255)) / 255, green: CGFloat(Int.random(in: 0...255)) / 255, blue: CGFloat(Int.random(in: 1...254)) / 255, alpha: 1)
                    self.rightViewBackgroundColor = self.logoRightView.backgroundColor
                }
            }, completion: nil)
            
        } else {
            UILabel.animate(withDuration: 0.1, animations: {
                self.chosenLabel.alpha = 0
                self.chosenLabel.frame.origin.x = 40
                self.chosenLabel.frame.origin.y = 15
                if self.chosenLabel == self.titleLabel {
                    self.logoRightLabel.text = nil
                    self.logoRightView.backgroundColor = .white
                    
                    self.logoRightView.layer.borderColor = UIColor.black.cgColor
                    
                }
            }, completion: nil)
        }
        return true
    }
    
}


//MARK: UITextViewDelegate Methods
extension PasswordDetailViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textview is being editied")
        print("UIResponder.keyboardWillShowNotification is set")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("UIResponder.keyboardWillHideNotification is set")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        return true
    }
    
    //this reacts whenver keyboard appears and disappears
    //make this occur only when textView is selected
    @objc func keyboardWillChange(notification: Notification) {
        print("keyboard did show: \(notification.name.rawValue)")
        
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //MARK: Key Logic for keyboard appear/disappear with right positioning
        //self.view.frame.origin.y + space between textview and the bottom of the app
        if notification.name == UIResponder.keyboardWillShowNotification {
            self.view.frame.origin.y = -keyboardSize.height + (self.view.frame.height - (self.notesTextView.frame.origin.y + self.notesTextView.frame.height))
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    func addDoneButtonToKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(x:0.0, y:0.0, width: UIScreen.main.bounds.size.width, height:44.0))
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(doneButtonTapped(sender:)))
        let rightSide = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([rightSide, barButton], animated: false)
        self.notesTextView.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonTapped(sender: Any) {
        self.notesTextView.endEditing(true)
        print("UIResponder.keyboardWillShow/HideNotification are removed")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

