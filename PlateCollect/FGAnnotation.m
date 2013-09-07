//
//  FGAnnotation.m
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGAnnotation.h"

@implementation FGAnnotation

- (id)initWithTitle:(NSString *)theTitle andCoordinate:(CLLocationCoordinate2D)theCoord {
    
    self = [super init];
    title = theTitle;
    coordinate = theCoord;
    
    return self;
}

@end
