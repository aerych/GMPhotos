import UIKit
import MapKit

class MapViewController : UIViewController
{
    @IBOutlet var mapView: MKMapView!
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let photo = photo else {
            return
        }

        let region = MKCoordinateRegionMakeWithDistance(photo.coordinate, 1000, 1000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = photo.coordinate
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: false)
    }
}
