//
//  FGWikiRequest.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 08.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGWikiRequest.h"

@implementation FGWikiRequest

+(void)getWiki:(void (^)(NSError *error, NSString *response))block forStolperstone:(FGStolperstein*)stone {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *response;
        NSError *error;
        
        
        //Es wird nach dem Namen der Person gesucht
        NSString *searchString = [NSString stringWithFormat:@"%@+%@", stone.firstName, stone.lastName];
        NSString *urlString = [NSString stringWithFormat:@"http://de.wikipedia.org/w/api.php?action=opensearch&search=%@&limit=10&namespace=0&format=jsonfm", searchString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSData *jsonNSData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:jsonNSData
                              options:kNilOptions 
                              error:&error];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error, response);
        });
    });
}


@end
