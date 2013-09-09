//
//  FGDatabaseHandler.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 09.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGStolperstein.h"

@interface FGDatabaseHandler : NSObject
//Using the FMDB-Framework

//Main required methods
-(void)openDB;
-(void)closeDB;

//provding content
-(NSMutableArray*)stolpersteinsInRegion:(CLRegion*)region;
-(FGStolperstein*)stolpersteinByID:(NSInteger)stID;

@end
