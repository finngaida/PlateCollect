//
//  FGStartupViewController.h
//  PlateCollect
//
//  Created by Finn Gaida on 08.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGStartupViewController;

@protocol FGStartupViewControllerDelegate <NSObject>
-(void)startupViewControllerDidFinish:(FGStartupViewController *)startupViewCon;
@end


@interface FGStartupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *hometownLabel;

@property (weak, nonatomic) NSObject <FGStartupViewControllerDelegate> *delegate;
- (IBAction)hide:(id)sender;

@end
