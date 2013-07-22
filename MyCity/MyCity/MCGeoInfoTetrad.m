//
//  MCGeoInfoTetrad.m
//  MyCity
//
//  Created by Cui Wei on 17/7/13.
//
//

#import "MCGeoInfoTetrad.h"

@interface MCGeoInfoTetrad()

@property (readwrite) CGFloat latitude;
@property (readwrite) CGFloat longitude;
@property (readwrite) CGFloat latitudeDelta;
@property (readwrite) CGFloat longitudeDelta;


@end


@implementation MCGeoInfoTetrad


+(MCGeoInfoTetrad*) initWithLatitude:(CGFloat)latitude
                           Longitude:(CGFloat)longitude
                       latitudeDelta:(CGFloat)latitudeDelta
                   andlongitudeDelta:(CGFloat)longitudeDelta{
    
    MCGeoInfoTetrad *temp = [[super alloc] init];
    
    if(temp){
        temp.latitude = latitude;
        temp.longitude = longitude;
        temp.latitudeDelta = latitudeDelta;
        temp.longitudeDelta = longitudeDelta;
    }
    
    return temp;
}

-(void)showInfo{
    NSLog(@"%lf %lf %lf %lf", self.latitude, self.longitude, self.latitudeDelta, self.longitudeDelta);
}


-(MKCoordinateRegion)specifiedRegion{
    
    MKCoordinateRegion myRegion;
    myRegion.center.latitude = self.latitude;
    myRegion.center.longitude = self.longitude;
    myRegion.span.latitudeDelta = self.latitudeDelta;
    myRegion.span.longitudeDelta = self.longitudeDelta;
    
    return myRegion;
    
}


@end
