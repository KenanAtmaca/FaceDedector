# FaceDedector
İOS Swift CoreImage Face Dedector Class (Swift 2.3)

![alt tag](https://cloud.githubusercontent.com/assets/16580898/18417156/f5ed5574-7838-11e6-9f4b-df40c1d62123.png)

```Swift
let dedector = FaceDedector(imageView: imgview, borderStyle: .Oval , borderColor: .White, borderWidth: 2)
dedector.dedectFaceInImage()
```

```Swift
  dedector.faceCount
  dedector[0].rightEyePos
  dedector[0].leftEyePos
  dedector[0].mouthPos
  dedector[0].smile
  dedector[0].hasLeftEyeClose
  dedector[0].hasRightEyeClose
```

