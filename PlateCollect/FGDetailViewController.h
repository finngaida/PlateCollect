//
//  FGDetailViewController.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGDetailViewController : UITableViewController

//Statische Zellen können direkt Text bekommen
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //Für Vor- und Nachname
@property (weak, nonatomic) IBOutlet UILabel *birthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;

//Bei den den anderen müssen erst welche generiert werden
@property (nonatomic, retain) NSMutableArray *deportationInfos;
@property (nonatomic, retain) NSString *dayOfDeath;
@property (nonatomic, retain) NSString *deathPlace;

@end
