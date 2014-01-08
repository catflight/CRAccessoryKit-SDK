//
//  CROCRViewController.h
//  CRAccessoryKit
//
//  Created by Boris Remizov on 12/8/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CROCRViewController;

@protocol CROCRViewControllerDelegate <NSObject>

- (void)ocrViewController:(CROCRViewController*)controller didRecognizeText:(NSString*)string;
- (void)ocrViewControllerDidFail:(id)controller;

@end


@interface CROCRViewController : UIViewController

- (void)setDelegate:(id<CROCRViewControllerDelegate>)delegate;
- (id<CROCRViewControllerDelegate>)delegate;

@end
