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

#远程仓库
#已有本地仓库，将本地仓库与远程仓库关联
git remote add origin git@github.com:qiyu56/Rvalue-References-Explained.git
#默认远程仓库的名字叫origin

#将本地库中的内容推送到远程库
git push -u origin master 
#将本地库内容推送到远程库origin的master分支
#关联后第一次推送时加上-u参数，git还会将本地的master分支与远程的master分支关联

#分支管理(killer feature)
#分支意味着你可以脱离主线开发，而不会弄乱主线
#不使用分支，你在开发新功能时可能导致原有功能不能正常使用

#创建分支dev
git branch dev
#切换至dev分支(切换分支使用switch和checkout关键字都可以)
git switch/checkout dev
#以上两个操作合并为一条命令
git checkout -b dev

#查看当前分支
git branch

#在dev分支上做修改并提交
#再切换至主分支master
git switch/checkout master
#发现主分支上并未被修改

#将dev分支合并到当前分支master
git merge dev

#合并完成后即可删除dev分支
git branch -d dev

#Git鼓励你使用分支完成某个任务，合并后再删掉分支，
#这和直接在master分支上工作效果是一样的，但过程更安全。


#解决冲突
#有时无法自动合并需要手动合并
#例如在两个分支上对同一文件的同一行做了不同的修改，
#这时无法自动合并分支，需要手动合并，在你试图自动合并时，
#git status中会标明发生冲突的文件，git会在发生冲突的文件中标明各分支所做的修改，
#手动完成合并时再提交，删除分支
#使用以下命名可查看分之合并图：
git log --graph


#分支管理策略
#如果可以自动合并分支，git默认会使用Fast forward模式，
#但在这种模式下，删除分支后会丢掉分支信息
#如果禁用Fast forward，git就会在merge时生成一个新的commit，
git merge --no-ff -m "merge with no-ff" dev # -m "" 表示commit信息
#这样就可以在分支历史上看到分支信息

#通常master分支应该是非常稳定的，是用来发布新版本的
#在dev分支上干活，可为每个开发者在dev分支上创建自己的分支
#开发完成，个人分支合并到dev分支，dev分支再合并到master分支


#bug分支
#我们可以创建一个临时分支来修bug，完成后，合并分支，删除临时分支
#但是当你接到一个bug要修复时，你当前正在分支上开发的工作还没有完成(例如dev分支)
#此时工作还没有完成，并不能提交，但你又必须首先修复bug，咋整？
#git提供了一个stash功能，可以暂存当前现场，以后恢复现场继续工作
git stash
#此时用git status查看会发现工作区是干净的
#这样就可以去改bug了
#切换到master分支，在master分支上创建了bug01临时分支
#...好了，你把bug改完了，在bug01临时分支上提交完成了，
#切换到master分支，合并bug01分支至master分支，删除bug01分支。
#这时，你可以接着去dev分支开发未完成的新功能了
#切换到dev分支，使用以下命令可以看到之前暂存的现场:
git stash list
#恢复现场
    git stash apply #只恢复现场
    git stash pop   #恢复的同时把stash内容也删了
#可以暂存多份现场，并在恢复时指定恢复哪个：
git stash apply stash{0}

#试想你开始在dev分支上开发，然后去了master分支上创建bug01分支修bug
#修复完成后，合并bug01至master，再回到dev分支
#此时master分支上的bug修复了，但dev分支上还存在那个bug，对吧
#git提供了cherry-pick命令，用来复制一个特定的提交到当前分支
#我们可以复制修复bug的那个提交到dev分支
git cherry-pick 4c805e2
#git会自动给dev分支做一次提交(修复bug)



#查看远程库信息
git remote -v
#推送分支
git push origin master
git push origin dev
#master是主分支，要时刻与远程库同步
#dev是开发分支，团队成员都在上面工作，因此也需要与远程库同步

#抓取分支
#使用git clone，默认情况下在本地只能看到master分支(即使远程库有dev分支)
#想要在dev分支上开发，就必须创建远程origin的dev分支在本地，创建本地dev分支：
git checkout -b dev origin/dev
#这样就可以在dev分支上做修改并推送了

#当有人已经向origin/dev推送了提交，而你碰巧也对同样的文件做了修改并试图推送
#推送失败，因为你与他的提交存在冲突
#解决方法，先使用git pull将最新的提交从origin/dev上抓下来，然后在本地合并，解决合并冲突
#再次提交

#多人协作工作模式
#1. 首先，试图用git push origin <branch-name>推送自己的提交
#2. 如果推送失败，则远程库比本地库更新，需要使用git pull试图合并
#3. 如果合并有冲突，解决冲突，并提交
#4. 没有冲突或解决掉冲突后，再用git push origin <branch-name>推送！
# 如果git pull提示no tracking information, 则说明本地分支与远程分支没有建立链接关系，
# 创建：
git branch --set-upstream-to origin/<branch-name> <branch-name>


#标签管理
#发布一个版本时，我们通常先在版本库中打一个标签(tag)，
#这样，就唯一确定了打标签时刻的版本。将来无论什么时候，
#取某个标签的版本，就是把那个打标签的时刻的历史版本取出来。
#所以，标签也是版本库的一个快照。
#标签指向一次commit

# 创建标签
# 首先切换到你需要打标签的分支上
# 打标签:
git tag v1.0
# 默认标签打在最新提交的commit上
# 想对之前某次提交打标签，可指定commit-id
git tag v0.9 742c95f
# 查看所有标签
git tag
# 查看标签信息
git show v1.0
# 可以创建带有说明的标签 -a指定标签名 -m指定说明文字
git tag -a v1.0 -m "version 1.0 released" 742c95f

## 标签总是和commit关联的，如果该commit出现在两个分支上，
## 那么这两个分支都可以看到该标签

# 删除标签
git tag -d v1.0
# 推送某个标签到远程
git push origin v1.0
# 一次性推送所有未被推送到远程的标签
git push origin --tags
# 标签已经推送到了远程，删除标签
# 先删除本地标签
git tag -d v0.9
# 再从远程删除
git push origin :refs/tags/v0.9