//
//  MCRandomLocationViewController.m
//  MyCity
//
//  Created by Cui Wei on 22/7/13.
//
//

#import "MCRandomLocationViewController.h"
#import "AFJSONRequestOperation.h"
#import "MCWebViewController.h"
@interface MCRandomLocationViewController ()

@end

@implementation MCRandomLocationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName = @"Beijing";
    //[self setUpAndShowWebView];
	// Do any additional setup after loading the view.
    
        
    [self setUpButtonView];
    [self showRndomLocation:[NSArray arrayWithObjects:@"ChunXilu",@"SiChuan",@"Chengdu",@"China", nil]];
}


-(void)generateRandomCityName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cool" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:Nil];
    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    int randomCityIndex = arc4random();
    NSString *currentCity = [lines objectAtIndex:randomCityIndex];
    int start = [currentCity rangeOfString:@" "].location;
    int end = [currentCity rangeOfString:@","].location;
    NSRange range;
    range.location = start;
    range.length = end-start;
    self.cityName = [currentCity substringWithRange:range];
    
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
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, self.mapView.frame.origin.y + self.mapView.frame.size.height + 200, 300, 80)];
    self.buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonView];
    [self addShadowToView:self.buttonView];
    self.buttonView.layer.opacity = 0.85;
    SEL back = @selector(backButtonPressed:);
    SEL openWebView = @selector(openWebView:);
    [self addButtonToButtonView:@"Learn More" sel:openWebView startX:20];
    [self addButtonToButtonView:@"Back" sel:back startX:180];
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

-(void)exploreAnimation:(MKCoordinateRegion)region{
    
    [UIView animateWithDuration:3 animations:^{
        [self.mapView setRegion:region];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SegueToWeb"]){
        SEL setCitySelector = sel_registerName("setCity:");
        if([segue.destinationViewController respondsToSelector:setCitySelector]){
        [segue.destinationViewController performSelector:setCitySelector withObject:self.cityName afterDelay:0];
        }
    }
}

/*
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
*/

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
