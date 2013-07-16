//
//  MCGeoLocationTriplet.h
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import <Foundation/Foundation.h>

@interface MCGeoLocationTriplet : NSObject

@property (readonly) CGFloat latitude;
@property (readonly) CGFloat longitude;
@property (readonly) CGFloat zoomLevel;

+(MCGeoLocationTriplet*) initWithLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude andZoomLevel:(CGFloat)zoomLevel;
-(void)showInfo;
@end
