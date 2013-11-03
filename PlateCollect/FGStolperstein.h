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


@property(nonatomic,readwrite)int identifier;
@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)NSString *lastName;
@property(nonatomic,strong)NSString *bornName;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSDate *birthday;
@property(nonatomic,strong)NSString *quarter;
@property(nonatomic,strong)NSArray *deportations;
@property(nonatomic,strong)NSString *placeOfDeath;
@property(nonatomic,strong)NSDate *dayOfDeath;

@property(nonatomic,readwrite)BOOL visited;
@property(nonatomic,strong)CLLocation *location;
@property(nonatomic,strong)CLRegion *region;

-(instancetype)initWithFirst:(NSString *)firstName
                        last:(NSString *)lastName
                        born:(NSString *)bornName
                    birthday:(NSString *)birthday
                     address:(NSString *)address
                     quarter:(NSString *)quarter
                    location:(CLLocation *)location
                deportations:(NSArray *)deportations //Of NSDictionary <@"date":NSDate Date
                                                                    //  @"place":"NSString Place>
             locationOfDeath:(NSString *)placeOfDeath
                  dayOfDeath:(NSString *)dayOfDeath
                  identifier:(int)identifier
                     visited:(BOOL)visited; //designated initializer

-(instancetype)initWithFirstname:(NSString*)firstName
                        lastname:(NSString*)lastname
                        location:(CLLocation*)location
                      identifier:(int)identifier
                         visited:(BOOL)visited;

+(NSDateFormatter*)basicDateFormatter;

@end
