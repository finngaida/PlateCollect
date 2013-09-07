//
//  FGTimelineView.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGTimelineView.h"

@implementation FGTimelineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithDeportations:(NSArray*)deportations withLocationOfDeath:(NSString*)location withDayOfDeath:(NSString*)day
{
    self = [super init];
    if (self) {
        for (NSDictionary *dic in deportations) {
            <#statements#>
        }
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
