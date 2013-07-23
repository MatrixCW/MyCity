//
//  MCWebViewController.h
//  MyCity
//
//  Created by Chen Zeyu on 13-7-22.
//
//

#import <UIKit/UIKit.h>

@interface MCWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property NSString *city;
- (IBAction)dismissButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@end
