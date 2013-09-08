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

- (void)startMonitoringForLocation:(CLLocation *)location {
    
    [manager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:location.coordinate radius:50 identifier:@"Stolperstein"]];
    
}

- (void)fetchCurrentLocationWithHandler:(FGLocationFetchCompletionHandler)handler {
    
    // log it
    NSLog(@"Coords: N %f, E %f", manager.location.coordinate.longitude, manager.location.coordinate.latitude);
    
    handler(manager.location, nil);
}

- (CLLocation *)locationFromAdress:(NSString *)address {
    
    geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"Found these coords: %@", [placemarks[0] addressDictionary]);
        
    }];
    
    return [[CLLocation alloc] initWithLatitude:123 longitude:123];
    
}

- (NSDictionary *)fetchLocalPlacemarksUsingGooglePlacesAroundLocation:(CLLocation *)location radius:(NSInteger)radius {
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%i&sensor=true&key=%@", location.coordinate.latitude, location.coordinate.longitude, radius    , @"AIzaSyCNeUocMmEPOIiUf3WhpGBLTiHwqBERhxg"];
    
    NSLog(@"Google URL: %@", urlString);
    
    NSError *e;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]] options:NSJSONReadingMutableLeaves error:&e];
    
    return response;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"New Location: N%f E%f", [(CLLocation *)[locations firstObject] coordinate].latitude, [(CLLocation *)[locations firstObject] coordinate].longitude);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    // --------------------------------------------------------------------
    // Possible todo: get the address from the FGStolperstein Model, so the internet connection is preserved
    // Also: Increase the 'Plates found' value in the user defaults by one
    // --------------------------------------------------------------------
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        // The app is running, so show an NSAlertView with the downloaded info
        
        // Start downloading the name of the placemark you entered and then display it
        geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entered Region" message:[NSString stringWithFormat:@"You entered the following region: %@", placemarks[0]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            
        }];
        
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        
        // the app is backgrounded, but got the info that it entered the region, so push a local notification
        UILocalNotification *local = [[UILocalNotification alloc] init];
        local.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        local.timeZone = [NSTimeZone defaultTimeZone];
        local.alertBody = @"You just found a 'Stolperstein'. Congratulations!";
        local.alertAction = @"Show me!";
        local.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
        
    }

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
