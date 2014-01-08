# Cregle AccessoryKit SDK
#### Documentation for version (0.4 beta)

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

	@end

There is only one instance of this class at a time in application, accessible via `+[CRAccessoryManager sharedManager]` method.
You could use it co adjust behaviour of accessory, iterate over connected accessories (only one in virually all cases), and subscribe to accessory notifications.

### Drawing events

Drawing gestures of stylus are being delivered to application in CRDrawingEvent class instances. This class incapsulates all information about certain event:

	@interface CRDrawingEvent : NSObject

	@property(nonatomic,readonly) NSTimeInterval timestamp;
	@property(nonatomic,readonly) float tipPressure;

	- (CGPoint)locationInView:(UIView *)view;

	@end

CRAccessoryKit Framework uses [UIResponder](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIResponder_Class/Reference/Reference.html) based event delivering mechanisn. CRAccessoryKit extends the UIResponder class with following category:

	@interface UIResponder (UIResponderDrawingAdditions)
	
	- (void)drawingsBegan:(NSArray*)drawingEvents withAccessory:(CRAccessory*)accessory;
	- (void)drawingsMoved:(NSArray*)drawingEvents withAccessory:(CRAccessory*)accessory;
	- (void)drawingsEnded:(NSArray*)drawingEvents withAccessory:(CRAccessory*)accessory;

	- (void)buttonDown:(NSUInteger)button ofAccessory:(CRAccessory*)accessory;
	- (void)buttonUp:(NSUInteger)button ofAccessory:(CRAccessory*)accessory;
	
	@end

`drawings` methods are related to corresponding `touches` methods of UIResponder, but being triggered on stylus actions instead of finger touches. For now it is no 'multi-draw' support)
Each element in array passed to certain drawing callback method is instance of CRDrawingEvent, there are as mush elements in array as many reports (events) was received from stylus since previous method invocation (all callbacks are being called on main thread).
`button` methods are close to desktop equivalent of UIResponder - [NSResponder](https://developer.apple.com/library/mac/#documentation/cocoa/reference/ApplicationKit/Classes/NSResponder_Class/Reference/Reference.html), and triggers when user presses corresponding buttons on accessory, regardless of tip location.

Default implementation of these methods calls corresponding method of `self.nextResponder` object. To handle certain actions you should override corresponding methods in your UIView or UIViewController subclass,
no additinal registration required. Also you could implement your own UIResponder chains - messages will be delivered from responder to next one.

Drawing event flow is similar to the touches' UIEvent flow - from UIWindow to its subviews. UIView class extension provides additinal methods to help CRAccessoryManager deliver drawing events to proper view:

	@interface UIView (UIViewDrawingAdditions)
	- (UIView*)drawTest:(CGPoint)point withAccessory:(CRAccessory*)accessory;
	- (BOOL)drawingInside:(CGPoint)point withAccessory:(CRAccessory*)accessory;
	@end

In some cases default drawing events dispatching mechanism isn't effective. It could be in case drawing view is placed under another view completelly or partially or it's desired to handle events outside certain view, application uses non-visual UIResponders to handle events from iPen, etc. In these cases property [CRAccessoryManager firstResponder] could be set to point required object for events handling.
If the firstResponder property isn't nil, CRAccessoryManager will route ALL events to this responder directly, without invocation of UIView based method to select firstResponder.

### Statistics and monitoring
CRAccessory class instance corresponds to physically connected accessory. You could iterate over these objects via `[CRAccessoryManager sharedManager].connectedAccessories` property.

	@interface CRAccessory : NSObject

	@property (nonatomic, readonly) NSString* identifier;
	@property (nonatomic, readonly) NSString* penIdentifier;

	@property (nonatomic, readonly) UIScreen* screen;

	@property (nonatomic, readonly) float penPowerLevel;
	@property (nonatomic, readonly) float receiverPowerLevel;

	@property (nonatomic, readonly) CRButtonState buttonState;
	@property (nonatomic, readonly) CRSideButtonAction sideButtonAction;

	@property (nonatomic, readonly) NSTimeInterval hoveringTime;

	@end

CRAccessory represents state of accessory to application, the `screen` property is screen the accessory attached to, most configurations have accessory attached to `[UIScreen mainScreen]`.
`penPowerLevel` measures battery level of stylus: 1.0 means fully changed, 0.0 - empty.
`receiverPowerLevel` represents receiver's battery state, iPad models of iPen2 have no additional batteries in receiver modules.

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
<!-- MacBuildServer Install Button -->
<div class="macbuildserver-block">
    <a class="macbuildserver-button" href="http://macbuildserver.com/project/github/build/?xcode_project=Samples%2FTextFieldIntegration%2FTextFieldIntegration.xcodeproj&amp;target=TextFieldIntegration&amp;repo_url=git%3A%2F%2Fgithub.com.%2FCregle%2FCRAccessoryKit-SDK.git&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png"/></a><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup>
</div>
<!-- MacBuildServer Install Button -->

