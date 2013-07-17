//
//  MCIconicPlaceViewController.h
//  MyCity
//
//  Created by Chen Zeyu on 13-7-17.
//
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>
@interface MCIconicPlaceViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *photoView;
@property (strong, nonatomic) IBOutlet UIButton *addOwnPhoto;

@end
