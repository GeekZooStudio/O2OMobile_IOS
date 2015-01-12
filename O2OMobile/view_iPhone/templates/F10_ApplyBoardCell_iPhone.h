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
//  F1_MenuBoardCell_iPhone.h
//  ban
//
//  Created by purplepeng on 14-6-9.
//  Copyright (c) 2014年 geek-zoo. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface F10_ApplyBoardCell_iPhone : BeeUICell

AS_OUTLET( BeeUIImageView, avatar );
AS_OUTLET( BeeUITextField, realname );
AS_OUTLET( BeeUITextField, ident );
AS_OUTLET( BeeUITextField, gender );
AS_OUTLET( BeeUITextField, cardno );

@end
