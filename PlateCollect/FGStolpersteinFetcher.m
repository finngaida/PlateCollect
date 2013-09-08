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
        
        NSArray *deports = @[@{@"place":comps[6],@"date":[formatter dateFromString:comps[7]]},@{@"place":comps[8],@"date":[formatter dateFromString:comps[9]]},@{@"place":comps[10],@"date":[formatter dateFromString:comps[11]]}];
        
        
        FGStolperstein *stone = [[FGStolperstein alloc] initWithFirst:comps[0] last:comps[2] born:comps[1] birthday:comps[3] address:comps[4] quarter:comps[5] location:[[CLLocation alloc] initWithLatitude:lat longitude:lon]  deportations:deports locationOfDeath:comps[13] dayOfDeath:comps[12]];
        
        [objects addObject:stone];
        
    }
    return [objects copy];
}
-(NSArray *)fetchNearestStonesAtLocation:(CLLocation *)location Ammount:(NSInteger)ammount{
    NSString *stonesString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"final" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *stones = [self parseCSVWithString:stonesString];
    return [stones objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, ammount)]];
}
@end
