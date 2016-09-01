import UIKit

class PhotoViewController: UIViewController
{

    @IBOutlet var imageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "whistler.jpg")
    }
}

