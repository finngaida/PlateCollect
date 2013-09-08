//
//  FGStolpersteinFetcher.h
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface FGStolpersteinFetcher : NSObject
-(NSArray *)fetchNearestStonesAtLocation:(CLLocation *)location Ammount:(NSInteger)ammount;
@end
