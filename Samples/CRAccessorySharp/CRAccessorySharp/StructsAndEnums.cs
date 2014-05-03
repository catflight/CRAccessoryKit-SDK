using System;

namespace CRAccessorySharp
{
	public enum CRSideButtonAction {		//: [unmapped: unexposed: Elaborated] {
		None = 0,
		Undo,
		Redo,
		Erase,
		Save
	};

	public enum CRGestureRecognizerState {	//: [unmapped: unexposed: Elaborated] {
		Ready = 0,
		Began,
		Changed,
		Ended,
		Failed
	};
}
