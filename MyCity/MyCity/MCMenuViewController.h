//
//  MCMenuViewController.h
//  MyCity
//
//  Created by Chen Zeyu on 13-7-20.
//
//

#import <UIKit/UIKit.h>

@interface MCMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@end
