<p align="center">
  <img src="https://github.com/alexlerikos/Projector/blob/README-Update/README-Images/Projector-Icon.png" alt="Projector by Alex Lerikos"/>
</p>

# Projector
An AVFoundation based video player that allows the color scheme and UI to be easily changed to your product's branding specifications

## Example Setup

- Import the Projector framework and add it to your View or View Controller

```swift
import Projector

class ViewController: UIViewController {

	@IBOutlet weak var projectorView: ProjectorView! 
	// or 
	var projector = ProjectorView()

	...
}
```

- Set the player to use your app's color scheme and water-mark
- Load the URL of your video into the ProjectorView's API

```swift
override func viewDidLoad() {
	super.viewDidLoad()
	let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: kVideoName, ofType: kVideoType)!)
	// or 
	// let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
    self.projectorView.setWaterMarkImage(UIImage(named: "water-mark")!)
    self.projectorView.setLoggingEnabled(true)
    self.projectorView.setProgressSliderTintColor(sliderColor)
    self.projectorView.setControlsButtonTint(sliderColor)
    self.projectorView.loadURLAsset(videoURL)
}
```

- You can also change the player's thumb slider, play, pause and restart image using the following APIs 

```swift
public func setProgressSliderThumbSelectedImage(_ image: UIImage)

public func setProgressSliderThumbUnselectedImage(_ image: UIImage)

public func setControlsButtonImageForPlaying(_ image:UIImage)

public func setControlsButtonImageForPaused(_ image:UIImage)

public func setControlsButtonImageForRestart(_ image:UIImage)
```
### Debug

- You can turn on Debug logging with the following API

```swift
 public func setLoggingEnabled(_ enabled:Bool)
```

## Author 
Alex Lerikos (alerikos@gmail.com)

## Open Source Credits
[Stateful](https://github.com/albertodebortoli/Stateful)

## License 
Projector is distributed under the MIT License.
See the LICENSE file for details