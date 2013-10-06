//
//  FGAnnotation.m
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGAnnotation.h"

@implementation FGAnnotation
@synthesize coordinate, stone;


- (id)initWithStone:(FGStolperstein *)theStone andCoordinate:(CLLocationCoordinate2D)theCoord
{
    self = [super init];
    if (self) {
        stone = theStone;
        coordinate = theCoord;
    }
    return self;
}
@end
