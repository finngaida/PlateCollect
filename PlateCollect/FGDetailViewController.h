//
//  FGDetailViewController.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGStolperstein.h"
#import "FGViewController.h"

@interface FGDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) FGStolperstein *stone;

-(void)createNameView;

@end
