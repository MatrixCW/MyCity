//
//  MCEnterCityViewController.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-16.
//
//

#import "MCEnterCityViewController.h"
@interface MCEnterCityViewController ()

@end

@implementation MCEnterCityViewController

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
    self.searchField.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SegueToCity"]) {
        [segue.destinationViewController performSelector:@selector(setCityName:) withObject:self.searchField.text];
    }
}

#pragma UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
