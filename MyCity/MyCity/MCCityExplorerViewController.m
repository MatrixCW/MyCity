//
//  MCRandomLocationViewController.m
//  MyCity
//
//  Created by Cui Wei on 22/7/13.
//
//

#import "MCCityExplorerViewController.h"
#import "AFJSONRequestOperation.h"
#import "MCWebViewController.h"
#import "TRStringExtensions.h"
#import "MCUIUtil.h"


#define GOOGLE_MAP_API_ADDRESS @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false"


@interface MCCityExplorerViewController ()

@end

@implementation MCCityExplorerViewController{
    
    TRAutocompleteView *_autocompleteView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self queryExploringMode];
        
}


-(void)queryExploringMode{
    
    [self initBlackCoverView];
    
    UIButton *randomExploring = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [randomExploring addTarget:self
                        action:@selector(setRandomExplorerMode)
              forControlEvents:UIControlEventTouchUpInside];
    
    [randomExploring setTitle:@"Explore a random city" forState:UIControlStateNormal];

    
    randomExploring.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    
    
    UIButton *specificExploring = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [specificExploring addTarget:self
                          action:@selector(setSpecificExplorerMode)
                forControlEvents:UIControlEventTouchUpInside];
    
    [specificExploring setTitle:@"Explore a specific city" forState:UIControlStateNormal];
    
    specificExploring.frame = CGRectMake(80.0, 280.0, 160.0, 40.0);
    
    [self.blackBackgroundView  addSubview:randomExploring];
    [self.blackBackgroundView  addSubview:specificExploring];
    
    [self.mapView addSubview:self.blackBackgroundView];
    
}

-(void) initBlackCoverView{
    
    self.blackBackgroundView = [[UIView alloc] initWithFrame:self.mapView.bounds];
    self.blackBackgroundView.backgroundColor = [UIColor blackColor];
    self.blackBackgroundView.alpha = 0.8;

    
}


#pragma mark RANDOM VIEWING MODE CODE

-(void)setRandomExplorerMode{
    
    [self.blackBackgroundView removeFromSuperview];
    [self EnterRandomExploreMode];
    
}


-(void)EnterRandomExploreMode{
    
    [self generateRandomCityName];
    [self getCityGeoInfo];
    
}

-(void)generateRandomCityName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:Nil];
    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    int randomCityIndex = arc4random()%34;
    NSString *currentCity = [lines objectAtIndex:randomCityIndex];
    int start = [currentCity rangeOfString:@" "].location;
    int end = [currentCity rangeOfString:@","].location;
    NSRange range;
    range.location = start;
    range.length = end-start;
    self.cityName = [currentCity substringWithRange:range];
    NSLog(@"generated names:%@", self.cityName);
    
}


/* This method query google map api to obtain an array of formatted 
   information about a city. Forexample, if self.cityName is "Lima", 
   self.formattedName will be "Lima, Peru",and self.levelOfAdministrations 
   will contain two objects, the first is "Lima", and the second is "Peru"
*/
- (void)getCityGeoInfo{
    
    NSString *encodedCityName = [self.cityName urlEncode];
    NSString *googleMapUrl = [NSString stringWithFormat:GOOGLE_MAP_API_ADDRESS, encodedCityName];
    NSURL *url = [NSURL URLWithString: googleMapUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                                                        {
                                                                                           NSArray *result = [JSON objectForKey:@"results"];
                                                                                           NSDictionary *place = [result objectAtIndex:0];
                                                                                           self.formattedName = (NSString *)place[@"formatted_address"];
                                                                                           self.levelOfAdministrations = [self.formattedName componentsSeparatedByString:@", "];
                                                                                           self.currentIndex = self.levelOfAdministrations.count - 1;
                                                                                           [self promptTakingToCity:self.levelOfAdministrations];
        
                                                                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                    
                                                                                                 NSLog(@"fail to get city info: %@",error.description);
                                                                                         }];
    
    [operation start];
}

-(void)promptTakingToCity:(NSArray*)details{
    
    int levelsOfLocation = details.count;
    NSMutableString *infoString = [NSMutableString stringWithCapacity:15];
    [infoString appendString:@"Taking you to "];
    
    for(int i = 0; i < levelsOfLocation; i++){
        [infoString appendString:@"\n\n"];
        [infoString appendString:[details objectAtIndex:i]];
        
    }
    
    [self initBlackCoverView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(36, 145, 248, 200)];
    prompt.numberOfLines = 0;
    
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.textColor = [UIColor whiteColor];
    prompt.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(13.0)];
    [self.blackBackgroundView addSubview:prompt];
    prompt.text = infoString;
    
    [self.mapView addSubview:self.blackBackgroundView];
    
    [UIView animateWithDuration:6
                     animations:^{
                         self.blackBackgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL finish){
                         
                         [self.blackBackgroundView removeFromSuperview];
                         self.blackBackgroundView = Nil;
                         [self queryEachAreaAndShowOnMap];
                         
                     }
     ];

}

- (void)queryEachAreaAndShowOnMap{
    
    
    if(self.currentIndex < 0){
        
        [self performSelector:@selector(setUpButtonView) withObject:nil afterDelay:3];
        return;
    }
    
    NSString *cityNamesToQuery = @"";
    
    
    //fix bug of wrong cities
    for(int i = self.currentIndex; i < self.levelOfAdministrations.count; i ++){
    
        cityNamesToQuery = [cityNamesToQuery stringByAppendingString:[self.levelOfAdministrations objectAtIndex:i]];
        cityNamesToQuery = [cityNamesToQuery stringByAppendingString:@" "];

        
    }
        
    NSString *encodedAreaName = [cityNamesToQuery urlEncode];
    NSString *queryGoogleMapUrl = [NSString stringWithFormat:GOOGLE_MAP_API_ADDRESS, encodedAreaName];
    NSURL *url = [NSURL URLWithString: queryGoogleMapUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                         
                                                                                            NSArray *result = [JSON objectForKey:@"results"];
                                                                                            NSDictionary *place = [result objectAtIndex:0];
                                                                                            NSArray *location = [self getGeoCoordinatesForPlace:place];
                                                                                            
                                                                                            CGFloat locationLat  = [[location objectAtIndex:0] floatValue];
                                                                                            CGFloat locationLng  = [[location objectAtIndex:1] floatValue];
                                                                                            CGFloat northEastLat = [[location objectAtIndex:2] floatValue];
                                                                                            CGFloat northEastLng = [[location objectAtIndex:3] floatValue];
                                                                                            CGFloat southWestLat = [[location objectAtIndex:4] floatValue];
                                                                                            CGFloat southWestLng = [[location objectAtIndex:5] floatValue];

                                                                                            
                                                                                            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(locationLat,locationLng);
                                                                                            MKCoordinateSpan span = MKCoordinateSpanMake(fabs(northEastLat-southWestLat), fabs(northEastLng-southWestLng));
                                                                                            MKCoordinateRegion showingRegion = MKCoordinateRegionMake(center, span);
                                                                                        
                                                                                            [self.mapView setRegion:showingRegion animated:YES];
        
                                                                                            [self performSelector:@selector(queryEachAreaAndShowOnMap)
                                                                                                       withObject:nil afterDelay:3];
                                                                                            
                                                                                            self.currentIndex -- ;
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                                            
                                                                                            NSLog(@"fail to get city info: %@",error.description);
                                                                                        }];
    [operation start];
    
}


- (NSArray *)getGeoCoordinatesForPlace:(NSDictionary *)place{
    
    NSNumber *locationLat = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lat"] floatValue]];
    NSNumber *locationLng = [NSNumber numberWithFloat: [[place objectForKey:@"geometry"][@"location"][@"lng"] floatValue]];
    NSNumber *northEastLat =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lat"] floatValue]];
    NSNumber *northEastLng =[NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"northeast"][@"lng"] floatValue]];
    NSNumber *southWestLat = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lat"] floatValue]];
    NSNumber *southWestLng = [NSNumber numberWithFloat:[[place objectForKey:@"geometry"][@"viewport"][@"southwest"][@"lng"] floatValue]];
    return [NSArray arrayWithObjects:locationLat, locationLng,northEastLat, northEastLng, southWestLat, southWestLng, nil];
    
}


#pragma mark SPECIFIC VIEWING MODE CODE


-(void)setSpecificExplorerMode{
    
    [self.blackBackgroundView removeFromSuperview];
    [self EnterSpecificExploreMode];
    
}

-(void)EnterSpecificExploreMode{
    
    
    [self setUpSearchTextField];

    _autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.inputTextField
                                                         usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2 apiKey:@"INSERT_YOUR_PLACES_API_KEY_HERE"]
                                                         cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc] initWithCellForegroundColor:[UIColor lightGrayColor] fontSize:14]
                                                        presentingIn:self];
    _autocompleteView.geoDelegate = self;
    
    
    [MCUIUtil addShadowToView:self.inputTextField];
    [MCUIUtil addShadowToView:_autocompleteView];
    
    [self.mapView addSubview:self.inputTextField];

}

-(void)setUpSearchTextField{
    
    self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
    self.inputTextField.backgroundColor = [UIColor whiteColor];
    self.inputTextField.borderStyle = UITextBorderStyleNone;
    self.inputTextField.font = [UIFont systemFontOfSize:15];
    self.inputTextField.placeholder = @"enter a city name";
    self.inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.inputTextField.keyboardType = UIKeyboardTypeDefault;
    self.inputTextField.returnKeyType = UIReturnKeyDone;
    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.inputTextField.textAlignment = NSTextAlignmentCenter;
    
}

- (void)suggestionPressed{
    
    [self.buttonView removeFromSuperview];
    
    NSString *cityName = [self.inputTextField.text stringByReplacingOccurrencesOfString:@"          (A Country)" withString:@""];
    
    self.cityName = cityName;
    NSLog(@"%@", cityName);
    
    [self.inputTextField resignFirstResponder];
    
    if(_autocompleteView.suggestions.count != 0){
        [self getCityGeoInfo];
    }
    else{
        
        [MCUIUtil showAlertViewWithTitle:@"No Cities Found"
                                 message:Nil
                                delegare:Nil
                       cancelButtonTitle:@"OK"
                        otherButtonTitle:Nil];
    }
}



#pragma mark VIEWING FINISHED CODE

- (void)backButtonPressed{
    
    [self returnToMainScreen];
}


- (void)setUpButtonView{
    
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, self.mapView.frame.origin.y + self.mapView.frame.size.height + 300, 250, 80)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonView];
    [MCUIUtil addShadowToView:self.buttonView];
    self.buttonView.layer.opacity = 0.85;
    
    SEL back = @selector(backButtonPressed);
    SEL openWebView = @selector(openWebView);
    
    [self addButtonToButtonView:@"Learn More" sel:openWebView startX:20];
    [self addButtonToButtonView:@"Back" sel:back startX:140];
    
    [UIView animateWithDuration:1 animations:^{
        self.buttonView.center = CGPointMake(self.buttonView.center.x, self.buttonView.center.y - 400);
    }
                     completion:^(BOOL finished){
        
    }];
    
}

- (void)openWebView{
    
    [self performSegueWithIdentifier:@"SegueToWeb" sender:self];
    
}

- (void)addButtonToButtonView:(NSString *)name sel:(SEL)selector startX:(NSInteger)x{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 20, 120, 40)];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:button];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"SegueToWeb"]){
        
        SEL setCitySelector = sel_registerName("setCity:");
        if([segue.destinationViewController respondsToSelector:setCitySelector]){
            MCWebViewController *vc = (MCWebViewController *)segue.destinationViewController;
            vc.city = [self.formattedName urlEncode];
        }
    }
    
}


-(void) returnToMainScreen{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}



//dismiss keyboard when not needed
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.inputTextField isFirstResponder] && [touch view] != self.inputTextField) {
        [self.inputTextField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}


//dismiss keyboard when not needed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self suggestionPressed];
    [textField resignFirstResponder];
    return NO;
}


@end
