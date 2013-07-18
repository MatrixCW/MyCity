//
//  MCGeoLocationViewController.h
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define SEGUETONEXT @"GeoLocationToIconicPlace"

@interface MCGeoLocationViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *CityNameTag;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@property NSMutableArray *GeoLocationInfo;
@property NSString *currentCityName;
@property int remainingSlots;


- (IBAction)addGeoInfo:(id)sender;

-(void)setCityName:(NSString*)cityName;

@end
