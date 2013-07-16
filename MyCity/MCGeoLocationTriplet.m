//
//  MCGeoLocationTriplet.m
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import "MCGeoLocationTriplet.h"


@interface MCGeoLocationTriplet()

@property (readwrite) CGFloat latitude;
@property (readwrite) CGFloat longitude;
@property (readwrite) CGFloat zoomLevel;


@end

@implementation MCGeoLocationTriplet

+(MCGeoLocationTriplet*) initWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude andZoomLevel:(CGFloat)zoomLevel{
    
    MCGeoLocationTriplet *temp = [[super alloc] init];
    
    if(temp){
        temp.latitude = latitude;
        temp.longitude = longitude;
        temp.zoomLevel = zoomLevel;
    }
    
    return temp;
}

-(void)showInfo{
    NSLog(@"%lf %lf %lf", self.latitude, self.longitude, self.zoomLevel);
}

@end
