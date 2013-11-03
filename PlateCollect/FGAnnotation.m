//
//  FGAnnotation.m
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGAnnotation.h"

@implementation FGAnnotation
@synthesize coordinate, stone, title;


- (id)initWithStone:(FGStolperstein *)theStone title:(NSString *)theTitle
{
    self = [super init];
    if (self) {
        stone = theStone;
        coordinate = theStone.location.coordinate;
        title = theTitle;
    }
    return self;
}
@end
