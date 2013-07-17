//
//  MCGeoLocationViewController.m
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import "MCGeoLocationViewController.h"
#import "MCGeoInfoTetrad.h"
@implementation MCGeoLocationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.GeoLocationInfo = [[NSMutableArray alloc] init];
    
    [self performSelector:@selector(updateCityNameTag)
               withObject:nil
               afterDelay:0.3];
    
}


-(void)updateCityNameTag{
    
    self.CityNameTag.text = self.currentCityName;
    self.CityNameTag.textAlignment = NSTextAlignmentCenter;
    
}


-(void)addNewCoordinate{
    
    [self.GeoLocationInfo addObject:[self getCurrentMapViewInfo]];
    
}


-(MCGeoInfoTetrad*)getCurrentMapViewInfo{

    
    return [MCGeoInfoTetrad initWithLatitude:self.MapView.region.center.latitude
                                   Longitude:self.MapView.region.center.longitude
                               latitudeDelta:self.MapView.region.span.latitudeDelta
                           andlongitudeDelta:self.MapView.region.span.longitudeDelta];
    
}


-(void)showNewCoordinate{
    
    for(id object in self.GeoLocationInfo){
        
        if([object isKindOfClass:[MCGeoInfoTetrad class]]){
            MCGeoInfoTetrad *temp = (MCGeoInfoTetrad*)object;
            [temp showInfo];
            
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addGeoInfo:(id)sender {
    
    [self addNewCoordinate];
    
    
    UILabel *newGeoInfoAddedPrompt = [[UILabel alloc] initWithFrame:CGRectMake(73.0, 0.0, 179, 32)];
    newGeoInfoAddedPrompt.textAlignment = NSTextAlignmentCenter;
    newGeoInfoAddedPrompt.textColor = [UIColor redColor];
    newGeoInfoAddedPrompt.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(13.0)];
    [self.MapView addSubview:newGeoInfoAddedPrompt];
    newGeoInfoAddedPrompt.text = @"new coordinate added";

    [UIView animateWithDuration:2
                     animations:^{
                         newGeoInfoAddedPrompt.alpha = 0.0;
                     }
                     completion:^(BOOL finish){
                         [newGeoInfoAddedPrompt removeFromSuperview];
                     }
     ];
}




-(void)setCityName:(NSString*)cityName{
    
    self.currentCityName = cityName;
   
}
- (IBAction)showAddedCoordinates:(id)sender {
}
@end
