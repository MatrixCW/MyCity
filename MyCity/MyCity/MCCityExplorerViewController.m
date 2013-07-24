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

@interface MCCityExplorerViewController ()

@end

@implementation MCCityExplorerViewController{
    
    TRAutocompleteView *_autocompleteView;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //self.currentExploringType = RandomExploreMode;
    [self queryExploringMode];
    //if(self.currentExploringType == RandomExploreMode){
        //[self EnterRandomExploreMode];
    //}
    
}


-(void)queryExploringMode{
    
    self.blackBackgroundView = [[UIView alloc] initWithFrame:self.mapView.bounds];
    self.blackBackgroundView .backgroundColor = [UIColor blackColor];
    self.blackBackgroundView .alpha = 0.7;
    
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
    
    [self.mapView addSubview:self.blackBackgroundView ];
    
}

-(void)setRandomExplorerMode{
    
    [self.blackBackgroundView removeFromSuperview];
    [self EnterRandomExploreMode];
    
}


-(void)setSpecificExplorerMode{
    
    [self.blackBackgroundView removeFromSuperview];
    [self EnterSpecificExploreMode];
    
}
-(void)EnterRandomExploreMode{
    
    [self generateRandomCityName];
    [self getCityGeoInfo];
    
}

-(void)EnterSpecificExploreMode{
    

    /*
    self.inputTextHolderView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
    self.inputTextHolderView.backgroundColor = [UIColor whiteColor];
    [self addShadowToView:self.inputTextHolderView];
     */
    
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
    
         
    
    _autocompleteView = [TRAutocompleteView autocompleteViewBindedTo:self.inputTextField
                                                         usingSource:[[TRGoogleMapsAutocompleteItemsSource alloc] initWithMinimumCharactersToTrigger:2 apiKey:@"INSERT_YOUR_PLACES_API_KEY_HERE"]
                                                         cellFactory:[[TRGoogleMapsAutocompletionCellFactory alloc] initWithCellForegroundColor:[UIColor lightGrayColor] fontSize:14]
                                                        presentingIn:self];
    _autocompleteView.geoDelegate = self;
    
    [self addShadowToView:self.inputTextField];
    [self addShadowToView:_autocompleteView];
    [self.mapView addSubview:self.inputTextField];

    
}


- (void)suggestionPressed{
    
    //self.homeButton.hidden = YES;
    [self.buttonView removeFromSuperview];
    NSString *cityName = [[[[self.InputTextField.text stringByReplacingOccurrencesOfString:@"          (A Country)" withString:@""]
                            stringByReplacingOccurrencesOfString:@"," withString:@" "]
                           stringByReplacingOccurrencesOfString:@"  " withString:@" "]
                          stringByReplacingOccurrencesOfString:@" " withString:@",+"];
    self.formattedCityName = cityName;
    NSLog(@"%@", cityName);
    [self.InputTextField resignFirstResponder];
    
    if(_autocompleteView.suggestions.count != 0){
        [self getCityGeoInfo];
        [self setUpButtonView];
    }
    
    else [self showAlertViewWithTitle:@"No Cities Found" message:nil];
}


-(void)generateRandomCityName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cool" ofType:@"txt"];
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
    //self.cityName = @"New York";
    self.cityName = [self.cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"generated names:%@", self.cityName);
    
}
- (void)backButtonPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addShadowToView:(UIView *)view{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = 0.5f;
}

- (void)setUpButtonView{
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, self.mapView.frame.origin.y + self.mapView.frame.size.height + 300, 250, 80)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonView];
    [self addShadowToView:self.buttonView];
    self.buttonView.layer.opacity = 0.85;
    SEL back = @selector(backButtonPressed:);
    SEL openWebView = @selector(openWebView:);
    [self addButtonToButtonView:@"Learn More" sel:openWebView startX:20];
    [self addButtonToButtonView:@"Back" sel:back startX:140];
    [UIView animateWithDuration:1 animations:^{
        self.buttonView.center = CGPointMake(self.buttonView.center.x, self.buttonView.center.y - 400);
    }completion:^(BOOL finished){
        
    }];
}

- (void)openWebView:(id)sender{
    [self performSegueWithIdentifier:@"SegueToWeb" sender:self];
}

- (void)addButtonToButtonView:(NSString *)name sel:(SEL)selector startX:(NSInteger)x{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 20, 120, 40)];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:button];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SegueToWeb"]){
        SEL setCitySelector = sel_registerName("setCity:");
        if([segue.destinationViewController respondsToSelector:setCitySelector]){
            MCWebViewController *vc = (MCWebViewController *)segue.destinationViewController;
            vc.city = self.cityName;
        }
    }
}

- (void)getCityGeoInfo{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [self.cityName urlEncode]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *result = [JSON objectForKey:@"results"];
        NSDictionary *place = [result objectAtIndex:0];
        self.formattedName = (NSString *)place[@"formatted_address"];
        self.names = [self.formattedName componentsSeparatedByString:@", "];
        self.currentIndex = self.names.count - 1;
        [self showRndomLocation:self.names];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
        NSLog(@"fail to get city info: %@",error.description);
    }];
    
    [operation start];
}

- (void)moveToCity{
    
    
    if(self.currentIndex < 0){
        [self performSelector:@selector(setUpButtonView) withObject:nil afterDelay:3];
        return;
    }
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", [[self.names objectAtIndex:self.currentIndex]urlEncode]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *result = [JSON objectForKey:@"results"];
        NSDictionary *place = [result objectAtIndex:0];
        
        NSArray *location = [self parseGeoInfo:place];
        
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[location objectAtIndex:0] floatValue], [[location objectAtIndex:1] floatValue]), MKCoordinateSpanMake(fabs([[location objectAtIndex:2] floatValue] - [[location objectAtIndex:4] floatValue]), fabs([[location objectAtIndex:3] floatValue] - [[location objectAtIndex:5] floatValue]))) animated:YES];
        
        if(self.currentIndex < self.names.count){
            [self performSelector:@selector(moveToCity) withObject:nil afterDelay:3];
            self.currentIndex -- ;
        }
                
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
        NSLog(@"fail to get city info: %@",error.description);
    }];
    
    [operation start];
}

-(void)showRndomLocation:(NSArray*)details{
    
    int levelsOfLocation = details.count;
    NSMutableString *infoString = [NSMutableString stringWithCapacity:15];
    [infoString appendString:@"Taking you to "];
    
    for(int i = 0; i < levelsOfLocation; i++){
        [infoString appendString:@"\n\n"];
        [infoString appendString:[details objectAtIndex:i]];
        
    }
    
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.mapView.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.7;
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(36, 145, 248, 200)];
    prompt.numberOfLines = 0;
    
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.textColor = [UIColor whiteColor];
    prompt.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(13.0)];
    [coverView addSubview:prompt];
    prompt.text = infoString;

    [self.mapView addSubview:coverView];
    
    [self performSelector:@selector(fadeAwayView:) withObject:coverView afterDelay:4];
}


-(void)fadeAwayView:(UIView*)view{
    
    [UIView animateWithDuration:2
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:^(BOOL finish){
                         [view removeFromSuperview];
                         [self moveToCity];

                                            }
     ];
    
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
@end
