//
//  MCUIUtil.h
//  MyCity
//
//  Created by Cui Wei on 6/8/13.
//
//

#import <Foundation/Foundation.h>

@interface MCUIUtil : NSObject

+(void)addShadowToView:(UIView *)ViewThatNeedsShadow;

+(void)showAlertViewWithTitle:(NSString *)title
                      message:(NSString *)content
                     delegare:(id) delegate
            cancelButtonTitle:(NSString *)cancelButtonTitles
             otherButtonTitle:(NSString *) otherButtonTitle;

@end
