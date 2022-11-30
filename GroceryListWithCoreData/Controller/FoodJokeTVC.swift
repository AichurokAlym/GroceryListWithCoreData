//
//  FoodJokeTVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 10.11.22.
//

import UIKit

class FoodJokeTVC: UITableViewController {

    var joke = [Joke]()

    let arrColors = ["d9d2e9", "dfe3f0", "d2d4dc", "fff0db", "eafff2"]
    //let cellSpacingHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        //tableView.estimatedRowHeight = 44
        
        for _ in 1...2 {
            getJokes()
        }
    }
    
    @IBAction func refreshBtnTapped(_ sender: UIBarButtonItem) {
        for _ in 1...10 {
            getJokes()
        }
    }
    
    
    func getJokes() {
        //MARK: 1. URL definieren
        let urlString = "https://api.spoonacular.com/food/jokes/random/?apiKey=" + apiKey
        let url = URL(string: urlString)
        guard url != nil else { return }
        
        //MARK: 2. URL Session
        let session = URLSession.shared
        
        //MARK: 3. DataTask erstellen
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            // Error handling
            if error == nil && data != nil {
                
                // JSON Decoder
                let decoder = JSONDecoder()
                var jokes: Joke?
                do {
                     jokes = try decoder.decode(Joke.self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.joke.append((jokes)!)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error parsing JSON")
                    print(error)
                }
            }
        }
        //MARK: 4. API Call starten / fortsetzen
        dataTask.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return joke.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return cellSpacingHeight
//    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "jokeCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = joke[indexPath.section].text
        cell.contentConfiguration = content
        
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.systemMint.cgColor
        
        let randomIndex = Int(arc4random_uniform(UInt32(arrColors.count)))
        cell.backgroundColor = hexStringToUIColor(hex: arrColors[randomIndex])

        return cell
    }

}
