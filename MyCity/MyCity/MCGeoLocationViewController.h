//
//  MCGeoLocationViewController.h
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import <UIKit/UIKit.h>


@interface MCGeoLocationViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *CityNameTag;


@property NSMutableArray *GeoLocationInfo;
@property NSString *curentCityName;

- (IBAction)addGeoInfo:(id)sender;

-(void)setCityName:(NSString*)cityName;

@end
