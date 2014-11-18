# Cregle AccessoryKit SDK
#### Documentation for version (0.8 beta)

## Intro

The Cregle AccessoryKit Framework provides support for [iPen2](http://www.cregle.com/pages/pressure-sensitive-stylus-for-your-imac-and-ipad) styluses.
Applications that support iPen2 must integrate CRAccessoryKit.framework to communicate with stylus, and configure Info.plists according to instructions below.
This SDK could be run both from Simulator and supported iOS Devices with CPU armv7(s) or arm64. Sample code and SDK itself were built and tested with Xcode 5. SDK supports iOS 6 and later.

## Integration

1. Add the CRAccessoryKit.framework to your project: File->Add Files to "YourProject"
  - Find and select the folder that contains the CRAccessoryKit.framework
	- Make sure that "Copy items into destination folder (if needed)" is checked
	- Set Folders to "Create groups for any added folders"
	- Select all targets that you want to add the framework to

2. Add ExternalAccessory.framework to your Link Binary With Libraries Build Phase
	* Select your Project in the Project Navigator
	* Select the target you want to enable the SDK for
	* Select the Build Phases tab
	* Open the Link Binary With Libraries Phase
	* Click the + to add a new library
	* Find ExternalAccessory.framework in the list and add it
	* Repeat Steps 2 - 6 until all targets you want to use the SDK with have ExternalAccessory.framework

3. Add libc++.dylib (or libstdc++.dylib) to your Link Binary With Libraries Build Phase
	* If your project uses C++ (.cpp and/or .mm files) along with Objective-C code you could skip this step
	* If your project is written on pure C/Objective-C, you need also to add libstdc++.dylid library for gcc compiler or libc++.dylib (recommended) for clang compiler
	* Follow steps from item 2 for required library to add it to your project

4. Check the __-ObjC__ flag is passed to linked (eg. via Other Linker Flags Xcode build setting) to allow internal classes to be instantiated properly.

5. Modify your Info.plist file to manifest __com.cregle.ipen2__ protocol support to iOS
	* Select your Project in the Project Navigator
	* Select "main" target, typically it is your application
	* Switch to the Info tab
	* If you don't have Supported external accessory protocols entry, right click on the table and select Add Row menu item
	* Select Supported external accessory protocols item in dropdown menu
	* Add __com.cregle.ipen2__ item to the Supported external accessory protocols array

6. In your code
	* call `[CRAccessoryKit start:];` as soon as you intend to work with iPen
	* call `[CRAccessoryKit stop];` when you decide it's better to turn off accessory (e.g. to optimize power consumption)

## Program model
Central class in CRAccessoryKit is CRAccessoryManager

	@interface CRAccessoryManager : NSObject

	@property (nonatomic, readonly, copy) NSSet* connectedAccessories;
	@property (nonatomic, readonly, copy) NSSet* gestureRecognizers;

	@property (nonatomic) BOOL automaticallyRejectsPalmWhileDrawing;
	@property (nonatomic) BOOL showsHoveringMarks;
	@property (nonatomic) BOOL sendsEditingActions;

	@property (nonatomic, assign) UIResponder* firstResponder;

	+ (CRAccessoryManager*)sharedManager;

	- (BOOL)addGestureRecognizer:(CRGestureRecognizer*)gestureRecognizer;
	- (void)removeGestureRecognizer:(CRGestureRecognizer*)gestureRecognizer;

	- (BOOL)addExclusionView:(UIView*)touchEnabledView;
	- (void)removeExclusionView:(UIView*)touchEnabledview;

	@end

There is only one instance of this class at a time in application, accessible via `+[CRAccessoryManager sharedManager]` method.
You could use it co adjust behaviour of accessory, iterate over connected accessories (only one in virually all cases), and subscribe to accessory notifications.
Also you could add some views (usually controls) to touch rejection exclusion list, so they'll be available even when touch rejection is active.

### Drawing events

Drawing gestures of stylus are being delivered to application in CRDrawingEvent class instances. This class incapsulates all information about certain event:

	@interface CRDrawingEvent : NSObject

	@property(nonatomic,readonly) NSTimeInterval timestamp;
	@property(nonatomic,readonly) float tipPressure;

	- (CGPoint)locationInView:(UIView *)view;

	@end

CRAccessoryKit Framework uses [UIResponder](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIResponder_Class/Reference/Reference.html) based event delivering mechanisn. CRAccessoryKit extends the UIResponder class with following category:

	@interface UIResponder (UIResponderDrawingAdditions)
	
	- (void)stylus:(CRAccessory*)accessory didStartDrawing:(CRDrawing*)drawing;
	- (void)stylus:(CRAccessory*)accessory continuesDrawing:(CRDrawing*)drawing;
	- (void)stylus:(CRAccessory*)accessory didEndDrawing:(CRDrawing*)drawing;

	@end

`stylus:` methods are related to corresponding `touches` methods of UIResponder, but being triggered on stylus actions instead of finger touches. For now it is no 'multi-draw' support). The `CRDrawing` object keeps all information about drawing sequence (while stylus' tip is on surface); it conforms to [NSFastEnumeration](https://developer.apple.com/library/ios/documentation/cocoa/reference/NSFastEnumeration_protocol/Reference/NSFastEnumeration.html), so you could access currently reported events (CRDrawingEvent) with `nextObject` or `allObjects` methods. `nextObject`/`allObjects` return ONLY events associated with current call of certain method, previous events won't be enumerated in subsequent calls.

All callbacks are being called on main thread.

Default implementation of these methods calls corresponding method of `self.nextResponder` object. To handle certain actions you should override corresponding methods in your UIView or UIViewController subclass,
no additinal registration required. Also you could implement your own UIResponder chains - messages will be delivered from responder to next one.

Drawing event flow is similar to the touches' UIEvent flow - from UIWindow to its subviews. UIView class extension provides additinal methods to help CRAccessoryManager deliver drawing events to proper view:

	@interface UIView (UIViewDrawingAdditions)
	- (UIView*)drawTest:(CGPoint)point withAccessory:(CRAccessory*)accessory;
	- (BOOL)drawingInside:(CGPoint)point withAccessory:(CRAccessory*)accessory;
	@end

In some cases default drawing events dispatching mechanism isn't effective. It could be in case drawing view is placed under another view completelly or partially or it's desired to handle events outside certain view, application uses non-visual UIResponders to handle events from iPen, etc. In these cases property [CRAccessoryManager firstResponder] could be set to point required object for events handling.
If the firstResponder property isn't nil, CRAccessoryManager will route ALL events to this responder directly, without invocation of UIView based mechanism to select firstResponder.

### Button events
The SDK sends actions in similar to [UIApplication sendAction:to:from:forEvent:] manner. So to handle side button event, you have to implement corresponding method somewhere in UIResponder chain (usually it is UIViewController of "main" view):

	- (IBAction)undo
	- (IBAction)redo
	- (IBAction)save
	- (IBAction)erase

Actions could have UIKit compatible signature, e.g. you could name your `redo` method in one of following ways:

	- (IBAction)redo
	- (IBAction)redo:(id)sender
	- (IBAction)redo:(id)sender forEvent:(id)alwaysNil

### Statistics and monitoring
CRAccessory class instance corresponds to physically connected accessory. You could iterate over these objects via `[CRAccessoryManager sharedManager].connectedAccessories` property.

	@interface CRAccessory : NSObject

	@property (nonatomic, readonly) NSString* identifier;
	@property (nonatomic, readonly) NSString* penIdentifier;

	@property (nonatomic, readonly) UIScreen* screen;

	@property (nonatomic, readonly) float powerLevel;

	@property (nonatomic, readonly) CRButtonState buttonState;
	@property (nonatomic, readonly) CRSideButtonAction sideButtonAction;

	@property (nonatomic, readonly) CRPairingState pairingState;

	@end

CRAccessory represents state of accessory to application, the `screen` property is screen the accessory attached to, most configurations have accessory attached to `[UIScreen mainScreen]`.
`powerLevel` measures battery level of stylus: 1.0 means fully changed, 0.0 - empty. Sometimes `CRPowerUndefined` could be returned. Accessory class properties are KVO compliant.

## Testing
To allow Cregle help you debug CRAccessoryKit integration, improve it and fix certain incompatibilities could have place, please feel free to invite us to [TestFlight](https://testflightapp.com/) Beta Testing of your app.

Devices for TestFlight Beta Testing

iPad 4:

1. __1d6c2b8afa8952dcd23c52ce799f57b40fffa93f__
2. __34f5dbe95db2f25087e550fffc16321cb7323e88__

## Samples
SDK ships with few samples to help start with it and to show possiblities of iPen2.

### TextFieldIntegration
This sample demonstrates how iPen2 could be used to show users hints of input fields. This could be useful in spreadship applications and applications with solid amount of text forms.

### PencilDrawing
The sample demonstrates how it's intended to handle drawing events from iPen2. Main difference of UITouch and CRDrawingEvent is fact that UITouch is being generated not faster then display refresh, and so application gets one dot (in single touch mode) per frame. Many apps uses the 'touches' methods to refresh screen along with drawing state updating. iPen2 has higher report rate and so the 'drawings' methods receive several events (occured between screen refresh) per call. So it's good to optimize screen refresh logic and do it not faster then once per screen refresh to avoid performance penalty. In other words, drawing methods have to be ready to deal with several points per call.
