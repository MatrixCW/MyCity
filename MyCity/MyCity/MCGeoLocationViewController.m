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
#import "MCMenuViewController.h"
#import "TRStringExtensions.h"
#import "MCGoogleResultParser.h"
#import "MCUIUtil.h"


#define  GOOGLE_MAP_API @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false"

@implementation MCGeoLocationViewController{
    
    TRAutocompleteView *_autocompleteView;
    BOOL needResetButtons;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    needResetButtons = true;
	// Do any additional setup after loading the view.
    
    self.GeoLocationInfo = [[NSMutableArray alloc] init];
        
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MCMenuViewController class]]){
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
        id menu = self.slidingViewController.underLeftViewController;
        self.menuViewDelegate = menu;
    }
    
    self.InputTextField.delegate = self;
    
    [self setUpViews];
    
}


//set up necessary views for this view controller
-(void)setUpViews{
    
    [self setUpSuggestionView];
    [MCUIUtil addShadowToView:self.containerView];

}

//auto suggestion table field initialization
-(void)setUpSuggestionView{
    _autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.InputTextField
                                                         usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2 apiKey:@"INSERT_YOUR_PLACES_API_KEY_HERE"]
                                                         cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc] initWithCellForegroundColor:[UIColor lightGrayColor] fontSize:14]
                                                        presentingIn:self];
    _autocompleteView.geoDelegate = self;
    [MCUIUtil addShadowToView:_autocompleteView];
}


- (void)setUpButtonView{
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, self.MapView.frame.origin.y + self.MapView.frame.size.height - 100, 280, 80)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonView];
    [MCUIUtil addShadowToView:self.buttonView];
    self.buttonView.layer.opacity = 0.85;
    
}


- (IBAction)SlidingButtonPressed:(id)sender {
    
    [self.InputTextField resignFirstResponder];
    
    [self.menuViewDelegate refreshAreaNamesArray];
    
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (void)setUpButtons{
 

    for(UIView *view in self.buttonView.subviews){
        [view removeFromSuperview];
    }
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(170, 30, 100, 25)];
    [button setTitle:@"Next stage" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:button];
    [button addTarget:self action:@selector(moveToNextStage) forControlEvents:UIControlEventTouchUpInside];
    
    self.formattedCityNameArray = [self.formattedCityName componentsSeparatedByString:@", "];
    
    UIPickerView *pickRegion = [[UIPickerView alloc] initWithFrame:CGRectMake(10, -40, 150, 80)];
    pickRegion.dataSource = self;
    pickRegion.delegate = self;
    [self.buttonView addSubview:pickRegion];
    
}


-(void)moveToNextStage{
    
    NSLog(@"hehehehehehe");
    [self performSegueWithIdentifier:@"LocationToIconicSceen" sender:self];
    
}


#pragma mark UIPICKERVIEW

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.formattedCityNameArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.formattedCityNameArray objectAtIndex:row];
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    
    needResetButtons = false;
    NSString *cityName = [self.formattedCityNameArray objectAtIndex:row];
    self.formattedCityName = cityName;
    [self.InputTextField resignFirstResponder];
    [self getCityGeoInfo];
}



- (void)startQueryingAndZooming{
    
    needResetButtons = true;
    [self.buttonView removeFromSuperview];
    NSString *cityName = [self.InputTextField.text stringByReplacingOccurrencesOfString:@"          (A Country)" withString:@""];
    self.formattedCityName = cityName;
    NSLog(@"%@", cityName);
    [self.InputTextField resignFirstResponder];
    
    if(_autocompleteView.suggestions.count != 0){
        [self getCityGeoInfo];
        [self setUpButtonView];
    }
    
    else [MCUIUtil showAlertViewWithTitle:@"NO CITIES FOUND !"
                                  message:Nil
                                 delegare:Nil
                        cancelButtonTitle:@"OK"
                         otherButtonTitle:Nil];
    
}



- (void)getCityGeoInfo{
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:GOOGLE_MAP_API, [self.formattedCityName urlEncode]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            NSArray *result = [JSON objectForKey:@"results"];
                                                                                            NSDictionary *place = [result objectAtIndex:0];
                                                                                            
                                                                                            if([MCGoogleResultParser isACountry:place] && needResetButtons){
                                                                                                
                                                                                                [MCUIUtil showAlertViewWithTitle:@"A Country Entered"
                                                                                                                         message:[NSString stringWithFormat:@"Please Enter a City in %@",(NSString *)place[@"formatted_address"]]
                                                                                                                        delegare:Nil
                                                                                                               cancelButtonTitle:@"OK"
                                                                                                                otherButtonTitle:Nil];
                                                                                            }
                                                                                            self.formattedCityName = (NSString *)place[@"formatted_address"];
                                                                                            self.locationInfo = [self parseGeoInfo:place];
                                                                                            
                                                                                            if(needResetButtons)
                                                                                                [self setUpButtons];
                                                                                            
                                                                                            CGFloat locationLat  = [[self.locationInfo objectAtIndex:0] floatValue];
                                                                                            CGFloat locationLng  = [[self.locationInfo objectAtIndex:1] floatValue];
                                                                                            CGFloat northEastLat = [[self.locationInfo objectAtIndex:2] floatValue];
                                                                                            CGFloat northEastLng = [[self.locationInfo objectAtIndex:3] floatValue];
                                                                                            CGFloat southWestLat = [[self.locationInfo objectAtIndex:4] floatValue];
                                                                                            CGFloat southWestLng = [[self.locationInfo objectAtIndex:5] floatValue];
                                                                                            
                                                                                            
                                                                                            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(locationLat,locationLng);
                                                                                            MKCoordinateSpan span = MKCoordinateSpanMake(fabs(northEastLat-southWestLat), fabs(northEastLng-southWestLng));
                                                                                            MKCoordinateRegion showingRegion = MKCoordinateRegionMake(center, span);
                                                                                            
                                                                                            [self.MapView setRegion:showingRegion animated:YES];
                                                                                            
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                                            
                                                                                            NSLog(@"fail to get city info: %@",error.description);
                                                                                        }];
    [operation start];
    
}



- (NSArray *)parseGeoInfo:(NSDictionary *)place{
    NSNumber *locationLat = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lat"] floatValue]];
    NSNumber *locationLng = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lng"] floatValue]];
    NSNumber *northEastLat =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lat"] floatValue]];
    NSNumber *northEastLng =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lng"] floatValue]];
    NSNumber *southWestLat = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lat"] floatValue]];
    NSNumber *southWestLng = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lng"] floatValue]];
    return [NSArray arrayWithObjects:locationLat, locationLng,northEastLat, northEastLng, southWestLat, southWestLng, nil];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.InputTextField isFirstResponder] && [touch view] != self.InputTextField) {
        [self.InputTextField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self startQueryingAndZooming];
    [textField resignFirstResponder];
    return NO;
}


- (void)suggestionPressed{
    
    [self startQueryingAndZooming];
}


@end
