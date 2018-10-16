//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit



class PhotoMapViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            self.mapView.delegate = self as? MKMapViewDelegate
        }
    }
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func tapCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        photo = info[UIImagePickerControllerEditedImage] as? UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go to your Location view controller
        performSegue(withIdentifier: "tagSegue", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let locationViewController = segue.destination as? LocationsViewController{
            print("prepare segue")
            locationViewController.delegate = self
        }
    }
    
    func resize(image: UIImage?, newSize: CGSize) -> UIImage? {
        if let image = image{
            let resizeImageView = UIImageView(frame: CGRect(x: 0, y:0, width: newSize.width, height: newSize.height))
            resizeImageView.contentMode = .scaleAspectFill
            resizeImageView.image = image
            
            UIGraphicsBeginImageContext(resizeImageView.frame.size)
            resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
}

extension PhotoMapViewController: LocationsViewControllerDelegate{
    //Adopt and implement the delegate methods in the delegate class.
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber){
        
        //Drop pin
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "Picture!"
        mapView.addAnnotation(annotation)
    }
}

//custom pin as photo
//extension PhotoMapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationViewReuseIden")
//        if annotationView == nil{
//            annotationView = MKAnnotationView()
//        }
//        
//        let thumbnail = self.resize(image: self.photo, newSize: CGSize(width: 60, height: 60))
//        
//        //set the pin image
//        annotationView?.image = thumbnail
//        return annotationView
//    }
//
//}
