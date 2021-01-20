# Git Memo
## Git Log
#### Gitで特定ファイルの変更履歴を見る

    git log -p Directory1/FileName1

#### 現在のコミットから過去2回分の特定ファイル(フォルダ)の変更文字単位を見る
    e.g. 表示の仕方は 1:HEAD..HEAD~1 2:HEAD~1..HEAD~2
    git log --word-diff HEAD -n 2 -p batch/BCTK005/template_html/

#### 特定ファイルの過去3回分のログを見たい

    git logg -n 3 -p AA/BB.txt

#### 昨日からの変更したログ一覧を見たい

    git logg --since='yesterday'

#### 日付を指定

    git logg --since='7 days'

#### 月を指定

    git logg --since='1 month'
    git logg --since=1.months
    git log --after '2018-05-27 00:15:00'

#### 相対的な日時での指定

    git log --after 'yesterday'
    git log --after 'last Monday' ←先週の月曜日

    月曜日:Monday 火曜日:Tuesday 水曜日:Wednesday 木曜日:Thursday 金曜日:Friday 土曜日:Saturday 日曜日:Sunday
    git log --after '1 month 3 days ago'

#### 特定ブランチのログを見たい

    git logg develop

#### SVN関連のブランチを見たくない場合

    git logg --banches master develop

#### マージコミットの詳細を見たくない場合

    1.git logg --merges

#### 特定タグ以降のログを見たい

    git logg start_tagName..

#### 特定の文字列が含まれたコミットを見たい
    例：文字列"oasys_ast"が含まれるコミットを差分形式(patch)で
    タグ"sprint14_start"から"sprint14_end"間でみたい

    git log -S 'oasys_ast' --patch  sprint14_start..sprint14_end

## Git Diff
#### 前回のコミットから変更をファイル単位で見る

    git diff  --name-only HEAD~3..HEAD  （ファイル単位で出力）
    git diff  --stat HEAD~3..HEAD  （ファイル単位尚且修正行数が表示される）

#### 前回のコミットから変更を特定のファイルのみ確認する

    git diff  4a9f44e..c92939d BCTK001/HealthCheck/HealthCheck.vbproj

#### コミット間の変更を特定のフォルダだけ見る
    git diff  --name-only HEAD~3..HEAD  --relative=BCTK001

#### ブランチを比較

    git diff master..develop
    git diff --word-diff master..develop <Directory>/<FileName>

#### コミット履歴でどれくらいのファイルが変更したかを見たい
    git diff HEAD~3..HEAD --name-only

#### リモートレポジトリとローカルリポジトリの差分を確認する
    git diff HEAD..FETCH_HEAD

#### 取り込み先の差分をビジュアルモードにして、取り込み元の内容を取り込む
    :diffget

#### Visual-mode で範囲を選択した後に、その範囲を反対側のバッファへ適用する
    :diffput

#### diff modeの差分情報を最新にする

    :diffupdate

## Git blame
#### 特定の行がいつだれに変更されたかを知る

    git blame test.vb
    125行目から130行目を表示する
    git blame -L 125, 130 test.vb

## Git show
#### 一つのコミットの変更状況を調べる

    git show 6654e0c3
    更に詳しく見るためには
    git log -S 'changed_content' --patch test.vb

## Git Archive
#### 前回のコミットから変更があるファイルのみ抽出して、ZIPファイルを作成
    diff-filter=ad は抽出対象から新規追加と削除されたファイルを外すとの意味
    なのでnewの場合はdiff-filter=d(削除されたのを外す)で、oldの場合はdiff-filter=a(新規追加のを外す)で良さそう

    git archive --format=zip   HEAD←出力するrevision `git diff --diff-filter=ad --name-only HEAD~1..HEAD` -o archive_20190729_new.zip

#### マージしたコミット履歴の場合HEADとHEAD~1の場所
    commit_A ←HEAD
    | \
    |  commit_m1
    |  commit_m2
    | / 
    commit_B ←HEAD~1

## Git Commit
#### 前回のコミットにもう一度コミットする

    git commit --amend --no-edit

#### 前回のコミットのメッセージを修正する

    git commit --amend -m "修正後のメッセージ"

## Git Reset
#### git addしたものを取り消す(ステージングしたものをなしにする)

    git reset .
    git reset HEAD

#### git addしたコミット履歴、作業フォルダを取り消す

    git reset --hard HEAD~1


## Git Checkout
#### ブランチを作成同時に、そのブランチに切り替える

    git checkout -b develop

#### ローカルに加えたすべての変更を取り消す

    git checkout .

## Git Merge
#### ブランチを試してマージしてみる

    git merge --no-commit --no-ff develop  ←取り込みたいブランチを指定
    実行結果をみて、confilictがなければOK

    現在マージ状態なので、とりあえず取り消し
    git merge --abort

#### ブランチをマージする(いつもマージがある部分がわかるようにする)

    git merge --no-ff develop  ←取り込みたいブランチを指定

#### confilictが発生した場合
    必ず GitBashコマンドプロンプトから
    git mergetool aa.txt でマージを開始する
    gvimが起動され、以下のようなdiffモードが表示される

     --------------------------------------
    |           |            |            |
    |   LOCAL   |    BASE    |   REMOTE   |
    |    (1)    |     (2)    |     (3)    |
    |           |            |            |
    |-------------------------------------|
    |                                     |
    |                MERGED               |
    |                  (4)                |
    |                                     |
     ------------------------------------- 

     説明：
     LOCAL: 現在のWorkingTree上のファイル
     BASE:  マージ前の共通先祖
     REMOTE: マージしたいブランチ上のファイル
     MERGED: 最終的にマージされた後のファイル

     ●マージ編集方法

     (1)MERGEDウィンドウにカーソルがある場合Normalモードで
         1do: LOCALの修正 2do: BASEの修正 3do: REMOTEの修正
         それぞれをMERGEDに取り込む

     (2)LOCAL,BASE,REMOTEそれぞれのウィンドウにカーソルがある場合Normalモードで
         4dp: LOCAL,BASE,REMOTEのウィンドウでノーマルモードで入力すると
              そのウィンドウの内容がMERGEDに反映される

         REMOTEバッファの内容を全部MERGEDに反映したい場合は↓
         :1,$diffput 4

         MERGEDバッファにカーソルあり、REMOTEの内容を全部取り込みたい場合は↓
         :1,$diffget 3

     (3)vimでwqaを打ってマージを終了する

     ●git bashコマンドプロンプトにて
     2.git add file.txt
     3.git status
     4.git clear -n(削除対象ファイルを確認)   git clear -f(実際に削除)
     5.git commit -m "input commit message"

#### マジする際に使われるコミットメッセージを指定する

    git merge other-branch -m "Commit Message"

#### マジ完了したけど、マージ自体をキャンセルする場合（コミット履歴が残らない方式）

    git reset --hard ORIG_HEAD



## Git Tag
#### タグをつける

    git tag -a original -m "修正前のソース"  f26ea96  ←コミット値
#### タグ一覧を表示する

    git tag  --sort=-taggerdate --format='%(taggerdate:short) [%(tag)]   %(subject)'
#### タグを削除

    git tag -d TAG_NAME
#### タグ名を変更する

    既存タグを削除して、つけ直す！


## Git Rebase&Reset
#### 過去のコミットのコメントを修正する(注意：必ずGitbashから実行すること)
    参考URL:https://backlog.com/ja/git-tutorial/stepup/33/

    1. git rebase -i HEAD~2 　←　修正したいコミットまでのoffset + 1
    2. 別ウィンドウでGvimが開かれるが、その時コミットしたいSHAのpickをeditに変更
       して終了。
    3. gitBashターミナルに戻る。
    6. git commit --amend -m "新しいコメントを入力"
    7. git rebase --continue でRebase作業を終了する。


    途中でやめたい場合は、git rebase --abort

#### rebaseで枝分けを直す

masterからdevelopブランチを切った後に、masterから他のcommitがある際
masterブランとdevelopブランチが枝分かれした時点から変更された
すべてのcommitをdevelopに取り込む際にrebaseを使うべき
図で例を示します。 

現ブランチがtopicでmasterブランチGまで完成したソースの後に
topicブランチのA~Cまでの変更を適用したい

 ___git rebase  master___

    (Before)
              A---B---F---C topic
             /
        D---E---F---G master
    
    (After)
                      A'--B'--C' topic
                     /
        D---E---F---G master


    コンフリクトが発生した場合
    1. mergetoolでコンフリクト解決
    2. git add .
    3. git rebase --continue

#### rebaseでブランチに散らかして存在する特定のtopicのみのコミットだけ抽出する(直列化)

下記のようなマージしたブランチで**Topic A**だけの履歴を残したい

    (Before)
                                  (A_v11)
                  [A1]---[C1]-----[A2]    
                   /                  \
      Common Commit---[B1]----[B2]----- MergeCommit--[A3]
      (A_v00)         (A_v21) (A_v22)
    
    (After)

      Common Commit---[A1]---[A2]---[A3]

(やり方)
  **git rebase -i Common Commit**
  ---

  - gvimでcommit履歴が以下のように表示される

          pic Common Commit
          pic A1
          pic B1
          pic C1
          pic B2
          pic A2
          pic A3

  - gvimでcommit履歴を以下のように変更する

          pic  Common Commit
          pic  A1
          pic  B1 
          drop C1 <-- ここ
          pic  B2 
          pic  A2
          pic  A3
         (drop C1の意味はこのコミットでの既存ファイルの変更、
         ファイルの新規追加、削除の変更がなくなる)
  - gvimで:wqで終了

  - gitが自動的に直列化をやってくれる
        git loggで確認して完了

  - rebaseの際に、File Aにconfilictが発生した場合 

        Rebaseの時系列からみればA_v21->A_v22->A_v11なので
        LOCALはA_v21とA_v22のコミットが反映される
        REMOTEはA_v11が反映される
        (Local->Commonから近いコミット)
        (REMOTE->Commonから遠いコミット)

         --------------------------------------
        |           |            |            |
        |   LOCAL   |    BASE    |   REMOTE   |
        |   (1)     |    (2)     |   (3)      |
        |-----------|------------|------------|
        | Common v0 | Common v0  | Common v0  |
        | A_v21 *   |            | A_v11  *   |
        | A_v22     |            |            |
        |           |            |            |
        |-------------------------------------|
        |                MERGED               |
        |                  (4)                |
        |  Common v0                          |
        |  [confilict Point]                  |
        |  <<<<<<HEAD                         |
        |  A_v21                              |
        |  A_v22                              |
        |  ======                             |
        |  A_v11                              |
        |  >>>>>REMOE                         |
         ------------------------------------- 

#### rebaseを過去に戻したい

    git reflog ←　コミット履歴確認用
    git reset --hard HEAD@{4} 　←一般的にはこれを使う
    git reset --hard ORIG_HEAD ←rebase直後に使える


    
#### Commitの履歴をきれいにする

    git rebase -i HEAD~3
    
    (Before)
     * 110_Commit
     * 111_Merged_Commit
     |\
     | * 222_Commit
     | * 223_Commit
     | * 224_Commit
     | /
     * 112_Commit
     * 113_Commit
    
    (After)
     * 110_Commit
     * 222_Commit
     * 223_Commit
     * 224_Commit
     * 112_Commit
     * 113_Commit

#### Commitの無駄な履歴を削除して、必要な履歴を一個作成する

    (1)git commit tmp_Aでfile11,file12をコミットする
    (2)git commit tmp_Bでfile21をコミットする
    (3)git commit tmp_Cでfile31,file32,file33をコミットする
    
    git logg -n 4
    結果:
     * tmp_C_Commit
     * tmp_B_Commit
     * tmp_A_Commit
     * Original_Commit

    (変更されたファイル一覧)
    file11 file21 file31 file32 file33

    (この時、ファイル変更はそのままで、tmpコミットのみ削除したい)
     git reset --mixed HEAD~3 (indexとcommitが削除される)
     git add . (file11 file21 file31 file32 file33がindexへ追加される)
     git commit (file11 file21 file31 file32 file33がcommitへ追加される)

    結果:
     * New_Commit
     * Original_Commit

#### masterにdevelopにないコミットが存在する場合、developをマージする

    最初のイメージ(master)
    やりたいこと：commit50を                (develop) 
    マージコミットに変更した後、developをマージしたい

                                            *   merge_commit53
                                            |\
                                            | * commit52
                                            | * commit51
    *commit50 <<問題あり                     |/
    *merge_commit49                         *merge_commit49
    |\                                      |\
    | * commit48                            | * commit48
    | * commit47                            | * commit47
    | /                                     | /
    *merge_commit46                         *merge_commit46

    変更後のイメージ(master)

    *merge_commit53
    |\
    | * commit52
    | * commit51
    |/
    *merge_commit50
    |\
    |* commit50
    |/
    *merge_commit49
    |\
    |*commit48
    |*commit47
    |/
    *merge_commit46

    [使用されるコマンド]

    git checkout -b [Branch_name]
    git rebase [Branch_name]
    git merge --no-ff [Branch_name]
    git reset --hard HEAD~XX

    [手順]
    ・masterからtmp_master作成

    ・developからブランチからmasterブランチをrebase
      (develop)git rebase master
      これでdevelopでmerge_commit46,merge_commit50,merge_commit51,merge_commit52
      の順コミットが生成される

    ・masterからHEAD~1を削除->merge --no-ff tmp_masterで
      commit50のマージコミットを作成する

    ・developで以下のコマンドでmasterのcommit50のマージコミットを取り込む
      (develop)git rebase master

    ・masterで以下のコマンドを実行すれば変更後のコミットのようなものが得られる
      (master)git merge --no-ff develop


## Git Remote
#### リモートレポジトリの一覧を取得する
    git remote -v

#### push an existing repository from the command line
    git remote add origin https://github.com/eng80search/Vim82_Home.git
    git push -u origin master

#### リモートレポジトリの最新を取得する
    git fetch
    evertokyo

#### ローカルリポジトリの変更をリモートのoriginリポジトリにあるローカルと
#### 同じ名前のブランチに反映する
    git push origin HEAD

#### ローカルリポジトリのすべてのブランチをリモートのoriginリポジトリへ反映する
    git push --all origin
    git push --tags

#### ローカルリポジトリの変更をリモートのoriginリポジトリとmasterタグに反映する。
    git push origin master
    git push -f origin master ←強制的にリモートブランチを上書きする

#### リモートブランチをローカルにコピーする
    ローカルブランチが空の場合
    git checkout -b feature_A origin/feature_A

#### ローカルブランチの履歴は残す必要がなく、完全にリモートブランチに一致させたい場合
    ローカルブランチが既に存在する場合
    git reset --hard origin/master

#### remote、ローカル両方のブランチを削除
    git push --delete origin develop

#### originリモートブランチが削除された場合、ローカルの対応するremoteブランチも削除
    git remote prune origin 

#### 他の場所で既に削除済のブランチをローカルでも削除する際
    git fetch --prune Or git fetch -p

#### originリモートリポジトリを削除する(githubにリモート自体は残る)
    git remote rm origin

#### こんなエラーがあった場合
    error: failed to push some refs to 'https://github.com/...'の場合

    解決策1:
    git fetch
    git rebase origin/master

    解決策2:
    git fetch
    git merge origin/master


## Git Branch
#### 現在開いているブランチの名前を変更
    git branch -m newBranchName

#### ブランチを新規作成
    git branch  newBranch

#### ブランチを削除
    git branch --delete hotfix
    Or
    git branch -d hotfix

#### ブランチを作成同時に、そのブランチに切り替える
    git checkout -b develop

#### 消してしまったブランチを復活させるには？
    git reflog
#### 消してしまったブランチの最後のコミットを見つけたら
    git branch ブランチ名 HEAD@{ログ番号}


## ブランチのおすすめモデル
    【開発作業の流れ】
    1. masterブランチからdevelopブランチを作成
    2. developブランチから実装する機能毎にfeatureブランチを作成
    3. featureブランチで実装完了した機能はdevelopブランチにマージ
    4. リリース作業開始時点で、developからreleaseブランチを作成
    5. リリース作業完了時点で、releaseからdevelop, masterブランチにマージ

### 【リリース後の障害対応の流れ】
    1. masterブランチからhotfixブランチを作成
    2. hotfixブランチで障害対応が完了した時点で、develop, masterブランチにマージ

#### **hotfixブランチ
    製品のリリース時には、時として重大な不具合が見つかる場合があります。みなさんも経験があるのではないでしょうか？

    そんなときには、master ブランチから直接 hotfix
    ブランチを切って緊急の修正を行いましょう。修正完了後に master ブランチと develop
    ブランチにマージして、リリースタグ（マイナーバージョンなど）をうちます。その後、hotfix
    ブランチは削除します。派生元が master になるだけで、操作的には release
    ブランチと同様です。

#### masterブランチの途中からhotfixを切る

    git logg  <- コミット一覧を見る
    git checkout -b hotfix 7f7798e  <-  新しいブランチhotfixを特定のコミットから切る
    【登場するブランチ】
    master:
    　リリースした時点のソースコードを管理するブランチ

    develop (masterから派生):
    　開発作業の主軸となるブランチ

    feature (developから派生):
    　実装する機能毎のブランチ (feature/◯◯, feature/xxなど)

    release (developから派生):
    　developでの開発作業完了後、リリース時の微調整を行うブランチ
    　(バージョン番号の変更などで使いました。)

    hotfix (masterから派生):
    　リリースされた製品に致命的なバグ(クラッシュなど)があった場合に緊急対応をするためのブランチ


## Git stash
#### 作業を一時退避

    現在の作業を一時的に退避したい
    git stash save "add stash message"
    もしくは
    git stash

#### 最新のstashを適用する

    git stash apply stash@{0} --index saveした時点でaddした状態も戻したい場合は--indexオプションをつける
    もしくは
    git stash pop

#### 一時保存の復活と、削除を同時に行う場合

    git stash pop stash@{0}

#### 退避した作業の一覧を表示したい

    git stash list

#### 退避した作業を削除したい(退避した作業の中で最新の作業を削除)

    git stash drop stash@{0}

#### 退避した作業を全て削除したい
    git stash clear


## Git Svn
#### SVNとの連携
    Clone a repo (like git clone):
	git svn clone http://svn.example.com/project/trunk

    You should be on master branch, double-check with 'git branch'(ブランチremotes/git-svnが存在することを確認)
	git branch

    Do some work and commit locally to Git:
	git commit ...

    Something is committed to SVN, rebase your local changes against the
    latest changes in SVN:(SVNでコミットしたものをGitに取り込む)
	git svn rebase

    Now commit your changes (that were committed previously using Git) to SVN,

    注意：masterブランチをgit-svnブランチにコミットする際に、masterブランチに
    マージコミット(-no-ff)がある場合はコミットが失敗するときがある。
    その時はgit checkout -b svn_masterにしてもう一回dcommitする。
    そうすると一回目失敗、二回目が成功になる。(2回目はマージコミットがなくなってしまう)

    as well as automatically updating your working HEAD:
	git svn dcommit

    Append svn:ignore settings to the default Git exclude file:
	git svn show-ignore >> .git/info/exclude


## Git ignore
#### Gitのignore

    .gitignore を設置しても、既にリポジトリに登録されているファイルは無視されないので、
    無視したいファイルを管理対象から外します。
    （なお、管理対象から外れるだけで、ローカルにあるファイルは削除されません）
    git rm -r --cached hoge.tmp
    か全部のキャッシュを削除する際には↓↓
    git rm -r --cached .

#### 既に大量のファイルが登録されている場合

    git rm -r --cached `git ls-files --full-name -i --exclude-from=.gitignore`

#### ファルダ名に半角スペースがある場合

    git rm -r --cached "test space/sub"

#### おまけ
    git add .
    git commit -m ".gitignore is now working"
    git push origin master


