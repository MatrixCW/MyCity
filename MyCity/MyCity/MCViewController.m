//
//  MCViewController.m
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import "MCViewController.h"
#import "MCGeoLocationTriplet.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MCViewController ()

@property (weak, nonatomic) IBOutlet UIView *GoogleMapView;
@property GMSMapView *mapView;
@property NSMutableArray *GeoLocationInfo;

- (IBAction)logCenter:(id)sender;

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:self.GoogleMapView.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.GoogleMapView addSubview:self.mapView];
    self.GeoLocationInfo = [[NSMutableArray alloc] init];
    
}

-(void)addGeoInfo{
    
    CGFloat currentLatitude  = self.mapView.camera.target.latitude;
    CGFloat currentLongitude = self.mapView.camera.target.longitude;
    CGFloat currentZoomLevel = self.mapView.camera.zoom;
    
    MCGeoLocationTriplet *tempGeoInfo = [MCGeoLocationTriplet initWithLatitude:currentLatitude
                                                                     Longitude:currentLongitude
                                                                  andZoomLevel:currentZoomLevel];
    
    [self.GeoLocationInfo addObject:tempGeoInfo];
    [self showGeoInfo];
}


-(void)showGeoInfo{
    
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

- (IBAction)logCenter:(id)sender {
    
    [self addGeoInfo];
}
@end
