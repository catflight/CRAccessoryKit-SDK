//
//  ViewController.m
//  TextFieldIntegration
//
//  Created by Boris Remizov on 11/10/13.
//  Copyright (c) 2013 Cregle. All rights reserved.
//

#import "ViewController.h"
#import <CRAccessoryKit/CRAccessoryKit.h>

@interface ViewController ()<UIPopoverControllerDelegate>

@property (nonatomic, assign) IBOutlet UITextField* clientNameTextField;
@property (nonatomic, assign) IBOutlet UITextField* managerNameTextField;

@property (nonatomic, strong) UIPopoverController* hintPopoverController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // configure client field
    {
        self.clientNameTextField.text = NSLocalizedString(@"James M. Martel", "");
        
        CRHoverGestureRecognizer* recognizer = [[CRHoverGestureRecognizer alloc] initWithView:self.clientNameTextField];
        [recognizer addTarget:self action:@selector(viewWasHoveredForAWhile:)];
        [[CRAccessoryManager sharedManager] addGestureRecognizer:recognizer];
    }
    
    // configure manager filer
    {
        self.managerNameTextField.text = NSLocalizedString(@"JClaire E. Perez", "");

        CRHoverGestureRecognizer* recognizer = [[CRHoverGestureRecognizer alloc] initWithView:self.managerNameTextField];
        [recognizer addTarget:self action:@selector(viewWasHoveredForAWhile:)];
        [[CRAccessoryManager sharedManager] addGestureRecognizer:recognizer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWasHoveredForAWhile:(CRGestureRecognizer*)recognizer
{
    if (CRGestureRecognizerStateEnded != recognizer.state)
    {
        [self.hintPopoverController dismissPopoverAnimated:YES];
        self.hintPopoverController = nil;
        return;
    }
    
    if (self.hintPopoverController)
        return;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.numberOfLines = 2;
    label.text = [(UITextField*)recognizer.view placeholder];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = label;
    controller.contentSizeForViewInPopover = CGSizeMake(200, 100);
    
    self.hintPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.hintPopoverController.delegate = self;
    [self.hintPopoverController presentPopoverFromRect:[self.view convertRect:recognizer.view.bounds fromView:recognizer.view]
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.hintPopoverController = nil;
}

@end
