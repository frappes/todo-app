//
//  ToDoTableCell.m
//  ToDoList
//
//  Created by Ross Danielson on 1/27/14.
//  Copyright (c) 2014 zynga. All rights reserved.
//

#import "ToDoTableCell.h"

@interface ToDoTableCell ()



@end

@implementation ToDoTableCell

void (^textChangeCallback)(id sender);

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextChangeCallback:(void(^)(id sender))callback;
{
    textChangeCallback = callback;
}



@end
