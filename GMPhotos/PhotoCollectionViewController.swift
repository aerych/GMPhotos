import UIKit

class PhotoCollectionViewController : UICollectionViewController
{

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
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
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
        cell.imageView.image = UIImage(named: "whistler.jpg")
        return cell
    }


    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
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
