## 简介
该Service可以实现对UI文件（包括CSS和XML）修改的实时预览。

## 需求
1. 当对XML修改时，且修改文件是和当前界面相关时，重新加载**当前**界面
2. 当对CSS修改时，重新加载CSS，如果所修改的CSS文件和当前界面相关，则同时重新加载**当前**界面
3. 满足以上两条，并触发某个条件，默认是当文件被保存时。

## 需求关键字及扩展需求
1. 重新加载页面：
    1. 加载时机：框架级别支持，若开启service，则 load `hack files`
    2. 实现方式：swizze?
2. 和当前界面相关
    1. 建立一个文件相关的关系库
    2. 判断是否是当前界面

### Another Way
1. 属于一个scroll的cell，只监听一次，回调cell所属的scroll
2. watcher提供一种取消监听的机制
3. 当一个view释放时，取消监听

## TODO
1. CSS Parser优化
2. Webkit Layout