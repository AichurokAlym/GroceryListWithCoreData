//
//  FoodJokeTVC.swift
//  GroceryListWithCoreData
//
//  Created by Aichurok Alymkulova on 10.11.22.
//

import UIKit

class FoodJokeTVC: UITableViewController {

    var joke = [Joke]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        getJokes()
        getJokes()
        getJokes()
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
                        print(self.joke[0].text)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return joke.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jokeCell", for: indexPath)
        // Configure the cell...
        var content = cell.defaultContentConfiguration()
        content.text = joke[indexPath.row].text
        cell.contentConfiguration = content
        

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
