# ファイルを新規作成(あれば何もしない)
touch /C/jobnet_edit/grep_result_smfl.txt

# # sjisをutf8に変更する
# dest="/C/Users/tCIT116/opti-operation/jobnet/fl/NetMaster/"
# for i in $(ls *.csv)
# do
#     iconv -f CP932 -t UTF-8 ${i} > ${DEST}/${i}
# done

# SMLFジョブネット定義場所へ移動
cd /C/Users/tCIT116/00_work/100_GitLab/opti-operation/jobnet/fl/NetMaster/

# プログラム名で対象のジョブネット定義ファイルを検索する
# xargs -I argの意味はパイプの前処理から受け取った値がargとして扱われる
grep -r b1m00hs0 ./*|xargs -I arg echo b1m00hs0 : arg >  /C/jobnet_edit/grep_result_smfl.txt
grep -r b1d00hs0 ./*|xargs -I arg echo b1d00hs0 : arg >> /C/jobnet_edit/grep_result_smfl.txt
