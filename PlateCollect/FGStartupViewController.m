//
//  FGStartupViewController.m
//  PlateCollect
//
//  Created by Finn Gaida on 08.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGStartupViewController.h"

@implementation FGStartupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.usernameLabel.delegate = self; self.usernameLabel.tag = 1;
    self.passwordLabel.delegate = self; self.passwordLabel.tag = 2;
    self.hometownLabel.delegate = self; self.hometownLabel.tag = 3;
}

- (void)saveAll {
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.usernameLabel.text forKey:@"username"];
    [d setObject:self.passwordLabel.text forKey:@"password"];
    [d setObject:self.hometownLabel.text forKey:@"hometown"];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case 1: {
            [self.usernameLabel resignFirstResponder];
            [self.passwordLabel becomeFirstResponder];
            self.passwordLabel.text = @"";
        } break;
        case 2: {
            [self.passwordLabel resignFirstResponder];
            [self.hometownLabel becomeFirstResponder];
            self.hometownLabel.text = @"";
        } break;
        case 3: {
            [self.hometownLabel resignFirstResponder];
            [self saveAll];
        } break;
        default:return YES; break;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hide:(id)sender {
    [self saveAll];
    //[self performSegueWithIdentifier:@"hideSignup" sender:self];
    //[self.navigationController popViewControllerAnimated:YES];
    [self.delegate startupViewControllerDidFinish:self];
}
@end
