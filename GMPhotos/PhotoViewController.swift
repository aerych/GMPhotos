import UIKit
import CoreData

class PhotoViewController: UIViewController
{
    @IBOutlet var captionView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mapButton: UIButton!

    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }


    func configureView() {
        guard let photo = photo else {
            return
        }

        label.text = photo.caption
        imageView.image = photo.image
        captionView.hidden = !(photo.caption?.characters.count > 0)

        if photo.coordinate.latitude != 0 && photo.longitude != 0 {
            mapButton.hidden = false
        }

    }


    @IBAction func handleMapButton(button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        controller.photo = photo
        navigationController?.pushViewController(controller, animated: true)
    }


    @IBAction func deletePhoto() {
        if let photo = self.photo {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            context.deleteObject(photo)
            appDelegate.saveContext()
        }
        navigationController?.popViewControllerAnimated(true)
    }

}
