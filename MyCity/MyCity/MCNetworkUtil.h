//
//  MCNetworkUtil.h
//  MyCity
//
//  Created by Cui Wei on 10/8/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


typedef enum {
    
    queryCityNameToGetFormattedAddress,
    queryFormattedAddressToGetMapRegion
    
} queryGoogleMapApiType;




@protocol queryHasCompletedDelegate

- (void)queryFinishedWithType:(queryGoogleMapApiType) type;

@end


@interface MCNetworkUtil : NSObject

@property NSArray *formattedAddresses;
@property MKCoordinateRegion mapRegion;


@property id<queryHasCompletedDelegate> myDelegate;

+ (MCNetworkUtil *)getSharedInstance;

- (void)queryEachAreaAndShowOnMap:(NSString *)cityNamesToQuery mode: (queryGoogleMapApiType) type;

@end
