//
//  VictoryDemoViewController.h
//  Victory-iOS
//
//  Created by Kelp on 2013/06/12.
//  Copyright (c) 2013年 Kelp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VictoryDemoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
}

+ (NSString *)xibName;

@end
