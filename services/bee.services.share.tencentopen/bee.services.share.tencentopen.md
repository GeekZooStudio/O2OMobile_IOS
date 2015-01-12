#Step 1

1. Locate `bee.services.share.tencentweibo` under `/services`
2. Then drag and drop it into your project.
3. \#import "bee.services.share.tencentweibo.h"

#Step 2

Add below into your .plist file

	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLIconFile</key>
			<string>icon@2x</string>
			<key>CFBundleURLName</key>
			<string>tencentOpen</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>Your tencentOpen ID</string>
			</array>
		</dict>
	</array>

#Step 2

<pre>
bee.services.share.tencentOpen.config.appId = @"<Your app id>";
bee.services.share.tencentOpen.config.appKey = @"<Your app key>";
bee.services.share.tencentOpen.ON();
</pre>

#Step 4

<pre>
if ( bee.services.share.tencentOpen.installed )
{
	bee.services.share.tencentOpen.config.appId = @"<Your app id>";
	bee.services.share.tencentOpen.config.appKey = @"<Your app key>";
	bee.services.share.tencentOpen.ON();

	bee.services.share.tencentOpen.post.text = @"<Text>";
	bee.services.share.tencentOpen.SHARE_TO_FRIEND();
	
	... or ... 
	
	bee.services.share.tencentOpen.SHARE_TO_TIMELINE();
}
else
{
	bee.services.share.tencentOpen.OPEN_STORE();
}
</pre>

#Good luck
