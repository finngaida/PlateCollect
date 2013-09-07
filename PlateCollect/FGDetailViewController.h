//
//  FGDetailViewController.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGStolperstein.h"

@interface FGDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) FGStolperstein *stone;

@end
