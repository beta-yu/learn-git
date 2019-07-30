#回退到上一版本
git reset --hard HEAD^
#回退到上上一版本
git reset --hard HEAD^^
#回退到向上100个版本
git reset --hard HEAD~100

#回退后又想回来
git reset --hard <commit_id> #<原先版本的版本号>
#可见git reset --hard <commit_id>可移动到指定的版本
#当你不知道版本号时：
git reflog #用来记录每一次命令，内含版本号
#HEAD总是指向当前版本

git add #添加文件至暂存区(stage)
git commit #把暂存区的所有内容提交到当前分支(如git为我们自动创建的master分支)

#撤销修改
git checkout -- file	#注意有 -- 
#1.	当修改文件后没有添加到暂存区(git add)，此时git checkout会将文件恢复到和版本库一致，
#	也就是你上一次提交(git commit)时的状态，也就是未修改的状态。
#2.	当修改被添加到暂存区(git add)后，又做了修改，此时git checkout会将文件内容恢复到
#	与暂存区中文件内容相同，之前git add时的状态。

#撤销掉暂存区的内容
git reset HEAD <file>
#此时也就是修改了还未添加到暂存区，就回到了上面1的状态。

#删除文件
#如果只是在本地删除了文件(rm)而版本库中未删除(git rm),此时想要恢复本地文件：
git checkout -- <file>
#git checkout其实是用版本库中的文件替换工作区的文件