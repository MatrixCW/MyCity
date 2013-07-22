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
    
    self.remainingSlots = 3;
    
    //***************************************** wrap up in setupview
    [self setUpSuggestionView];
    [self addShadowToView:_autocompleteView];
    [self addShadowToView:self.containerView];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    //******************************************************************
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MCMenuViewController class]]){
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    self.InputTextField.delegate = self;
    //[self performSelector:@selector(popupButtonView:) withObject:self.buttonView afterDelay:2];
    
    
}
- (void)setUpButtonView{
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, self.MapView.frame.origin.y + self.MapView.frame.size.height - 200, 200, 80)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonView];
    [self addShadowToView:self.buttonView];
    self.buttonView.layer.opacity = 0.85;
    
}
- (void)popupButtonView:(UIView *)view{
    [UIView animateWithDuration:0.7 animations:^{
        view.center = CGPointMake(view.center.x, view.center.y - 100);
    }];
}

- (void)hideButtonView:(UIView *)view{
    [UIView animateWithDuration:0.7 animations:^{
        view.center = CGPointMake(view.center.x, view.center.y + 100);
    }];
    
}

- (IBAction)SlidingButtonPressed:(id)sender {
    
    if(!self.slidingViewController.addedCoordinates){
        self.slidingViewController.addedCoordinates = [NSMutableArray array];
    }
    
    [self.slidingViewController.addedCoordinates removeAllObjects];
    
    for(id addedCoordinates in self.GeoLocationInfo)
        [self.slidingViewController.addedCoordinates addObject:addedCoordinates];
    
    [self.InputTextField resignFirstResponder];
    
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}




//add shadow to inputfield and autocompleteView.
- (void)addShadowToView:(UIView *)view{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = 0.5f;
    
}

-(void)setUpSuggestionView{
    _autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.InputTextField
                                                         usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2 apiKey:@"INSERT_YOUR_PLACES_API_KEY_HERE"]
                                                         cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc] initWithCellForegroundColor:[UIColor lightGrayColor] fontSize:14]
                                                        presentingIn:self];
    _autocompleteView.geoDelegate = self;
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
    
    
    
    UILabel *newGeoInfoAddedPrompt = [[UILabel alloc] initWithFrame:CGRectMake(73.0, 200.0, 179, 32)];
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


- (void)setUpButtons{
    /*
    for (UIView *view in [self.buttonView subviews]){
        [view removeFromSuperview];
    }
    NSArray *names = [self.formattedCityName componentsSeparatedByString:@", "];
    int nextX = 20;
    for(NSString *name in names){
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(nextX, 20, 80, 40)];
        nextX += 100;
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttonView addSubview:button];
        [button addTarget:self action:@selector(locationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
     */

    
    for(UIView *view in self.buttonView.subviews){
        [view removeFromSuperview];
    }
    
    self.formattedCityNameArray = [self.formattedCityName componentsSeparatedByString:@", "];
    
    
    for(id object in self.formattedCityNameArray){
        NSLog(@"dddfffdfdf %@",(NSString*)object);
    }
    
    UIPickerView *pickRegion = [[UIPickerView alloc] initWithFrame:CGRectMake(25, -40, 150, 80)];
    pickRegion.dataSource = self;
    pickRegion.delegate = self;
    [self.buttonView addSubview:pickRegion];
    
}

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

- (IBAction)locationButtonPressed:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    needResetButtons = false;
    NSString *cityName = button.titleLabel.text;
    self.formattedCityName = cityName;
    [self.InputTextField resignFirstResponder];
    [self getCityGeoInfo];
    
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)content{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:Nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)GoButtonPressed:(id)sender {
    
    needResetButtons = true;
    [self.buttonView removeFromSuperview];
    [self setUpButtonView];
    NSString *cityName = [[[[self.InputTextField.text stringByReplacingOccurrencesOfString:@"          (A Country)" withString:@""]
        stringByReplacingOccurrencesOfString:@"," withString:@" "]
        stringByReplacingOccurrencesOfString:@"  " withString:@" "]
        stringByReplacingOccurrencesOfString:@" " withString:@",+"];
    self.formattedCityName = cityName;
    NSLog(@"%@", cityName);
    [self.InputTextField resignFirstResponder];
    
    if(_autocompleteView.suggestions.count != 0){
        [self getCityGeoInfo];
    } 
    
    else [self showAlertViewWithTitle:@"No Cities Found" message:nil];
    
}



- (void)getCityGeoInfo{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [self.formattedCityName urlEncode]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.geoCodeInfo = JSON;
        NSArray *result = [JSON objectForKey:@"results"];
        
        
        NSDictionary *place = [result objectAtIndex:0];
            
        self.formattedCityName = (NSString *)place[@"formatted_address"];
        self.locationInfo = [self parseGeoInfo:place];
        
        if(needResetButtons)
          [self setUpButtons];
            
        [self.MapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[self.locationInfo objectAtIndex:0] floatValue], [[self.locationInfo objectAtIndex:1] floatValue]), MKCoordinateSpanMake(fabs([[self.locationInfo objectAtIndex:2] floatValue] - [[self.locationInfo objectAtIndex:4] floatValue]), fabs([[self.locationInfo objectAtIndex:3] floatValue] - [[self.locationInfo objectAtIndex:5] floatValue]))) animated:YES];
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
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
    [self GoButtonPressed:Nil];
    [textField resignFirstResponder];
    return NO;
}

- (void)suggestionPressed{
    
    [self GoButtonPressed:nil];
}
@end
