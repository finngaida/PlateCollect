//
//  FGStolperstein.h
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface FGStolperstein : NSObject



@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)NSString *lastName;
@property(nonatomic,strong)NSString *bornName;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSDate *birthday;
@property(nonatomic,strong)NSString *quarter;
@property(nonatomic,strong)NSArray *deportations;
@property(nonatomic,strong)NSString *placeOfDeath;
@property(nonatomic,strong)NSDate *dayOfDeath;

@property(nonatomic,strong)CLRegion *region;

-(instancetype)initWithFirst:(NSString *)firstName
                        last:(NSString *)lastName
                        born:(NSString *)bornName
                    birthday:(NSString *)birthday
                     address:(NSString *)address
                     quarter:(NSString *)quarter
                deportations:(NSArray *)deportations //Of NSDictionary <Date:Place>
             locationOfDeath:(NSString *)placeOfDeath
                  dayOfDeath:(NSString *)dayOfDeath; //designated initializer

@end
