

import UIKit

class DJIAlert: NSObject {
    static func show(title:String, msg:String, fromVC:UIViewController) {
        let alert : UIAlertController = UIAlertController.init(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        fromVC.present(alert, animated: true, completion: nil)
    }
}
