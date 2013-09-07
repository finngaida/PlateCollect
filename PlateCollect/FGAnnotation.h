//
//  FGAnnotation.h
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FGAnnotation : NSObject <MKAnnotation> {
    NSString *title;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

- (id)initWithTitle:(NSString *)theTitle andCoordinate:(CLLocationCoordinate2D)theCoord;

@end
