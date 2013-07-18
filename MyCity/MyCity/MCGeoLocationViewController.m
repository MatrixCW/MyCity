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
    
    self.remainingSlots = 3;
    

}



#pragma adding coordinates


-(void)addNewCoordinate{
    
    [self.GeoLocationInfo addObject:[self getCurrentMapViewInfo]];
    
}


-(MCGeoInfoTetrad*)getCurrentMapViewInfo{

    
    return [MCGeoInfoTetrad initWithLatitude:self.MapView.region.center.latitude
                                   Longitude:self.MapView.region.center.longitude
                               latitudeDelta:self.MapView.region.span.latitudeDelta
                           andlongitudeDelta:self.MapView.region.span.longitudeDelta];
    
}


-(void) showPrompt{
    
    
    
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

#pragma reset

-(void)resetContent{
    
    [self.GeoLocationInfo removeAllObjects];
    self.remainingSlots = 3;
    
}


#pragma segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:SEGUETONEXT]){
        
        if(self.GeoLocationInfo.count == 0){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot move on to next stage!"
                                                            message:@"You must have at least one set of coordinates added"
                                                           delegate:Nil
                                                  cancelButtonTitle:@"Got it"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
            
        }
    
    }
}


- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}




- (IBAction)GoButtonPressed:(id)sender {
}
@end
