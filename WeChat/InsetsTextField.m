//
//  InsetsTextField.m
//  WeChat
//
//  Created by Siegrain on 16/4/6.
//  Copyright © 2016年 siegrain. weChat. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
  return CGRectInset(bounds, self.textFieldInset.x, self.textFieldInset.y);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
  return CGRectInset(bounds, self.textFieldInset.x, self.textFieldInset.y);
}
@end
