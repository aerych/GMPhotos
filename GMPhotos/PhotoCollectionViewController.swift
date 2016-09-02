import UIKit
import CoreData

class PhotoCollectionViewController : UICollectionViewController
{

    lazy var resultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to prerformFetch. \(error)")
        }
        return controller
    }()

    var managedObjectContext: NSManagedObjectContext {
        get {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            return appDelegate.managedObjectContext
        }
    }


    // MARK: - LifeCycle Methods

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) in
            self.collectionView?.reloadData()
            }, completion: nil)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }


    // MARK: - Camera Related

    @IBAction func handleCameraButtonTapped(sender: UIBarButtonItem) {
        guard UIImagePickerController.isSourceTypeAvailable(.Camera) else {
            let image = UIImage(named: "whistler.jpg")!
            saveImage(image)
            return
        }

        let controller = UIImagePickerController()
        controller.sourceType = .Camera
        controller.cameraCaptureMode = .Photo
        controller.delegate = self

        navigationController?.presentViewController(controller, animated: true, completion: nil)
    }


    func saveImage(image: UIImage) {

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SavePhotoViewController") as! SavePhotoViewController
        controller.image = image

        let navController = UINavigationController(rootViewController: controller)
        presentViewController(navController, animated: true, completion: nil)
    }


    // MARK: - Collection View Methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return resultsController.sections?.count ?? 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsController.fetchedObjects?.count ?? 0
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var availableWidth = collectionView.frame.width
        availableWidth -= 20 // horizontal insets.
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        availableWidth += flowLayout.minimumInteritemSpacing
        let count = floor(availableWidth / 100)
        let side = (availableWidth / count) - flowLayout.minimumInteritemSpacing
        return CGSize(width: side, height: side)
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let side: CGFloat = 10.0
        return UIEdgeInsets(top: side, left: side, bottom: side, right: side)
    }


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCellReuseIdentifier", forIndexPath: indexPath) as! PhotoCell

        if let photo = resultsController.objectAtIndexPath(indexPath) as? Photo {
            cell.imageView.image = photo.image
        }

        return cell
    }


    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let photo = resultsController.objectAtIndexPath(indexPath) as? Photo else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
        controller.photo = photo
        navigationController?.pushViewController(controller, animated: true)
    }

}


extension PhotoCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true) {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            self.saveImage(PhotoHelper.correctPhotoRotation(image))
        }
    }
}


extension PhotoCollectionViewController: NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView?.reloadData()
    }
}
