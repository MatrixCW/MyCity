//
//  MCGeoLocationViewController.m
//  MyCity
//
//  Created by Cui Wei on 16/7/13.
//
//

#import "MCGeoLocationViewController.h"
#import "MCGeoInfoTetrad.h"
#import "TRAutocompleteView.h"
#import "TRGoogleMapsAutocompleteItemsSource.h"
#import "TRGoogleMapsAutocompletionCellFactory.h"
#import "AFJSONRequestOperation.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "MCGeoInfoTableViewMessenger.h"

@implementation MCGeoLocationViewController{
    
    TRAutocompleteView *_autocompleteView;
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.GeoLocationInfo = [[NSMutableArray alloc] init];
    
    self.remainingSlots = 3;
    
    [self setUpSuggestionView];
    [self addShadowToView];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]){
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    

    
}

- (IBAction)SlidingButtonPressed:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}




//add shadow to inputfield and autocompleteView.
- (void)addShadowToView{
    self.InputTextField.layer.masksToBounds = NO;
    self.InputTextField.layer.shadowColor = [UIColor blackColor].CGColor;
    self.InputTextField.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.InputTextField.layer.shadowOpacity = 0.5f;
    _autocompleteView.layer.masksToBounds = NO;
    _autocompleteView.layer.shadowColor = [UIColor blackColor].CGColor;
    _autocompleteView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _autocompleteView.layer.shadowOpacity = 0.5f;
}

-(void)setUpSuggestionView{
    _autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.InputTextField
                                                         usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2 apiKey:@"INSERT_YOUR_PLACES_API_KEY_HERE"]
                                                         cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc] initWithCellForegroundColor:[UIColor lightGrayColor] fontSize:14]
                                                        presentingIn:self];
}


#pragma adding coordinates


-(void)addNewCoordinate{
    
    [self.GeoLocationInfo addObject:[self getCurrentMapViewInfo]];
    [MCGeoInfoTableViewMessenger inputData:self.GeoLocationInfo];
    
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
    NSString *cityName = [[[self.InputTextField.text stringByReplacingOccurrencesOfString:@"," withString:@" "] stringByReplacingOccurrencesOfString:@"  " withString:@" "] stringByReplacingOccurrencesOfString:@" " withString:@",+"];
    self.formattedCityName = cityName;
    [self.InputTextField resignFirstResponder];
    [self getCityGeoInfo];
    
}



- (void)getCityGeoInfo
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", self.formattedCityName]];
    NSLog(@"url: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *result = [JSON objectForKey:@"results"];
        for (NSDictionary *place in result){
            self.locationInfo = [self parseGeoInfo:place];
            NSLog(@"%@", self.locationInfo);
            [self.MapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[self.locationInfo objectAtIndex:0] floatValue], [[self.locationInfo objectAtIndex:1] floatValue]), MKCoordinateSpanMake(fabs([[self.locationInfo objectAtIndex:2] floatValue] - [[self.locationInfo objectAtIndex:4] floatValue]), fabs([[self.locationInfo objectAtIndex:3] floatValue] - [[self.locationInfo objectAtIndex:5] floatValue]))) animated:YES];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
        NSLog(@"fail to get city info: %@",error.description);
    }];
    
    [operation start];
}


- (NSArray *)parseGeoInfo:(NSDictionary *)place {
    NSNumber *locationLat = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lat"] floatValue]];
    NSNumber *locationLng = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lng"] floatValue]];
    NSNumber *northEastLat =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lat"] floatValue]];
    NSNumber *northEastLng =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lng"] floatValue]];
    NSNumber *southWestLat = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lat"] floatValue]];
    NSNumber *southWestLng = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lng"] floatValue]];
    return [NSArray arrayWithObjects:locationLat, locationLng,northEastLat, northEastLng, southWestLat, southWestLng, nil];
}



@end
