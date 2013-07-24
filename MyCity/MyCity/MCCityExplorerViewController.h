//
//  MCRandomLocationViewController.h
//  MyCity
//
//  Created by Cui Wei on 22/7/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MCCityExplorerViewController : UIViewController


typedef enum {
    RandomExploreMode,
    SpecificExploreMode
} ExploringType ;


- (IBAction)homeButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property NSString *cityName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property UIView *buttonView;
@property NSString *formattedName;
@property NSArray *locationInfo;
@property NSArray *names;
@property int currentIndex;

@property ExploringType currentExploringType;

@end
