import UIKit
import CoreData

class PhotoPagerViewController : UIPageViewController
{
    var index: Int = 0

    var photos = [Photo]()


    // MARK: - Lifecycle Methods


    class func controller(photos: [Photo], startingIndex: Int) -> PhotoPagerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("PhotoPagerViewController") as! PhotoPagerViewController

        controller.photos = photos
        controller.index = startingIndex

        return controller
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        let startingController: PhotoViewController = controllerForPhotoAtIndex(index)
        let viewControllers = [startingController]
        setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)

    }


    func controllerForPhotoAtIndex(index: Int) -> PhotoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
        controller.photo = photos[index]

        navigationItem.title = controller.navigationItem.title
        navigationItem.rightBarButtonItems = controller.navigationItem.rightBarButtonItems

        return controller
    }


    func indexOfViewController(controller: PhotoViewController) -> Int {
        guard let photo = controller.photo else {
            return NSNotFound
        }
        return photos.indexOf(photo)!
    }

}


extension PhotoPagerViewController : UIPageViewControllerDataSource
{

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController as! PhotoViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }

        index -= 1
        return controllerForPhotoAtIndex(index)
    }


    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController as! PhotoViewController)
        if index == NSNotFound {
            return nil
        }

        index += 1
        if index == photos.count {
            return nil
        }

        return controllerForPhotoAtIndex(index)
    }
}
