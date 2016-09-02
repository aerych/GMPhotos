import UIKit
import CoreData


class Photo: NSManagedObject {

    @NSManaged var caption: String?
    @NSManaged var date: NSDate?
    @NSManaged var imageData: NSData?

    lazy var image: UIImage? = {
        if let data = self.imageData {
            return UIImage(data: data)
        }
        return nil
    }()
}
