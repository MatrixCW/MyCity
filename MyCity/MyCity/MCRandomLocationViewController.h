//
//  MCRandomLocationViewController.h
//  MyCity
//
//  Created by Cui Wei on 22/7/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MCRandomLocationViewController : UIViewController

@property NSString *cityName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property UIView *buttonView;

@end
