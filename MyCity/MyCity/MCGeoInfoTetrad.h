//
//  MCGeoInfoTetrad.h
//  MyCity
//
//  Created by Cui Wei on 17/7/13.
//
//

#import <Foundation/Foundation.h>

@interface MCGeoInfoTetrad : NSObject

@property (readonly) CGFloat latitude;
@property (readonly) CGFloat longitude;
@property (readonly) CGFloat latitudeDelta;
@property (readonly) CGFloat longitudeDelta;

+(MCGeoInfoTetrad*) initWithLatitude:(CGFloat)latitude
                           Longitude:(CGFloat)longitude
                       latitudeDelta:(CGFloat)latitudeDelta
                   andlongitudeDelta:(CGFloat)longitudeDelta;

-(void)showInfo;

@end
