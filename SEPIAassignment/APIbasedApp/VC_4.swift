import UIKit

class VC_4: UIViewController {
    
    var objUserModel = UserModel()
 
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_street: UILabel!
    @IBOutlet weak var lbl_lat: UILabel!
    @IBOutlet weak var lbl_long: UILabel!
    @IBOutlet weak var lbl_compName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_name.text = "Name:   " + objUserModel.name
        lbl_street.text = "Street:   " + objUserModel.address.street
        lbl_lat.text = "Latitude:   " + objUserModel.address.geo.lat
        lbl_long.text = "Longitude:   " + objUserModel.address.geo.lng
        lbl_compName.text = "CompanyName:   " + objUserModel.company.name
    }

}
