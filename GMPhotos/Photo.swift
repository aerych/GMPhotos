import UIKit
import CoreData
import CoreLocation

class Photo: NSManagedObject {

    @NSManaged var caption: String?
    @NSManaged var date: NSDate?
    @NSManaged var imageData: NSData?
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    }

    lazy var image: UIImage? = {
        if let data = self.imageData {
            return UIImage(data: data)
        }
        return nil
    }()
}
