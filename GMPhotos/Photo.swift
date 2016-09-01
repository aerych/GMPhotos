import Foundation
import CoreData


class Photo: NSManagedObject {

    @NSManaged var caption: String?
    @NSManaged var date: NSDate?
    @NSManaged var imageData: NSData?

}
