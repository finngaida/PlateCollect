//
//  FGStuffCalculator.h
//  TourGuide
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

// For reverse geocoding
typedef void (^FGLocationFetchCompletionHandler)(CLLocation *location, NSError *error);

#define kGoogleAPIKey @"AIzaSyCNeUocMmEPOIiUf3WhpGBLTiHwqBERhxg";

@interface FGStuffCalculator : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *manager;
    CLGeocoder *geocoder;
}

- (void)logSurroundingPlaces;
- (void)fetchCurrentLocationWithHandler:(FGLocationFetchCompletionHandler)handler;
- (NSDictionary *)fetchLocalPlacemarksUsingGooglePlacesAroundLocation:(CLLocation *)location radius:(NSInteger)radius;

@end
