import UIKit
import Foundation.NSString

class VC_1: UIViewController {
    
    //let url_Api = "https://jsonplaceholder.typicode.com/posts"
    let url_Api = "https://www.anixsoft.co.in/TEST/pets_list.json"
    let settings_url_Api = "https://www.anixsoft.co.in/TEST/config.json"
    var recieveData = Pets()
    var settingsData = Settings()
    var selectedData = PetDetail()
    var userArray = [Any]()
    var isCorrectTime: Bool!
    var timebegin: Int!
    var timeend: Int!
    var dayOfWeek: String!
    
    @IBOutlet weak var table_view: UITableView!
    
    @IBOutlet weak var lbl_message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.dataSource = self
        table_view.delegate = self
    //getCorrectTime()
//        print("isCorrectTime",isCorrectTime)
//        if(isCorrectTime){
//            getRequest()
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCorrectTime()
    }
    
    func getCorrectTime(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        self.dayOfWeek = Date().dayOfWeek()!

        if(dayOfWeek == "Saturday" || dayOfWeek == "Sunday"){
            lbl_message.text = "Today is \(self.dayOfWeek!), so you will not be able to see the data"
            return
        }
        
        
        if let url_s = URL(string: settings_url_Api){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url_s){ (data, response, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                if let _data = data{
                    let decoder = JSONDecoder()
                    do{
                        self.settingsData = try decoder.decode(Settings.self, from: _data)
                        let response = String(self.settingsData.workHours)
                        //print(response)
                        let pattern = "^[A-Z]-[A-Z]\\s{1}(\\d{1,2}:\\d{2})\\s{1}-\\s{1}(\\d{1,2}:\\d{2})$"
                        let regex = try! NSRegularExpression(pattern: pattern)
                        if let match = regex.matches(in: response, range: .init(response.startIndex..., in: response)).first,
                            match.numberOfRanges == 3 {
                            let start = match.range(at: 1)
                            let end = match.range(at: 2)
                          self.createTime(begin: String(response[Range(start, in: response)!]), end: String(response[Range(end, in: response)!]))
                            DispatchQueue.main.async {
                                if(hour<self.timebegin! || hour>self.timeend!){
                                    self.lbl_message.text = "Today is \(self.dayOfWeek!) and \(hour) hours is Out of time range, so you cant see any data"
                                    return
                                }else{
                                    self.lbl_message.text = "Today is \(self.dayOfWeek!) and \(hour) hours is Within time range, thus you can see the following data"
                                   // self.isCorrectTime = true
                                    self.getRequest()
                                }
                            }
                            
                        }
                    }catch{
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func createTime(begin: String, end: String){
        print("Inside Function")
        var holdArray = [String]()
        holdArray = begin.components(separatedBy: ":")
        timebegin = Int(holdArray[0]) ?? 0
        holdArray = end.components(separatedBy: ":")
        timeend = Int(holdArray[0]) ?? 0
    }
    
    func getRequest(){
        //1: Check whether the given string is a valid URL or not.
        if let url_a = URL(string: url_Api)
        {
            //2: Procedure for connecting to Intenet.
            let session = URLSession(configuration: .default)
            
            //3: Creating a new Thread or Escaping Closure.
            let task = session.dataTask(with: url_a) {(data, response, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                if let _data = data{
                    //let dataRev = String(data: _data, encoding: .utf8)
                    //print(dataRev!)
                    let decoder = JSONDecoder()
                    do{
                        //Converting the incoming JSON into a structure that holds an array of objects.
                        self.recieveData = try decoder.decode(Pets.self, from: _data)
                        //self.productList = jsonData.data?.prices ?? []
                        self.userArray = self.recieveData.pets
                        
                        DispatchQueue.main.async {
                            self.table_view.reloadData()
                        }
                        //                        for i: Int in 0...self.recieveData.pets.count-1 {
                        //                            self.userArray
                        //                        }
                        //print(self.userArray.count)
                        
                    }catch{
                        print(error)
                    }
                }
            }
            //4: Give a call to the Completion Handler.
            task.resume()
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension VC_1: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(userArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell1
        cell.lbl_title.text = recieveData.pets[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "display"){
            let destVC = segue.destination as! VC_2
            let selectedData = sender as! PetDetail
            destVC.objModel = selectedData
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = recieveData.pets[indexPath.row]
        performSegue(withIdentifier: "display", sender: selectedData)
        
    }
}



