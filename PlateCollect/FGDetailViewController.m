//
//  FGDetailViewController.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDetailViewController.h"

@interface FGDetailViewController ()

@end

@implementation FGDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Design auf die View Elemente anwenden
    NSMutableAttributedString* nameString = self.nameLabel.attributedText.mutableCopy;
    NSArray *words = [self.nameLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int nameEndIndex = [[words objectAtIndex:0] length] - 1;
    NSRange namePosition = NSMakeRange(0, nameEndIndex);
    
    NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];

    [nameString beginEditing];
    [nameString addAttribute:NSFontAttributeName
                       value:boldFontName
                       range:namePosition];
    [nameString endEditing];
    self.nameLabel.attributedText = nameString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
