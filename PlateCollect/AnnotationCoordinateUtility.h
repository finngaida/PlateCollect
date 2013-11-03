//
//  AnnotationCoordinateUtility.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 03.11.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnotationCoordinateUtility : NSObject

+ (void)mutateCoordinatesOfClashingAnnotations:(NSArray *)annotations;
+ (NSDictionary *)groupAnnotationsByLocationValue:(NSArray *)annotations;
+ (void)repositionAnnotations:(NSMutableArray *)annotations toAvoidClashAtCoordination:(CLLocationCoordinate2D)coordinate;
+ (CLLocationCoordinate2D)calculateCoordinateFrom:(CLLocationCoordinate2D)coordinate  onBearing:(double)bearingInRadians atDistance:(double)distanceInMetres;

@end
