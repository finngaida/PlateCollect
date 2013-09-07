//
//  FGStolperstein.h
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface FGStolperstein : NSObject



@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSDate *birthday;
@property(nonatomic,strong)NSString *quarter;
@property(nonatomic,strong)NSArray *deportations;
@property(nonatomic,strong)NSString *placeOfDeath;
@property(nonatomic,strong)NSDate *dayOfDeath;


-(instancetype)initWithFirst:(NSString *)firstName
                        last:(NSString *)lastName
                        born:(NSString *)bornName
                    birthday:(NSString *)birthday
                     address:(NSString *)address
                     quarter:(NSString *)quarter
                deportations:(NSArray *)deportations //Of NSDictionary <Date:Place>
             locationOfDeath:(NSString *)placeOfDeath
                  dayOfDeath:(NSString *)dayOfDeath; //designated initializer

-(CLRegion *)regionForAddress;
@end