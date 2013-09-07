//
//  FGStuffCalculator.m
//  TourGuide
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//


#import "FGStuffCalculator.h"

@implementation FGStuffCalculator

- (instancetype)init {
    self = [super init];
    
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [manager startUpdatingLocation];
    
    return self;
}

- (void)fetchCurrentLocationWithHandler:(FGLocationFetchCompletionHandler)handler {
    
    // log it
    NSLog(@"Coords: N %f, E %f", manager.location.coordinate.longitude, manager.location.coordinate.latitude);
    
    // turn coords into city name
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *err) {
        
        handler(manager.location, err);
        
    }];
}

- (NSDictionary *)fetchLocalPlacemarksUsingGooglePlacesAroundLocation:(CLLocation *)location radius:(NSInteger)radius {
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%i&sensor=true&key=%@", location.coordinate.latitude, location.coordinate.longitude, radius    , @"AIzaSyCNeUocMmEPOIiUf3WhpGBLTiHwqBERhxg"];
    
    NSLog(@"Google URL: %@", urlString);
    
    NSError *e;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]] options:NSJSONReadingMutableLeaves error:&e];
    
    return response;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entered Region" message:[NSString stringWithFormat:@"You entered the following region: %@", placemarks[0]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
}

- (void)logSurroundingPlaces {
    
    geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:manager.location.coordinate.latitude longitude:manager.location.coordinate.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *p in placemarks) {
            NSLog(@"Place: %@", p.addressDictionary);
        }
        
    }];
    
}

@end
