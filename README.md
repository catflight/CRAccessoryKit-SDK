# Cregle AccessoryKit SDK Documentation
#### Documentation for version (1.0 alpha)

## Intro

The Cregle AccessoryKit Framework provides support for [iPen2](http://www.cregle.com/pages/pressure-sensitive-stylus-for-your-imac-and-ipad) styluses.
Applications that support iPen2 must integrate CRAccessoryKit.framework to communicate with stylus, and configure Info.plists according to instructions below.
This SDK could be run both from Simulator and supported iOS Devices with CPU armv7 or armv7s. Sample code and SDK itself were built and tested with Xcode 4,
but Xcode 3.2 is supported too. This version of SDK is built without authomatic reference counting (ARC). SDK supports iOS 5 and later.

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

4. Modify your Info.plist file to manifest 'com.cregleipen.myProtocol' support to iOS
	* Select your Project in the Project Navigator
	* Select "main" target, typically it is your application
	* Switch to the Info tab
	* If you don't have Supported external accessory protocols entry, right click on the table and select Add Row menu item
	* Select Supported external accessory protocols item in dropdown menu
	* Add 'com.cregleipen.myProtocol' item to the Supported external accessory protocols array

5. In your code
	* call `[CRAccessoryKit start];` as soon as you intend to work with iPen
	* call `[CRAccessoryKit stop];` when you decide it's better to turn off accessory (e.g. to optimize power consumption)

## Program model
Central class in CRAccessoryKit is CRAccessoryManager

	@interface CRAccessoryManager : NSObject

	@property (nonatomic, readonly) NSArray* connectedAccessories;
	@property (nonatomic) BOOL allowsAccessoriesTriggerStandardActions;

	+ (CRAccessoryManager*)sharedManager;

	@end

There is only one instance of this class at a time in application, accessible via `+[CRAccessoryManager sharedManager]` method.
You could use it co adjust behaviour of accessory, iterate over connected accessories (only one in virually all cases), and subscribe to accessory notifications.

### Drawing events

All events from accessory (tip movements, button presses an so) are being delivered to application in CRDrawing class instances. This class incapsulates all information about certain event:

	@interface CRDrawing : NSObject

	@property(nonatomic,readonly) NSTimeInterval timestamp;
	@property(nonatomic,readonly) CRDrawingPhase phase;
	@property(nonatomic,readonly) float tipPressure;
	@property(nonatomic,readonly) float previousTipPressure;
	@property(nonatomic,readonly) NSIndexSet* buttonState;

	- (CGPoint)locationInView:(UIView *)view;
	- (CGPoint)previousLocationInView:(UIView *)view;
	@end

CRAccessoryKit Framework uses [UIResponder](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIResponder_Class/Reference/Reference.html) based event delivering mechanisn. CRAccessoryKit extends the UIResponder class with following category:

	@interface UIResponder (UIResponderDrawingAdditions)
	- (void)drawingBegan:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;
	- (void)drawingMoved:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;
	- (void)drawingEnded:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;
	- (void)drawingCancelled:(CRDrawing*)drawing withAccessory:(CRAccessory*)accessory;

	- (void)buttonDown:(NSUInteger)button withAccessory:(CRAccessory*)accessory;
	- (void)buttonUp:(NSUInteger)button withAccessory:(CRAccessory*)accessory;
	@end

`drawing` methods are related to corresponding `touches` methods of UIResponder, but being triggered on stylus actions instead of finger touches. For now it is no 'multi-draw' support)
`button` methods are close to desktop equivalent of UIResponder - [NSResponder](https://developer.apple.com/library/mac/#documentation/cocoa/reference/ApplicationKit/Classes/NSResponder_Class/Reference/Reference.html), and triggers when user presses corresponding buttons on accessory, regardless of tip location.

Default implementation of these methods calls corresponding method of `self.nextResponder` object. To handle certain actions you should override corresponding methods in your UIView or UIViewController subclass,
no additinal registration required. Also you could implement your own UIResponder chains - messages will be delivered from responder to next one.

Drawing event flow is similar to the touches' UIEvent flow - from UIWindow to its subviews. UIView class extension provides additinal methods to help CRAccessoryManager deliver drawing events to proper view:

	@interface UIView (UIViewDrawingAdditions)
	- (UIView*)drawTest:(CGPoint)point withDrawind:(CRDrawing*)drawing;
	- (BOOL)drawingInside:(CGPoint)point withDrawing:(CRDrawing*)drawing;
	@end

### Statistics and monitoring
CRAccessory class represents instance of connected accessory. You could iterate over these objects via `[CRAccessoryManager sharedManager].connectedAccessories` property.

	@interface CRAccessory : NSObject

	@property (nonatomic, readonly) NSString* identifier;
	@property (nonatomic, readonly) UIScreen* screen;

	@property (nonatomic, readonly) float penPowerLevel;
	@property (nonatomic, readonly) float receiverPowerLevel;

	@end

CRAccessory represents state of accessory to application, the `screen` property is screen the accessory attached to, most configurations have accessory attached to `[UIScreen mainScreen]`.
`penPowerLevel` measures battery level of stylus: 1.0 means fully changed, 0.0 - empty.
`receiverPowerLevel` represents receiver's battery state, iPad models of iPen2 have no additional batteries in receiver modules.

## Working with iPen
#TBD
