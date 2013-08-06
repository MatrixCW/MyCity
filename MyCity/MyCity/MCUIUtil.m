//
//  MCUIUtil.m
//  MyCity
//
//  Created by Cui Wei on 6/8/13.
//
//

#import "MCUIUtil.h"

@implementation MCUIUtil

+(void)addShadowToView:(UIView *)ViewThatNeedsShadow{
    
    ViewThatNeedsShadow.layer.masksToBounds = NO;
    ViewThatNeedsShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    ViewThatNeedsShadow.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    ViewThatNeedsShadow.layer.shadowOpacity = 0.5f;
    
}

+(void)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)content
                     delegare:(id) delegate
            cancelButtonTitle:(NSString *)cancelButtonTitles
             otherButtonTitle:(NSString *) otherButtonTitle{
   
    
    UIAlertView *alert;
    
    if(otherButtonTitle){
    
        alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:content
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitles
                                              otherButtonTitles:otherButtonTitle, nil];
    }
    else{
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:content
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitles
                                              otherButtonTitles:nil];
        
    }
    
    [alert show];
}

@end
