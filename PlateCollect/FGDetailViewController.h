//
//  FGDetailViewController.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //Für Vor- und Nachname
@property (weak, nonatomic) IBOutlet UILabel *birthNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UILabel *districtLabel;

@property (nonatomic, retain) NSMutableArray *deportationInfoLabels;
@property (nonatomic, retain) UILabel *dayOfDeathLabel;
@property (nonatomic, retain) UILabel *deathPlace;

@end
