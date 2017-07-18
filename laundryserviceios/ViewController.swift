//


//  ViewController.swift


//  laundryserviceios


//


//  Created by Emperor on 7/13/17.


//  Copyright © 2017 Emperor. All rights reserved.


//





import UIKit


import MessageUI


import MaterialControls


import Alamofire

import SVProgressHUD




class ViewController: UIViewController, MFMailComposeViewControllerDelegate,UITextFieldDelegate, MDDatePickerDialogDelegate, UITextViewDelegate {
    
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    
    @IBOutlet weak var contentView: UIView!
    
    
    
    
    
    
    
    @IBOutlet weak var nametext: UITextField!
    
    
    @IBOutlet weak var phonetext: UITextField!
    
    
    
    
    
    @IBOutlet weak var calendartext: UITextField!
    
    
    
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var special: UITextView!
    
    
    var datepickerDlg : MDDatePickerDialog!
    
    
    
    
    
    let REGEX_USER_NAME_LIMIT = "^.{4,20}$"
    
    
    let REGEX_USER_NAME = "[A-Za-z0-9]{3,10}"
    
    
    let REGEX_EMAIL = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    
    let REGEX_PASSWORD_LIMIT = "^.{1,20}$"
    
    
    let REGEX_PHONE_DEFAULT = "[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"
    
    
    let REGEX_CALENDAR_DEFAULT = "^.{1,20}$";
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var regcalendar: UILabel!
    
    
    @IBOutlet weak var regphone: UILabel!
    
    
    @IBOutlet weak var regname: UILabel!
    
    
    
    
    @IBAction func textfieldEditing(_ sender: UITextField) {
        
        
        if (calendartext == sender){
            
            
            datepickerDlg.show()
            
            
        }
        
        
    }
    
    
    
    
    
    func datePickerDialogDidSelect(_ date: Date) {
        
        
        var dateFormatter = DateFormatter()
        
        
        
        
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        
        
        
        
        var strDate = dateFormatter.string(from: date)
        
        
        calendartext.text = strDate
        
        
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
        
        nametext.delegate = self
        
        
        phonetext.delegate = self
        
        
        calendartext.delegate = self
        
        
        special.delegate = self
        
        
        //special.addDoneButton()
        
        
        datepickerDlg = MDDatePickerDialog()
        
        
        datepickerDlg.delegate = self
        
        
        
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
        
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        
        
        scoreText.endEditing(true)
        
        
        return true
        
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        if (textField == calendartext){
            
            
            datepickerDlg.show()
            
            
            return false;
            
            
        }
        
        
        return true;
        
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if(text == "\n") {
            
            
            textView.resignFirstResponder()
            
            
            if(special==textView){
                
                
                
                
                
                scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
                
                
            }
            
            
            return false
            
            
        }
        
        
        return true
        
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        if(special==textView){
            
            
            scrollView.setContentOffset(CGPoint(x:0,y:200), animated: true)
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func onSendRequest(_ sender: Any) {
        
        
        
        
        
        
        
        
        
        if ((nametext.text?.isEmpty)! || (nametext.text?.characters.count)! < 4){
            
            
            regname.isHidden = false
            
            
        }
            
            
        else{
            
            
            regname.isHidden = true
            
            
        }
        
        
        if (isValidPhone(value: phonetext.text!)){
            
            
            regphone.isHidden = true
            
            
        }
            
            
        else{
            
            
            regphone.isHidden = false
            
            
        }
        
        
        if (calendartext.text?.characters.isEmpty)!{
            
            
            regcalendar.isHidden = false
            
            
        }
            
            
        else{
            
            
            regcalendar.isHidden = true
            
            
        }
        
        
        
        if (regname.isHidden == true && regphone.isHidden == true && regcalendar.isHidden == true){
            sendEmail()
        }
        
        
        
        
        //
        
        
    }
    
    func sendEmail() {
        /*if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["alex@finalstepmarketing.com", "finalstepmarketing@gmail.com", "nightclubwiz@aol.com"])
            mail.setSubject("Laundry Service")
            mail.setMessageBody("Name : \(nametext.text!)\nPhone : \(phonetext.text!)\nPick Date : \(calendartext.text!)\nSpecial Instructions : \(special.text!)", isHTML: false)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            let alert = UIAlertController(title: "Error", message: "Can not send email. Please set your personal email for this phone", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }*/
        SVProgressHUD.show()
        button.isEnabled = false
        Alamofire.request("https://intelligent-mandarine-23244.herokuapp.com", parameters: [
            "text":nametext.text!,
            "phone":phonetext.text!,
            "special":special.text!,
            "pickdate":calendartext.text!
            ], encoding: URLEncoding.default).responseString { response in
            SVProgressHUD.dismiss()
                self.button.isEnabled = true
            self.performSegue(withIdentifier: "showresult", sender: nil)
        }
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true) { 
            if (result == MFMailComposeResult.sent)
            {
                
            }
        }
        
    }
    func isValidEmail(testStr:String) -> Bool {
        
        
        // print("validate calendar: \(testStr)")
        
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        
        
        
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        
        return emailTest.evaluate(with: testStr)
        
        
    }
    
    
    func isValidPhone(value: String) -> Bool {
        
        
        let PHONE_REGEX = "[0-9]{6,14}$"
        
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        
        let result =  phoneTest.evaluate(with: value)
        
        
        return result
        
        
    }
}





extension UITextField
    
    
{
    
    
    open override func draw(_ rect: CGRect) {
        
        
        self.layer.cornerRadius = 10
        
        
        self.layer.borderWidth = 1.0
        
        
        self.layer.borderColor = UIColor(red: 0.549, green: 0, blue: 0, alpha: 1).cgColor
        
        
        self.layer.masksToBounds = true
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        
        self.rightView = paddingView
        
        
        self.rightViewMode = UITextFieldViewMode.always
        
        
    }
    
    
}


extension UIButton{
    
    
    open override func draw(_ rect: CGRect) {
        
        
        self.layer.cornerRadius = 10
        
        
        self.layer.borderWidth = 1.0
        
        
        self.layer.borderColor = UIColor(red: 0.549, green: 0, blue: 0, alpha: 1).cgColor
        
        
        self.layer.masksToBounds = true
        
        
    }
    
    
}


extension UITextView{
    
    
    open override func draw(_ rect: CGRect) {
        
        
        self.layer.cornerRadius = 10
        
        
        self.layer.borderWidth = 1.0
        
        
        self.layer.borderColor = UIColor(red: 0.549, green: 0, blue: 0, alpha: 1).cgColor
        
        
        self.layer.masksToBounds = true
        
        
    }
    
    
}
