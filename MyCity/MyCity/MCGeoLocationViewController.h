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

@protocol AutoCompleteDelegate
- (void)suggestionPressed;
@end

@interface MCGeoLocationViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, AutoCompleteDelegate>
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
- (IBAction)homeButtonPressed:(id)sender;

- (IBAction)GoButtonPressed:(id)sender;
- (IBAction)SlidingButtonPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property UIView *buttonView;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UITextField *InputTextField;


@property NSMutableArray *GeoLocationInfo;
@property NSString *currentCityName;

@property NSString *formattedCityName;
@property NSArray *formattedCityNameArray;

@property int remainingSlots;
@property NSArray *locationInfo;
@property NSArray *geoCodeInfo;
@property NSInteger mode;





@end
