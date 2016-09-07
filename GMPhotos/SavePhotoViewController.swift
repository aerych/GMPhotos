import UIKit
import CoreData
import CoreLocation

class SavePhotoViewController : UIViewController
{
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textField: UITextField!
    var image: UIImage?
    var coord: CLLocationCoordinate2D?

    lazy var locationManager: CLLocationManager = {
        let mgr = CLLocationManager()
        mgr.delegate = self
        mgr.requestWhenInUseAuthorization()
        return mgr
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()

        locationManager.requestLocation()
    }


    func configureView() {
        guard let image = image else {
            return
        }

        imageView.image = image
    }


    @IBAction func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func saveImage() {
        dismissViewControllerAnimated(true, completion: nil)

        guard let image = image else {
            return
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let imageData = UIImagePNGRepresentation(image)

            dispatch_async(dispatch_get_main_queue(), { 
                dispatch_async(dispatch_get_main_queue()) {
                    guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else {
                        return
                    }

                    let context = appDelegate.managedObjectContext

                    if let photo = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: context) as? Photo {
                        photo.date = NSDate()
                        photo.caption = self.textField.text
                        photo.imageData = imageData

                        if let coord = self.coord {
                            photo.latitude = coord.latitude
                            photo.longitude = coord.longitude
                        }

                        appDelegate.saveContext()
                    }
                }
            })

        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

extension SavePhotoViewController : CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            coord = location.coordinate
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(error)")
    }
}
