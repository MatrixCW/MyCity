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
        
        SEL selector = NSSelectorFromString(@"setCityName:");
        
        if([segue.destinationViewController respondsToSelector:selector]){
           [segue.destinationViewController performSelector:selector
                                                 withObject:self.searchField.text
                                                 afterDelay:0];
        }
    }
}

- (NSString *)parseCityName: (NSString *)text{
    return [[text lowercaseString]
            stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"SegueToCity" sender:self];
    [textField resignFirstResponder];
    
    return YES;
}

@end
