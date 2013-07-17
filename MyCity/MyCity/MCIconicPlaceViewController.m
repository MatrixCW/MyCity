//
//  MCIconicPlaceViewController.m
//  MyCity
//
//  Created by Chen Zeyu on 13-7-17.
//
//

#import "MCIconicPlaceViewController.h"
@interface MCIconicPlaceViewController ()
@property BOOL newMedia;
@end

@implementation MCIconicPlaceViewController

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
    [self.addOwnPhoto addTarget:self action:@selector(pickPhotoButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
    PFImageView *image = [[PFImageView alloc] initWithImage:[UIImage imageNamed:@"city-at-night-shmlcbm.jpg"]];
    image.frame = self.photoView.frame;
    self.photoView = image;
    self.photoView.userInteractionEnabled = YES;
    [self.view addSubview: self.photoView];
	// Do any additional setup after loading the view.
}

- (void)pickPhotoButtonPressed:(UIButton *)sender {
    NSString *actionSheetTitle = @"Pick a Photo"; //Action Sheet Title
    NSString *cameraRoll = @"Pick from Camera Roll";
    NSString *takePhoto = @"Take a Photo";
    NSString *enterURL = @"Enter a URL";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:takePhoto, enterURL, cameraRoll, nil];
    [actionSheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickFromCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        self.newMedia = NO;
    }
}

-(void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        self.newMedia = YES;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No Camera!"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)enterImageURL {
    UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Enter Photo URL"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK",nil];
    
   [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
   [alert show];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Pick from Camera Roll"]) {
        [self pickFromCameraRoll];
    }
    if ([buttonTitle isEqualToString:@"Take a Photo"]) {
        [self takePhoto];
    }
    if ([buttonTitle isEqualToString:@"Enter a URL"]) {
        [self enterImageURL];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel pressed --> Cancel ActionSheet");
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        UITextField *username = [alertView textFieldAtIndex:0];
        NSLog(@"Username: %@", username.text);
    }
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.photoView.image = image;
        if (self.newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
