//
//  FGStolperstein.m
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGStolperstein.h"


@implementation FGStolperstein
@synthesize identifier = _identifier;
@synthesize visited = _visited;

-(instancetype)initWithFirst:(NSString *)firstName last:(NSString *)lastName born:(NSString *)bornName birthday:(NSString *)birthday address:(NSString *)address quarter:(NSString *)quarter location:(CLLocation *)location deportations:(NSArray *)deportations locationOfDeath:(NSString *)placeOfDeath dayOfDeath:(NSString *)dayOfDeath identifier:(int )identifier visited:(BOOL)visited {
    
    self = [super init];
    
    self.firstName = firstName;
    self.lastName = lastName;
    self.bornName = bornName;
    
    NSDateFormatter *formatter = [FGStolperstein basicDateFormatter];
    
    self.birthday = [formatter dateFromString:birthday];
    
    self.address = address;
    self.quarter = quarter;
    
    self.location = location;
    
    self.deportations = deportations;
    
    self.placeOfDeath = placeOfDeath;
    self.dayOfDeath = [formatter dateFromString:dayOfDeath];
    _identifier = identifier;
    _visited = visited;
    return self;


}


-(instancetype)initWithFirstname:(NSString*)firstName
                        lastname:(NSString*)lastname
                        location:(CLLocation*)location
                      identifier:(int)identifier
                         visited:(BOOL)visited {
    self = [super init];
    
    self.firstName = firstName;
    self.lastName = lastname;
    self.location = location;
    _identifier = identifier;
    _visited = visited;
    
    return self;
}
+(NSDateFormatter*)basicDateFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return formatter;
}


@end
