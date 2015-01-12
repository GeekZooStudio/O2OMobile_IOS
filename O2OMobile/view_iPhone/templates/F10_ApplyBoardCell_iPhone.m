//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  F1_MenuBoardCell_iPhone.m
//  ban
//
//  Created by purplepeng on 14-6-9.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "F10_ApplyBoardCell_iPhone.h"

#pragma mark -

@implementation F10_ApplyBoardCell_iPhone

DEF_OUTLET( BeeUIImageView, avatar );
DEF_OUTLET( BeeUITextField, realname );
DEF_OUTLET( BeeUITextField, ident );
DEF_OUTLET( BeeUITextField, gender );
DEF_OUTLET( BeeUITextField, cardno );

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.realname.nextChain = self.ident;
	self.ident.nextChain = self.cardno;
	self.cardno.nextChain = nil;
}

- (void)unload
{
}

- (void)dataDidChanged
{
	NSDictionary * dict = (NSDictionary *)self.data;
	if ( dict )
	{
		NSInteger	selectedGender = [[dict numberAtPath:@"selectedGender"] integerValue];
		UIImage *	selectedImage = [dict objectForKey:@"selectedImage"];

		self.gender.text = (USER_GENDER_MAN == selectedGender) ? @"男" : @"女";
		
		if ( selectedImage )
		{
			self.avatar.image = selectedImage;
		}
		else
		{
			USER * user = [UserModel sharedInstance].user;
			
			if ( user.avatar.thumb.length )
			{
				[self.avatar GET:user.avatar.thumb useCache:YES placeHolder:[UIImage imageNamed:@"empty_avatar.png"]];
			}
			else if ( user.avatar.large.length )
			{
				[self.avatar GET:user.avatar.large useCache:YES placeHolder:[UIImage imageNamed:@"empty_avatar.png"]];
			}
			else
			{
				self.avatar.data = @"empty_avatar.png";
			}
		}
	}
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}

@end
