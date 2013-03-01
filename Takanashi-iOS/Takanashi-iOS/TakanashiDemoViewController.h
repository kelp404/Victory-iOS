//
//  TakanashiDemoViewController.h
//  Takanashi-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import <UIKit/UIKit.h>

@interface TakanashiDemoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
}

+ (NSString *)xibName;

@end
