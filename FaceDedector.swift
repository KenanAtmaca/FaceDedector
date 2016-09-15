//
//  Created by K&
//  Copyright © 2016 Kenan Atmaca. All rights reserved.
//

import UIKit
import CoreImage


enum faceBorderStyle {
    
    case rect
    case oval
    case none

}

enum faceBorderColor {
    
    case black
    case white
    case red
    
}

final class FaceDedector: NSObject {
    
    fileprivate var imgView:UIImageView!
    fileprivate var BorderStyle:faceBorderStyle!
    fileprivate var BorderColor:faceBorderColor!
    fileprivate var BorderWidth:CGFloat!
    fileprivate var faceBox:UIView!
    fileprivate var Faces:[CIFeature] = []
    
    
    init(imageView:UIImageView,borderStyle:faceBorderStyle = faceBorderStyle.rect ,borderColor:faceBorderColor = faceBorderColor.white, borderWidth:CGFloat = 3.0) {
        
        self.imgView = imageView
        self.BorderColor = borderColor
        self.BorderStyle = borderStyle
        self.BorderWidth = borderWidth
        
    }
    
    
    func dedectFaceInImage() -> Bool {
        
        guard let faceImg = CIImage(image: self.imgView.image!) else {
            return false
        }
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh,CIDetectorSmile: true] as [String : Any]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
        self.Faces = (faceDetector?.features(in: faceImg))!
        
        let ciImageSize = faceImg.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
   
        
        for Face in Faces as! [CIFaceFeature] {
            
            var faceViewBounds = Face.bounds.applying(transform)
            
            let viewSize = self.imgView.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            faceBox = UIView(frame: faceViewBounds)
            faceBox.layer.borderWidth = self.BorderWidth
            faceBox.backgroundColor = UIColor.clear
            
            if case BorderColor = faceBorderColor.black {
                self.faceBox.layer.borderColor = UIColor.black.cgColor
            } else if case BorderColor = faceBorderColor.white {
                self.faceBox.layer.borderColor = UIColor.white.cgColor
            } else if case BorderColor = faceBorderColor.red {
                self.faceBox.layer.borderColor = UIColor.red.cgColor
            }

            
            if case BorderStyle = faceBorderStyle.oval {
                self.faceBox.clipsToBounds = true
                self.faceBox.layer.cornerRadius = faceViewBounds.width / 2
            }
            
            if case BorderStyle = faceBorderStyle.none {
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
