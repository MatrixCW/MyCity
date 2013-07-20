//
//  InitSlidingViewController.m
//  MyCity
//
//  Created by Cui Wei on 18/7/13.
//
//

#import "InitSlidingViewController.h"

@interface InitSlidingViewController ()

@end

@implementation InitSlidingViewController

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
	// Do any additional setup after loading the view.
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainGeoLocationVC"];
    self.mainViewController = self.topViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
