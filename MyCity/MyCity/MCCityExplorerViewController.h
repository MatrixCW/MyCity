//
//  MCRandomLocationViewController.h
//  MyCity
//
//  Created by Cui Wei on 22/7/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TRAutocompleteView.h"
#import "TRGoogleMapsAutocompleteItemsSource.h"
#import "TRGoogleMapsAutocompletionCellFactory.h"

@interface MCCityExplorerViewController : UIViewController<AutoCompleteDelegate, UITextFieldDelegate>


typedef enum {
    RandomExploreMode,
    SpecificExploreMode
} ExploringType ;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property UIView *buttonView;
@property NSString *cityName;
@property NSString *formattedName;
@property NSArray *locationInfo;
@property NSArray *levelOfAdministrations;
@property int currentIndex;
@property UITextField *inputTextField;
@property UIView *blackBackgroundView;
@property ExploringType currentExploringType;

@end
