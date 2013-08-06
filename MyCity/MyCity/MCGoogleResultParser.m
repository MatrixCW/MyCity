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
    NSArray *type = [place[@"address_components"] objectAtIndex:0][@"types"];
    if ([type count] == 0) return  NO;
    else if([[type objectAtIndex:0] isEqualToString:@"locality"] || [[type objectAtIndex:0] isEqualToString:@"sublocality"]){
        return YES;
    }
    return NO;
}


+(BOOL) isACountry:(NSDictionary *)place{
    NSString *formattedName = place[@"formatted_address"];
    NSArray *cityState = [NSArray arrayWithObjects:@"Singapore",@"Monaco",@"Vatican City",nil];
    for(NSString *city in cityState){
        if ([formattedName isEqualToString:city]) return NO;
    }
    NSArray *type = [place[@"address_components"] objectAtIndex:0][@"types"];
    if ([type count] == 0) return NO;
    else if([[type objectAtIndex:0] isEqualToString:@"country"]){
        return YES;
    }
    return NO;
}

@end
