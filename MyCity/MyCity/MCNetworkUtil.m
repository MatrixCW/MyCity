//
//  MCNetworkUtil.m
//  MyCity
//
//  Created by Cui Wei on 10/8/13.
//
//

#import "MCNetworkUtil.h"
#import "AFJSONRequestOperation.h"
#import "TRStringExtensions.h"

#define GOOGLE_MAP_API_ADDRESS @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false"


@implementation MCNetworkUtil

static MCNetworkUtil *sharedInstance;


+ (MCNetworkUtil *)getSharedInstance{
    
    if(! sharedInstance){
        
        sharedInstance = [[MCNetworkUtil alloc] init];
    }
    
    return sharedInstance;
    
}


- (void)queryEachAreaAndShowOnMap:(NSString *)addressNameToQuery mode: (queryGoogleMapApiType) type{
    
    
    
    NSString *encodedAreaName = [addressNameToQuery urlEncode];
    NSString *queryGoogleMapUrl = [NSString stringWithFormat:GOOGLE_MAP_API_ADDRESS, encodedAreaName];
    NSURL *url = [NSURL URLWithString: queryGoogleMapUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                            
                                                                                            
                                                                                            if(type == queryCityNameToGetFormattedAddress){
                                                                                                
                                                                                                NSArray *result = [JSON objectForKey:@"results"];
                                                                                                NSDictionary *place = [result objectAtIndex:0];
                                                                                                NSString *formattedName = (NSString *)place[@"formatted_address"];
                                                                                                self.formattedAddresses = [formattedName componentsSeparatedByString:@", "];
                                                                                                
                                                                                                [self.myDelegate queryFinishedWithType:queryCityNameToGetFormattedAddress];
                                                                                            }
                                                                                            
                                                                                            else{
                                                                                            
                                                                                                NSArray *result = [JSON objectForKey:@"results"];
                                                                                                NSDictionary *place = [result objectAtIndex:0];
                                                                                                NSArray *location = [self getGeoCoordinatesForPlace:place];
                                                                                            
                                                                                                CGFloat locationLat  = [[location objectAtIndex:0] floatValue];
                                                                                                CGFloat locationLng  = [[location objectAtIndex:1] floatValue];
                                                                                                CGFloat northEastLat = [[location objectAtIndex:2] floatValue];
                                                                                                CGFloat northEastLng = [[location objectAtIndex:3] floatValue];
                                                                                                CGFloat southWestLat = [[location objectAtIndex:4] floatValue];
                                                                                                CGFloat southWestLng = [[location objectAtIndex:5] floatValue];
                                                                                            
                                                                                            
                                                                                                CLLocationCoordinate2D center = CLLocationCoordinate2DMake(locationLat,locationLng);
                                                                                                MKCoordinateSpan span = MKCoordinateSpanMake(fabs(northEastLat-southWestLat), fabs(northEastLng-southWestLng));
                                                                                                MKCoordinateRegion showingRegion = MKCoordinateRegionMake(center, span);
                                                                                                self.mapRegion = showingRegion;
                                                                                                
                                                                                                [self.myDelegate queryFinishedWithType:queryFormattedAddressToGetMapRegion];

                                                                                            }
                                                                                            
                                                                                                                                                                                        
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                                            
                                                                                            NSLog(@"fail to get city info: %@",error.description);
                                                                                        }];
    [operation start];
    
}


- (NSArray *)getGeoCoordinatesForPlace:(NSDictionary *)place{
    
    NSNumber *locationLat = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lat"] floatValue]];
    NSNumber *locationLng = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lng"] floatValue]];
    NSNumber *northEastLat =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lat"] floatValue]];
    NSNumber *northEastLng =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lng"] floatValue]];
    NSNumber *southWestLat = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lat"] floatValue]];
    NSNumber *southWestLng = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lng"] floatValue]];
    return [NSArray arrayWithObjects:locationLat, locationLng,northEastLat, northEastLng, southWestLat, southWestLng, nil];
    
}


@end
