//
//  MCMenuViewController.h
//  MyCity
//
//  Created by Chen Zeyu on 13-7-20.
//
//

#import <UIKit/UIKit.h>
#import "MCGeoLocationViewController.h"

@interface MCMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FormattedAreaNamesReadyToBeShownDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@end
