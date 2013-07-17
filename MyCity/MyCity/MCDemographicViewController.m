//
//  MCDemographicViewController.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-17.
//
//

#import "MCDemographicViewController.h"

#define CHENGDU_INFO @"DEMOGRAPHICS\n\nTotal:                    14047625\n\nMale:                    7138723\n\nFemale:                6908902\n\nM/F Ratio:               103.33"
@interface MCDemographicViewController ()

@end

@implementation MCDemographicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setUpTextView];
    [self setUpPieChartView];
	// Do any additional setup after loading the view.
}

- (void)setCityName:(NSString *)name {
    self.currentCityName = name;
}

- (NSDictionary *)getAgeDistribution {
    //return nil;
    NSMutableDictionary *age = [NSMutableDictionary dictionary];
    [age setValue:[NSNumber numberWithFloat:20] forKey:@"0"];
    [age setValue:[NSNumber numberWithFloat:40] forKey:@"1"];
    [age setValue:[NSNumber numberWithFloat:40] forKey:@"2"];
    return age;
}

- (void)setUpTextView {
    UITextView *textView = [[UITextView alloc] initWithFrame:self.contentView.bounds];
    textView.text = CHENGDU_INFO;
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:textView];
}

-(void)setUpPieChartView {
    XYPieChart *pieChart = [[XYPieChart alloc] initWithFrame:self.contentView.bounds];
    [pieChart setDelegate:self];
    [pieChart setDataSource:self];
    [pieChart setStartPieAngle:M_PI_2];	//optional
    [pieChart setAnimationSpeed:1.0];	//optional
    [pieChart setLabelFont:[UIFont systemFontOfSize:24]];	//optional
    [pieChart setLabelColor:[UIColor blackColor]];	//optional, defaults to white
    [pieChart setLabelShadowColor:[UIColor blackColor]];	//optional, defaults to none (nil)
    //[pieChart setLabelRadius:160];	//optional
    [pieChart setShowPercentage:YES];	//optional
    [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
    [pieChart setPieCenter:CGPointMake(160, 160)];	//optional
    [self.contentView addSubview:pieChart];
    [pieChart reloadData];
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,330,320,20)];
    ageLabel.text = @"0 - 14: 20%";
    ageLabel.tag = 2;
    ageLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ageLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    return [self getAgeDistribution].count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    //NSLog(@"hahahaha%f",[[self.ageDict objectForKey:[NSString stringWithFormat:@"%d",index]] floatValue]);
    return [[[self getAgeDistribution] objectForKey:[NSString stringWithFormat:@"%d",index]] floatValue];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index{
    
}
@end
