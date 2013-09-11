//
//  FGWikiRequest.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 08.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGWikiRequest.h"

@implementation FGWikiRequest

+(void)getWiki:(void (^)(NSError *error, NSString *response, NSURL*url))block forStolperstone:(FGStolperstein*)stone {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *response;
        NSError *error;
        NSURL *url;
        
        //Es wird nach dem Namen der Person gesucht
        NSString *searchUrlString = [NSString stringWithFormat:@"http://de.wikipedia.org/w/api.php?action=opensearch&search=%@+%@&limit=10&namespace=0&format=json", stone.firstName, stone.lastName];
        NSURL *searchurl = [NSURL URLWithString:searchUrlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:searchurl];
        
        //Such-Anfrage wird ausgewertet
        NSData *jsonNSData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:jsonNSData
                         options:kNilOptions
                         error:&error];
        NSArray *searchResults = [json objectAtIndex:1];
        
        //Wennn es Suchergebnisse gibt
        if (searchResults.count > 0) {
            NSString *pageTitle = [searchResults objectAtIndex:0];
            //Ein Link für die API wird erstellt
            NSString *pageStringURL = [NSString stringWithFormat:@"http://de.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exlimit=10&exintro=&explaintext=&titles=%@", pageTitle];
            
            //Das Leerzeichen zu einem Plus machen
            pageStringURL = [pageStringURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
            //NSURLRequest starten
            NSURL *pageUrl = [NSURL URLWithString:pageStringURL];
            request = [[NSURLRequest alloc] initWithURL:pageUrl];
            NSData *pageJSON = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            NSDictionary *pageDict = [NSJSONSerialization
                                      JSONObjectWithData:pageJSON
                                      options:kNilOptions
                                      error:&error];
            response =  [[pageDict[@"query"][@"pages"] allObjects] objectAtIndex:0][@"extract"];
            
            //Die der Link für die Desktop-Seite wird generiert
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://de.wikipedia.org/wiki/?curid=%@",[[pageDict[@"query"][@"pages"] allObjects] objectAtIndex:0][@"pageid"]]];
        } else {
            // sad, we can't solve world hunger, but we can let people know what went wrong!
            // init dictionary to be used to populate error object
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Der Artikel dieser Person konnte nicht gefunden werden." forKey:NSLocalizedDescriptionKey];
            // populate the error object with the details
            error = [NSError errorWithDomain:@"wiki" code:404 userInfo:details];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error, response, url);
        });
    });
}


@end