//
//  FGAnnotation.h
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FGStolperstein.h"

@interface FGAnnotation : NSObject <MKAnnotation> {
    FGStolperstein *stone;
	CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) FGStolperstein *stone;

- (id)initWithStone:(FGStolperstein *)theStone title:(NSString *)theTitle;

@end
