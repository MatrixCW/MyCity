//
//  MCGoogleResultParser.h
//  MyCity
//
//  Created by Chen Zeyu on 13-7-22.
//
//

#import <Foundation/Foundation.h>

@interface MCGoogleResultParser : NSObject
+ (BOOL) isACity:(NSDictionary *)place;
+ (BOOL) isACountry:(NSDictionary *)place;

@end
