//
//  ListTasksViewController.swift
//  TasksWS
//
//  Created by Aloc SP08120 on 07/12/2017.
//  Copyright © 2017 Aloc SP08120. All rights reserved.
//

import UIKit
import MBProgressHUD
class ListTasksViewController:  UITableViewController, UISearchControllerDelegate , UISearchBarDelegate, UISearchResultsUpdating
    
{
    
    var tasks : Tasks?
    var filterTasks : Tasks?
    var selectedTask : TaskItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier : "detailTask" )
        

    }
    //no load e quando volta  executa este metodo
    override func viewWillAppear(_ animated: Bool) {
        self.listTask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if filterTasks != nil { return (filterTasks?.results?.count)! }
        return tasks == nil ? 0 : (tasks?.count)!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            if filterTasks == nil {
                self.selectedTask = (tasks?.results![indexPath.row])!
            }else {
                self.selectedTask = (filterTasks?.results![indexPath.row])!
            }
            deleteTask()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    @IBAction func btnAddClick(_ sender: Any) {
        self.selectedTask = nil
        performSegue(withIdentifier: "segueAddTask", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterTasks == nil {
            self.selectedTask = (tasks?.results![indexPath.row])!
        }else {
            self.selectedTask = (filterTasks?.results![indexPath.row])!
        }
        performSegue(withIdentifier: "segueDetailTask", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC :  TaskDetailViewController  = segue.destination as! TaskDetailViewController
        destVC.task = self.selectedTask
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailTask", for: indexPath) as! TaskTableViewCell
        
        var item : TaskItem
        item = (tasks?.results![indexPath.row])!
        if filterTasks != nil  {
            item = (filterTasks?.results![indexPath.row])!
        }

        cell.lblName.text = item.title
        cell.lblTaskDetail.text = item.descriptionTask
        cell.lblDate.text = item.expirationdate
        cell.iconStatus.isHidden = !item.iscomplete!
        if item.iscomplete! {
            let img = UIImage(named: "iconStatus")
            cell.iconStatus.image = img //UIImageView(image: img)
            //cell.iconStatus.isHidden = false
        }
        return cell
    }
    
    func showMessage(_ msg:String) {
        let myalert = UIAlertController(title: "Mensagem", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            
            myalert.dismiss(animated: true)
        })
        self.present(myalert, animated: true)
    }
    
    func showProgress()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.animationType = .zoom
        hud.contentColor = UIColor.red
        hud.mode = .indeterminate
        hud.label.text  = "aguarde..."
    }
    
    func listTask()  {
        filterTasks = nil //limpa variavel de buscas
        self.selectedTask = nil //limpa variavel de task selecionada
        showProgress()
        let service = PostService()
        
        service.getTasks( onSuccess: { response in
            self.tasks = response?.body
        
        }, onError: { _ in
            //print("Falha ao realizar login para o usuario
            self.showMessage("erro ao listar tasks - Listando offline")
            self.tasks = Tasks()
            self.tasks?.count = 0
            self.tasks?.results = [TaskItem]()
   
        }, always: {
            //hide loading
            MBProgressHUD.hide(for: self.view, animated: true)
            self.mergeTasks()
            self.tableView.reloadData()
        })
        
    
    
    
    }
    func mergeTasks(){
        let itemsDb : [TaskItem] =  TasksDB().listAll()
        for item in itemsDb {
            var found = false
            if self.tasks?.count! != 0 {
            for onlineItem in (self.tasks?.results)!
            {
                if onlineItem.id == item.id {
                    found = true
                }
            }
            }
            if !found {
                self.tasks?.results?.append(item)
            }
        }
        self.tasks?.count = self.tasks?.results?.count
    }
    
    func deleteTask()  {
        showProgress()
        PostService().delete(item:  self.selectedTask! , onSuccess: { response in
            self.selectedTask?.toTaskDB().delete()//deleta task do db
            self.selectedTask = nil
            self.showMessage("Task removida com sucesso.")
            self.listTask()
        }, onError: { _ in
            //print("Falha ao realizar login para o usuario
            self.showMessage("Falha ao remover task.")
            
        }, always: {
            //hide loading
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    var searchController: UISearchController!
    
    @IBAction func btnSearch(_ sender: UIBarButtonItem) {
        self.searchController = searchControllerWith(searchResultsController: nil)
        self.navItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.btnSearch.tintColor = UIColor.gray
        self.btnSearch.isEnabled = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
        self.btnSearch.tintColor = UIColor.gray
        self.btnSearch.isEnabled = true
        self.navItem.titleView = nil
        filterTasks = nil
        self.tableView.reloadData()
        
    }
    
    func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchController.searchBar)
        filterTasks = nil
        self.tableView.reloadData()
    }
    

    func searchControllerWith(searchResultsController: UIViewController?) -> UISearchController {
        let searchController = UISearchController(searchResultsController: searchResultsController)
        //searchController.delegate = self
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.barTintColor = UIColor.black
        
        return searchController
        
    }

    func updateSearchResults(for searchController: UISearchController) {
     
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filterTasks = nil
        }else {
            var results = [TaskItem]()
            for item in (tasks?.results)! {
                //filtra tasks
                if item.toString().lowercased().range(of: searchText.lowercased()) != nil {
                    results.append(item)
                }
            }
            filterTasks = Tasks()
            filterTasks?.results = results
        }
        self.tableView.reloadData()
    }
    

}
