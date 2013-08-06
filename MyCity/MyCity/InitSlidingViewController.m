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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainGeoLocationVC"];
    self.mainViewController = self.topViewController;
}


@end
