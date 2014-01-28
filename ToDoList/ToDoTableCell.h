//
//  ToDoTableCell.h
//  ToDoList
//
//  Created by Ross Danielson on 1/27/14.
//  Copyright (c) 2014 zynga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoTableCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic,weak) IBOutlet UITextView *field;

- (void)setTextChangeCallback:(void(^)(id sender))callback;
@end
