//
//  ViewController.swift
//  cgApiFS
//
//  Created by ALLAN CHAI on 21/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTableView: UITableView!
    var sushiVenues : [SushiVenue] = []
    let searchController = UISearchController(searchResultsController: nil)
    let locationManager = CLLocationManager()
    var currentAnnotations : [RestaurantPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        locationTableView.tableFooterView = UIView()
        locationTableView.rowHeight = UITableViewAutomaticDimension
        locationTableView.estimatedRowHeight = 99.0
        searchTextField.delegate = self
        fetchData(cat: "sushi")
        
        mapView.delegate = self
        
        let regionLongitude = 101.6169489
        let regionLatitude = 3.1385035
        centerMapOnCoordinates(latitude: regionLatitude, longtitude: regionLongitude)

        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationManager.requestWhenInUseAuthorization()
    }


    @IBOutlet weak var mapViewView: UIView!
    @IBOutlet weak var tableViewView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func onSegmentedControlChange(_ sender: AnyObject) {
    
        if segmentedControl.selectedSegmentIndex == 0{
            tableViewView.isHidden = false
            mapViewView.isHidden = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            tableViewView.isHidden = true
            mapViewView.isHidden = false
            
        }
    }
    
    
    func fetchData(cat: String) {
       
        sushiVenues = []
        let url = URL(string: "https://api.foursquare.com/v2/venues/search?client_id=YB4D0XHPQRGOQ1PGDCU1NDD3VJ0PELXV5IW1FET4DQO4BPIM&client_secret=J134ORAK2X0XM4RV4BQVQ4QSBQ4P5D5RDL1JUZYMZZOKU2AV&v=20130815&ll=3.1,101.68&query=\(cat)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data, response,error) -> Void in
            do {
                let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let jsonResponse = dict as! NSDictionary
                let response = jsonResponse["response"] as! NSDictionary
                let venues = response["venues"] as! [NSDictionary]
                for venue in venues {
                    let newVenue = SushiVenue()
                    newVenue.name = venue["name"] as? String
                    
                    let locations = venue["location"] as! NSDictionary
                       // print("\(locations["address"])")
                    //print("\(locations["lat"])")
                   // print("\(locations["lng"])")
                    
                    newVenue.address = locations["address"] as? String
                    newVenue.iat = locations["lat"] as? Double
                    newVenue.lng = locations["lng"] as? Double
                    
                    let contacts = venue["contact"] as! NSDictionary
                    //print("\(contacts["phone"])")
                    newVenue.phoneNumber = contacts["phone"] as?  String
                    
                   // print("\(venue["url"])")
                    newVenue.url = venue["url"] as? String
                    
                    
                  let categories = venue["categories"] as?  NSArray
                    
                    
                    guard let categories1 = categories![0] as? NSDictionary else {
                        return
                    }
                    print(categories1)
                  // print("\(categories1?["name"])")
                    newVenue.category = categories1["name"] as? String
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        self.locationTableView.reloadData()
                        self.pinAnnotation()
                        
                    }
                   
                    
                }
                //print("\(response)")
                
                
            } catch let error as NSError {
                print ("Error: \(error.localizedDescription)")
                
            }
        })
    
        task.resume()

        
    }
    
    func pinAnnotation() {
        
        self.mapView.removeAnnotations(self.currentAnnotations)
        self.currentAnnotations.removeAll()
        for restaurant in sushiVenues {
            let restaurantPoint = RestaurantPoint()
            restaurantPoint.point = restaurant
            restaurantPoint.title = restaurant.name
            
            restaurantPoint.subtitle = restaurant.address
           
            restaurantPoint.coordinate = CLLocationCoordinate2DMake(restaurant.iat!, restaurant.lng!)

            self.currentAnnotations.append(restaurantPoint)
            mapView.addAnnotation(restaurantPoint)

        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            //             selectedIndexPath : IndexPath = tableView.IndexPath.row
            guard let selectedIndexPath : IndexPath = locationTableView.indexPathForSelectedRow else {
                return
            }
            
            let seletedTweet : SushiVenue = sushiVenues[selectedIndexPath.row]
            let controller : DetailViewController = segue.destination as! DetailViewController
            controller.sushiVenue = seletedTweet
        } else if (segue.identifier == "toDetailSegue") {
                //             selectedIndexPath : IndexPath = tableView.IndexPath.row
               /* guard let selectedIndexPath : IndexPath = locationTableView.indexPathForSelectedRow else {
                    return
                }
                
             
                let seletedTweet : SushiVenue = sushiVenues[selectedIndexPath.row] */
            guard let mapView = sender as? CustomMapViewClass else { return }
                print(sushiVenues)
            
               let controller : DetailViewController = segue.destination as! DetailViewController
                controller.sushiVenue = mapView.sushi
                /*controller.sushiVenue = seletedTweet */
        }
    }
    
    
    func centerMapOnCoordinates (latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        
        let regionRadius: CLLocationDistance = 45000
        
        let location = CLLocation (latitude: latitude, longitude: longtitude)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
    
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    
}




extension LocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
}

extension LocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sushiVenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let locationCell : LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        let sushivenue = sushiVenues[indexPath.row]
        locationCell.locationLabel.text = sushivenue.name
        locationCell.addressLabel.text = sushivenue.address
        
        return locationCell
    }
    
}


extension LocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText : String = searchTextField.text!
        let newSearchText = searchText.replacingOccurrences(of: " ", with: "")
        fetchData(cat: newSearchText.lowercased())
        
        searchTextField.resignFirstResponder()
        return true
    }
}

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let resAnnotation = annotation as! RestaurantPoint
            let annotationView = CustomMapViewClass(annotation: annotation, reuseIdentifier: "")
            annotationView.sushi = resAnnotation.point!
            annotationView.image = UIImage(named: "1")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       self.performSegue(withIdentifier: "toDetailSegue", sender: view)
    }
    
}

/*
extension LocationViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar)
    {
        filterContentForSearchText(searchText: searchBar.text!)
    }

}

extension LocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchController.searchBar.text!)
}
 
}  */
