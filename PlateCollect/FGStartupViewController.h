//
//  FGStartupViewController.h
//  PlateCollect
//
//  Created by Finn Gaida on 08.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGStartupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *hometownLabel;
- (IBAction)hide:(id)sender;

@end
