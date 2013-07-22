//
//  MCWebViewController.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-22.
//
//

#import "MCWebViewController.h"
#define SEARCH_URL @"https://www.google.com.sg/search?q=%@"
@interface MCWebViewController ()

@end

@implementation MCWebViewController

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
    NSString *fullURL = [NSString stringWithFormat:SEARCH_URL, self.city];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self addShadowToView: self.dismissButton];
	// Do any additional setup after loading the view.
}

- (void)addShadowToView:(UIView *)view{
    view.layer.masksToBounds = NO;
    view.layer.opacity = 0.8;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = 0.5f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
