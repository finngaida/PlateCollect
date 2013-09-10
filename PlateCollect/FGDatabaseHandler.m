//
//  FGDatabaseHandler.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 09.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDatabaseHandler.h"

@implementation FGDatabaseHandler {
}

#pragma mark main required methods
-(void)openDB {
    
}

-(void)closeDB {
    
}

#pragma mark providing content
-(NSMutableArray*)stolpersteinsInRegion:(CLRegion*)region {
    return [NSMutableArray new];
}

-(FGStolperstein*)stolpersteinByID:(NSInteger)stID {
    return [FGStolperstein new];
}
@end
