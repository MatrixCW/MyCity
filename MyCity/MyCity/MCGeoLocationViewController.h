//
//  MCGeoLocationViewController.h
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MCGeoLocationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *GoolgeMapView;

@property GMSMapView *mapView;
@property NSMutableArray *GeoLocationInfo;

@property NSString *curentCityName;

- (IBAction)addGeoInfo:(id)sender;

-(void)setCityName:(NSString*)cityName;

@end
