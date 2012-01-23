//
//  QuestSelectionVC.h
//  ImBored
//
//  Created by Amy Dyer on 1/22/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestSelectionVC : UIViewController {
    UITableView * table;
    NSArray * questTypes;
}

@property (nonatomic, retain) UITableView * table;

@end
