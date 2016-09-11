import UIKit
import CoreImage


enum faceBorderStyle {
    
    case Rect
    case Oval
    case None

}

enum faceBorderColor {
    
    case Black
    case White
    case Red
    
}

final class FaceDedector: NSObject {
    
    private var imgView:UIImageView!
    private var BorderStyle:faceBorderStyle!
    private var BorderColor:faceBorderColor!
    private var BorderWidth:CGFloat!
    private var faceBox:UIView!
    private var Faces:[CIFeature] = []
    
    
    init(imageView:UIImageView,borderStyle:faceBorderStyle = faceBorderStyle.Rect ,borderColor:faceBorderColor = faceBorderColor.White, borderWidth:CGFloat = 3.0) {
        
        self.imgView = imageView
        self.BorderColor = borderColor
        self.BorderStyle = borderStyle
        self.BorderWidth = borderWidth
        
    }
    
    
    func dedectFaceInImage() -> Bool {
        
        guard let faceImg = CIImage(image: self.imgView.image!) else {
            return false
        }
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh,CIDetectorSmile: true]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as? [String : AnyObject])
        self.Faces = faceDetector.featuresInImage(faceImg)
        
        let ciImageSize = faceImg.extent.size
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -ciImageSize.height)
   
        
        for Face in Faces as! [CIFaceFeature] {
            
            var faceViewBounds = CGRectApplyAffineTransform(Face.bounds, transform)
            
            let viewSize = self.imgView.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            faceBox = UIView(frame: faceViewBounds)
            faceBox.layer.borderWidth = self.BorderWidth
            faceBox.backgroundColor = UIColor.clearColor()
            
            if case BorderColor = faceBorderColor.Black {
                self.faceBox.layer.borderColor = UIColor.blackColor().CGColor
            } else if case BorderColor = faceBorderColor.White {
                self.faceBox.layer.borderColor = UIColor.whiteColor().CGColor
            } else if case BorderColor = faceBorderColor.Red {
                self.faceBox.layer.borderColor = UIColor.redColor().CGColor
            }

            
            if case BorderStyle = faceBorderStyle.Oval {
                self.faceBox.clipsToBounds = true
                self.faceBox.layer.cornerRadius = faceViewBounds.width / 2
            }
            
            if case BorderStyle = faceBorderStyle.None {
                self.faceBox.alpha = 0
            }

            self.imgView.addSubview(faceBox)
            
        }
      
        return !Faces.isEmpty ? true : false
        
    }
    
    
    var faceCount:Int {
    
      return Faces.count
    
    }
    
    subscript (index:Int) -> (leftEyePos:CGPoint?,rightEyePos:CGPoint?,mouthPos:CGPoint?) {
        
        guard index <= Faces.count - 1 else {
            return (nil,nil,nil)
        }
        
        if let face:[CIFaceFeature] = Faces as? [CIFaceFeature] {
            
            return (face[index].leftEyePosition,face[index].rightEyePosition,face[index].mouthPosition)
            
        }
    
        return (nil,nil,nil)
    }
    
    subscript (index:Int) -> (smile:Bool?,hasLeftEyeClose:Bool?,hasRightEyeClose:Bool?) {
        
        guard index <= Faces.count - 1 else {
            return (nil,nil,nil)
        }
        
        
        if let face:[CIFaceFeature] = Faces as? [CIFaceFeature] {
            
           return (face[index].hasSmile,face[index].leftEyeClosed,face[index].rightEyeClosed)
            
        }
        
        return (nil,nil,nil)
    }
    
    

} //
