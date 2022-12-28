import UIKit

class VC_2: UIViewController {
 var objModel = PetDetail()
    @IBOutlet weak var lbl_content_url: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_date_added: UILabel!
    
    @IBOutlet weak var img_View: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: objModel.image_url)else{
            return
        }
        if let data = try? Data(contentsOf: url){
            self.img_View.image = UIImage(data: data)
        }
        
        lbl_content_url.text = "Content URL:   " + objModel.content_url
        lbl_Title.text = "Title:   " + objModel.title
        lbl_date_added.text = "Date:   " + objModel.date_added
    }
}
