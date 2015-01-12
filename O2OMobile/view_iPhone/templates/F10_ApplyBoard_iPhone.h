//
//   ______    ______    ______
//  /\  __ \  /\  ___\  /\  ___\
//  \ \  __<  \ \  __\_ \ \  __\_
//   \ \_____\ \ \_____\ \ \_____\
//    \/_____/  \/_____/  \/_____/
//
//  Powered by BeeFramework
//
//
//  F1_MenuBoard_iPhone.h
//  ban
//
//  Created by purplepeng on 14-6-9.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "Bee.h"
#import "model.h"

#pragma mark -

@interface F10_ApplyBoard_iPhone : BeeUIBoard<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL			backWhenSucceed;
@property (nonatomic, retain) UserModel *	userModel;

AS_OUTLET( BeeUIScrollView, list )

@end
