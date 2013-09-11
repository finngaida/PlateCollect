//
//  FGWikiRequest.h
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 08.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGStolperstein.h"

@interface FGWikiRequest : NSObject

+(void)getWiki:(void (^)(NSError *error, NSString *response, NSURL *url))block forStolperstone:(FGStolperstein*)stone;

@end
