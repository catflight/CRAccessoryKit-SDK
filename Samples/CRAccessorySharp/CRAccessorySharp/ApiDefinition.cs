using System;
using System.Drawing;
using MonoTouch.ObjCRuntime;
using MonoTouch.Foundation;
using MonoTouch.UIKit;

namespace CRAccessorySharp
{
	[BaseType (typeof (NSObject))]
	public partial interface CRAccessory
	{
		[Export ("identifier")]
		string Identifier { get; }

		[Export ("penIdentifier")]
		string PenIdentifier { get; }

		[Export ("screen")]
		UIScreen Screen { get; }

		[Export ("penPowerLevel")]
		float PenPowerLevel { get; }

		[Export ("receiverPowerLevel")]
		float ReceiverPowerLevel { get; }

		[Export ("buttonState")]
		UInt32 ButtonState { get; }

		[Export ("sideButtonAction")]
		CRSideButtonAction SideButtonAction { get; }

		[Export ("hoveringTime")]
		double HoveringTime { get; }

		[Notification, Field ("CRAccessoryConnectedNotification", "__Internal")]
		NSString ConnectedNotification { get; }

		[Notification, Field ("CRAccessoryDisconnectedNotification", "__Internal")]
		NSString DisconnectedNotification { get; }

		[Field ("CRAccessoryNotificationAccessoryKey", "__Internal")]
		NSString NotificationAccessoryKey { get; }
	}

	[BaseType (typeof (NSObject))]
	public partial interface CRAccessoryManager {

		[Export ("connectedAccessories", ArgumentSemantic.Copy)]
		NSSet ConnectedAccessories { get; }

		[Export ("gestureRecognizers", ArgumentSemantic.Copy)]
		NSSet GestureRecognizers { get; }

		[Export ("automaticallyRejectsPalmWhileDrawing")]
		bool AutomaticallyRejectsPalmWhileDrawing { get; set; }

		[Export ("showsHoveringMarks")]
		bool ShowsHoveringMarks { get; set; }

		[Export ("sendsEditingActions")]
		bool SendsEditingActions { get; set; }

		[Export ("firstResponder", ArgumentSemantic.Assign)]
		UIResponder FirstResponder { get; set; }

		[Static, Export ("sharedManager")]
		CRAccessoryManager SharedManager ();

		[Export ("addGestureRecognizer:")]
		bool AddGestureRecognizer (CRGestureRecognizer gestureRecognizer);

		[Export ("removeGestureRecognizer:")]
		void RemoveGestureRecognizer (CRGestureRecognizer gestureRecognizer);
	}

	[BaseType (typeof (NSObject))]
	public partial interface CRDrawingEvent {

		[Export ("timestamp")]
		double Timestamp { get; }

		[Export ("tipPressure")]
		float TipPressure { get; }

		[Export ("locationInView:")]
		PointF LocationInView (UIView view);
	}

	[BaseType (typeof (NSObject))]
	public partial interface CRGestureRecognizer {

		[Export ("state")]
		CRGestureRecognizerState State { get; }

		[Export ("enabled")]
		bool Enabled { [Bind ("isEnabled")] get; set; }

		[Export ("view")]
		UIView View { get; }

		[Export ("cancelsDrawingsInView")]
		bool CancelsDrawingsInView { get; set; }

		[Export ("initWithView:")]
		IntPtr Constructor (UIView view);

		[Export ("addTarget:action:")]
		void AddTarget (NSObject target, Selector action);

		[Export ("removeTarget:action:")]
		void RemoveTarget (NSObject target, Selector action);

		[Export ("locationInView:")]
		PointF LocationInView (UIView view);
	}

	[BaseType (typeof (CRGestureRecognizer))]
	public partial interface CRLongPressGestureRecognizer {

		[Export ("minimumPressDuration")]
		double MinimumPressDuration { get; set; }

		[Export ("allowableMovement")]
		float AllowableMovement { get; set; }
	}

	[BaseType (typeof (CRGestureRecognizer))]
	public partial interface CRTapGestureRecognizer {

		[Export ("numberOfTapsRequired")]
		uint NumberOfTapsRequired { get; set; }

		[Export ("maximumTapInterval")]
		double MaximumTapInterval { get; set; }
	}

	[BaseType (typeof (CRGestureRecognizer))]
	public partial interface CRHoverGestureRecognizer {

		[Export ("minimumHoverDuration")]
		double MinimumHoverDuration { get; set; }

		[Export ("allowableMovement")]
		float AllowableMovement { get; set; }
	}

	[Category, BaseType (typeof (UIResponder))]
	public partial interface UIResponderDrawingAdditions_UIResponder {

		[Export ("drawingsBegan:withAccessory:")]
		void DrawingsBegan (/*[Verify ("NSArray may be reliably typed, check the documentation", "CRAccessoryKit/UIResponderDrawingAdditions.h", Line = 16)]*/ NSObject [] drawingEvents, CRAccessory accessory);

		[Export ("drawingsMoved:withAccessory:")]
		void DrawingsMoved (/*[Verify ("NSArray may be reliably typed, check the documentation", "CRAccessoryKit/UIResponderDrawingAdditions.h", Line = 17)]*/ NSObject [] drawingEvents, CRAccessory accessory);

		[Export ("drawingsEnded:withAccessory:")]
		void DrawingsEnded (/*[Verify ("NSArray may be reliably typed, check the documentation", "CRAccessoryKit/UIResponderDrawingAdditions.h", Line = 18)]*/ NSObject [] drawingEvents, CRAccessory accessory);
	}

	[Category, BaseType (typeof (UIView))]
	public partial interface UIViewDrawingAdditions_UIView {

		[Export ("drawTest:withAccessory:")]
		UIView DrawTest (PointF point, CRAccessory accessory);

		[Export ("drawingInside:withAccessory:")]
		bool DrawingInside (PointF point, CRAccessory accessory);
	}

	[BaseType (typeof (NSObject))]
	public partial interface CRAccessoryKit {
		[Static, Export ("start:")]
		bool Start (out NSError error);

		[Static, Export ("stop")]
		void Stop ();

	}
}
