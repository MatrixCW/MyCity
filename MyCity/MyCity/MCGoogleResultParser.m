//
//  MCGoogleResultParser.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-22.
//
//

#import "MCGoogleResultParser.h"

@implementation MCGoogleResultParser

+(BOOL) isACity:(NSDictionary *)place{
    NSString *formattedName = place[@"formatted_address"];
    NSArray *cityState = [NSArray arrayWithObjects:@"Singapore",@"Monaco",@"Vatican City",nil];
    for(NSString *city in cityState){
        if ([formattedName isEqualToString:city]) return YES;
    }
    NSString *type = [[place[@"address_components"] objectAtIndex:0][@"types"] objectAtIndex:0];
    if([type isEqualToString:@"locality"] || [type isEqualToString:@"sublocality"]){
        return YES;
    }
    return NO;
}
@end
