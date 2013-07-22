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

@interface MCGeoLocationViewController : UIViewController<UITextFieldDelegate>

- (IBAction)GoButtonPressed:(id)sender;
- (IBAction)SlidingButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property UIView *buttonView;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UITextField *InputTextField;


@property NSMutableArray *GeoLocationInfo;
@property NSString *currentCityName;
@property NSString *formattedCityName;
@property int remainingSlots;
@property NSArray *locationInfo;
@property NSArray *geoCodeInfo;
@property NSInteger mode;





@end
