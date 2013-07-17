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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:self.GoolgeMapView.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.GoolgeMapView addSubview:self.mapView];
    self.GeoLocationInfo = [[NSMutableArray alloc] init];
    self.CityNameTag.text = self.curentCityName;
    
}


-(void)addNewCoordinate{
    
    CGFloat currentLatitude  = self.mapView.camera.target.latitude;
    CGFloat currentLongitude = self.mapView.camera.target.longitude;
    CGFloat currentZoomLevel = self.mapView.camera.zoom;
    
    MCGeoLocationTriplet *tempGeoInfo = [MCGeoLocationTriplet initWithLatitude:currentLatitude
                                                                     Longitude:currentLongitude
                                                                  andZoomLevel:currentZoomLevel];
    
    [self.GeoLocationInfo addObject:tempGeoInfo];
    [self showNewCoordinate];
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
    NSLog(@"%@",cityName);
    self.curentCityName = cityName;
    NSLog(@"cityname text:%@",self.curentCityName);
}
@end
