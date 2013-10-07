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


- (id)initWithStone:(FGStolperstein *)theStone
{
    self = [super init];
    if (self) {
        stone = theStone;
        coordinate = theStone.location.coordinate;
    }
    return self;
}
@end
