//
//  MCRandomLocationViewController.m
//  MyCity
//
//  Created by Cui Wei on 22/7/13.
//
//

#import "MCRandomLocationViewController.h"
#import "AFJSONRequestOperation.h"
@interface MCRandomLocationViewController ()

@end

@implementation MCRandomLocationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName = @"Beijing";
    //[self setUpAndShowWebView];
	// Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cool" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:Nil];
    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    for(int i = 0; i<34; i++){
        int randomCityIndex = i;
        NSString *currentCity = [lines objectAtIndex:randomCityIndex];
        int start = [currentCity rangeOfString:@" "].location;
        int end = [currentCity rangeOfString:@","].location;
        NSRange range;
        range.location = start;
        range.length = end-start;
        NSLog(@"%@",[currentCity substringWithRange:range]);
        
        /*
         NSArray *parseCityName = [currentCity componentsSeparatedByString:@" "];
         NSLog(@"%d",randomCityIndex);
         NSString *tempCithName = [parseCityName objectAtIndex:1];
         NSString *finalCityName = [tempCithName substringToIndex:tempCithName.length-1];
         NSLog(@"%@",tempCithName);
         NSLog(@"%@", finalCityName);
         */
    }

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
    if([segue.identifier isEqualToString:@"SegueToWebView"]){
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