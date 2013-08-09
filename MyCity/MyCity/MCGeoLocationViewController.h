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

@protocol FormattedAreaNamesReadyToBeShownDelegate

-(void)refreshAreaNamesArray;

@end


@interface MCGeoLocationViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate, AutoCompleteDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UITextField *InputTextField;

- (IBAction)SlidingButtonPressed:(id)sender;

@property UIView *buttonView;
@property NSMutableArray *GeoLocationInfo;
@property NSString *currentCityName;
@property NSString *formattedCityName;
@property NSArray *formattedCityNameArray;
@property NSArray *locationInfo;
@property NSInteger mode;

@property id<FormattedAreaNamesReadyToBeShownDelegate> menuViewDelegate;

@end
