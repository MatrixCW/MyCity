//
//  MCGeoLocationViewController.m
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import "MCGeoLocationViewController.h"
#import "MCGeoLocationTriplet.h"


@implementation MCGeoLocationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
}


-(void)addNewCoordinate{
    
    //CGFloat currentLatitude  = self.mapView.camera.target.latitude;
    //CGFloat currentLongitude = self.mapView.camera.target.longitude;
    //CGFloat currentZoomLevel = self.mapView.camera.zoom;
    
    //MCGeoLocationTriplet *tempGeoInfo = [MCGeoLocationTriplet initWithLatitude:currentLatitude
                                                                    // Longitude:currentLongitude
                                                                 // andZoomLevel:currentZoomLevel];
    
   // [self.GeoLocationInfo addObject:tempGeoInfo];
   //[self showNewCoordinate];
}


-(void)showNewCoordinate{
    
    for(id object in self.GeoLocationInfo){
        
        if([object isKindOfClass:[MCGeoLocationTriplet class]]){
            MCGeoLocationTriplet *temp = (MCGeoLocationTriplet*)object;
            [temp showInfo];
            
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addGeoInfo:(id)sender {
    
    [self addNewCoordinate];
}


-(void)setCityName:(NSString*)cityName{
    self.curentCityName = cityName;
    NSLog(@"cityname text:%@",self.curentCityName);
}
@end
