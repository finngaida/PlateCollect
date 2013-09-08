//
//  FGStolpersteinFetcher.m
//  PlateCollect
//
//  Created by Daniel Petri on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGStolpersteinFetcher.h"

@implementation FGStolpersteinFetcher
-(NSArray *)parseCSVWithString:(NSString *)csvContent{
    NSMutableArray *objects = [NSMutableArray array];
    NSArray *lines = [csvContent componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        //Vorname,Geburtsname,Nachname,Geburtstag,Adresse,Ortsteil,Deportationstag,Deportationsziel,2.Deportationstag,2.Deportationsziel,3.Deportationstag,3.Deportationsziel,Todestag,Todesort,Lat,Lon(15)
        NSArray *comps = [line componentsSeparatedByString:@","];

        NSNumberFormatter *nf = [NSNumberFormatter new];
        nf.decimalSeparator = @".";
        
        NSNumber *nLat = [nf numberFromString:comps[14]];
        double lat = [nLat doubleValue];
        
        NSNumber *nLon = [nf numberFromString:comps[15]];
        double lon = [nLon doubleValue];
        
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        NSMutableArray *deportations = [NSMutableArray array];
        
        [deportations addObject:@{@"place":comps[6],@"date":comps[7]}];
        [deportations addObject:@{@"place":comps[8],@"date":comps[9]}];
        [deportations addObject:@{@"place":comps[10],@"date":comps[11]}];
        
        
        
        NSArray *deports = [deportations copy];
        
        FGStolperstein *stone = [[FGStolperstein alloc] initWithFirst:comps[0] last:comps[2] born:comps[1] birthday:comps[3] address:comps[4] quarter:comps[5] location:[[CLLocation alloc] initWithLatitude:lat longitude:lon]  deportations:deports locationOfDeath:comps[13] dayOfDeath:comps[12] identifier:comps[16]];
        
        [objects addObject:stone];
        
    }
    return [objects copy];
}
-(NSArray *)fetchNearestStonesAtLocation:(CLLocation *)location Ammount:(NSInteger)ammount{
    NSString *stonesString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"final" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *stones = [self parseCSVWithString:stonesString];
    
    NSMutableDictionary *distances = [NSMutableDictionary dictionary];
    
    
    NSInteger i = 0;
    for (FGStolperstein *stone in stones) {
        [distances setObject:[NSNumber numberWithInteger:i] forKey:[NSNumber numberWithDouble:[stone.location distanceFromLocation:location]]];
        i++;
        
    }
    NSArray *sortedKeys = [[distances allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    for (NSString *key in sortedKeys)[sortedValues addObject: [distances objectForKey: key]];
    
    
    NSMutableArray *nearest = [NSMutableArray array];
    for (NSInteger j = 0; j<=30; j++) {
        
        [nearest addObject:stones[[sortedValues[j] integerValue]]];
    }
    NSLog(@"%@",nearest);
    return [nearest copy];
}
@end
