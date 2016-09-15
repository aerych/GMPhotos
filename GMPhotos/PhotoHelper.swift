import Foundation
import UIKit

class PhotoHelper
{

    /// Borrowed and tweaked from
    /// https://stackoverflow.com/a/33479054
    class func correctPhotoRotation(image: UIImage) -> UIImage {
        let imageOrientation = image.imageOrientation
        let size = image.size

        // No-op if the orientation is already correct
        if imageOrientation == UIImageOrientation.Up {
            return image
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransformIdentity

        if imageOrientation == UIImageOrientation.Down || imageOrientation == UIImageOrientation.DownMirrored {
            transform = CGAffineTransformTranslate(transform, size.width, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }

        if imageOrientation == UIImageOrientation.Left || imageOrientation == UIImageOrientation.LeftMirrored {
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }

        if imageOrientation == UIImageOrientation.Right || imageOrientation == UIImageOrientation.RightMirrored {
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2))
        }

        if imageOrientation == UIImageOrientation.UpMirrored || imageOrientation == UIImageOrientation.DownMirrored {
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }

        if imageOrientation == UIImageOrientation.LeftMirrored || imageOrientation == UIImageOrientation.RightMirrored {
            transform = CGAffineTransformTranslate(transform, size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1)
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let imageRef = image.CGImage!
        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(size.width), Int(size.height),
                                                      CGImageGetBitsPerComponent(imageRef), 0,
                                                      CGImageGetColorSpace(imageRef)!,
                                                      CGImageGetBitmapInfo(imageRef).rawValue)!

        CGContextConcatCTM(ctx, transform)

        if ( imageOrientation == UIImageOrientation.Left ||
            imageOrientation == UIImageOrientation.LeftMirrored ||
            imageOrientation == UIImageOrientation.Right ||
            imageOrientation == UIImageOrientation.RightMirrored ) {
            CGContextDrawImage(ctx, CGRectMake(0, 0, size.height, size.width), imageRef)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0, 0, size.width, size.height), imageRef)
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(CGImage: CGBitmapContextCreateImage(ctx)!)
    }

}
