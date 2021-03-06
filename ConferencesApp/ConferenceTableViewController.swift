//
//  ConferenceTableViewController.swift
//  ConferencesApp
//
//  Created by Rashmi Yadav on 7/25/15.
//
//

import UIKit
import MapKit
import Haneke
import AddressBook

class ConferenceTableViewController: UITableViewController, MKMapViewDelegate {
    var conference = Conference()


    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var proposalImage: UIImageView!
    @IBOutlet weak var proposalLabel: UILabel!
    
    @IBOutlet weak var dateImage: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    @IBOutlet weak var twitterImageButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: conference.image_url)
        
        logoImage.hnk_setImageFromURL(url!)
        nameLabel.text = conference.name
        proposalLabel.text = conference.cfp_text
        dateLabel.text = conference.when
        locationLabel.text = conference.location

        twitterButton.setTitle(conference.twitter_username, forState: .Normal)
        twitterImageButton.addTarget(self, action: "openTwitterApp", forControlEvents: .TouchUpInside)
        showMap(conference)
    }

    func showMap(conference: Conference) -> Void {
        let theRegion = setMapCoordinates()
        
        self.mapView.setRegion(theRegion, animated: true)
        
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = theRegion.center
        mapAnnotation.title = conference.location

        mapView.addAnnotation(mapAnnotation)
        mapView.selectAnnotation(mapAnnotation, animated: true)
        
        let tapGesture = setGesture()
        mapView.addGestureRecognizer(tapGesture)
    }

    func setGesture() -> UITapGestureRecognizer
    {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: "handleTap:")

        return tapGesture
    }

    func handleTap(sender: UITapGestureRecognizer) -> Void{
        let mapView = sender.view as! MKMapView!

        let coordinate = mapView.region.center
        let location  = conference.location
        //var span = mapView.region.span
        
        let regionDistance:CLLocationDistance = 0.1
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        


        let addressDictionary = [String(kABPersonAddressStreetKey): location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        

        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location

       
        let launchOptions = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }

    func setMapCoordinates() -> MKCoordinateRegion {
        let latitude: CLLocationDegrees = conference.latitude
        let longitude: CLLocationDegrees = conference.longitude

        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
       
        

        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let venueLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(venueLocation, theSpan)

        return theRegion
    }

    func openTwitterApp(){
        let twitterName = conference.twitter_username
        var URL = ""
        var URLInApp = ""
        URL = "https://twitter.com/" + conference.twitter_username
        URLInApp = "twitter://user?screen_name=\(twitterName)"
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: URLInApp)!) {
            UIApplication.sharedApplication().openURL(NSURL(string: URLInApp)!)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: URL)!)
        }
    }
    
    @IBAction func openTwitter(sender: UIButton) {
        openTwitterApp()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if segue.identifier == "webView" {
           // let selectedRow = tableView.indexPathForSelectedRow?.row
            let viewController = segue.destinationViewController as! ConferenceWebViewController

            viewController.conferenceLink = conference.website
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.allowsSelection = false
        
    }
}
