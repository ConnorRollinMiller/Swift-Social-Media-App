//
//  FeedTableViewController.swift
//  InstagramClone
//
//  Created by Connor Miller on 11/26/18.
//  Copyright © 2018 Connor Miller. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var users = [String: String]()
    var comments = [String]()
    var usernames = [String]()
    var imageFiles = [PFFileObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                    
                }
                
            }
            
            let getFollowedUsersQuery = PFQuery(className: "Following")
            
            getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.current()?.objectId)
            
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    
                    for follower in followers {
                        
                        if let followedUser = follower["following"] {
                            
                            let query = PFQuery(className: "Post")
                            
                            query.whereKey("userId", equalTo: followedUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    
                                    for post in posts {
                                        
                                        self.comments.append(post["message"] as! String)
                                        
                                        self.usernames.append(self.users[post["userId"] as! String]!)
                                        
                                        self.imageFiles.append(post["imageFile"] as! PFFileObject)
                                        
                                        self.tableView.reloadData()
                                        
                                    }
                                    
                                    
                                }
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
            })
            
        })

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    cell.postedImage.image = imageToDisplay
                    
                }
                
            }
            
        }
        
        cell.comment.text = comments[indexPath.row]
        
        cell.userInfo.text = usernames[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 301
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
