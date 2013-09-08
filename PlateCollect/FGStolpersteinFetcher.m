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
        
        
        
        
        FGStolperstein *stone = [[FGStolperstein alloc] initWithFirst:comps[0] last:comps[2] born:comps[1] birthday:comps[3] address:comps[4] quarter:comps[5] location:[[CLLocation alloc] initWithLatitude:lat longitude:lon]  deportations:nil locationOfDeath:comps[13] dayOfDeath:comps[12]];
        
        [objects addObject:stone];
        
        //TODO: Deportations!!!
    }
    return [objects copy];
}
-(NSArray *)fetchNearestStonesAtLocation:(CLLocation *)location Ammount:(NSInteger)ammount{
    NSString *stonesString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"final" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray __unused *stones = [self parseCSVWithString:stonesString];
    
    return @[]; //TODO: Filter nearest ones
}
@end
