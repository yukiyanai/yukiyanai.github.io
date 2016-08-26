/* =======================================================================
ch04-05.do

Stata do-file for Ch.4 & Ch.5 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/10/2013 by MA and YY
Modified: Sep/18/2014 YY
==========================================================================*/

** 結果の表示において「 - more - 」をクリックせずにスクロールする
set more off


** 作業フォルダを変更する（パスはコンピュータんの設定によって異なる）
cd ~/stata/


** log_ch05.logという名称のログファイルを開く
log using log_ch05.log, replace


** hr96-09.csvという名称のcsvデータセットを開く
insheet using hr96-09.csv, clear


** データセット中の変数に関する記述統計を表示する
summarize


** 変数wlとstatusについて、それぞれ表で示す
tabulate wl
tab status
	
	
** hr96-09manage.doという名称のdoファイルを実行する
** （h696-09manage.doは現在の作業ディレクトリにあるものとする）
do hr96-09manage.do
run hr96-09manage.do


** 変数(wl, status, party)に貼ったラベルをチェックする（表5.7、表5.9、表5.10）
tab wl
tab status
tab party


**　2009年衆議院選挙（政党別立候補者数）の度数分布表を示す（表5.11）
tab party if year==2009


**2009年衆議院選挙小選挙区の当選者（政党別）の度数分布表を示す（表5.12）
tab party if year==2009 & wl==1


**　2009年衆議院選挙小選挙区の当選者（みんなの党）のプロフィールを示す（表5.13）
list ku kun name age nocand rank vote ///
    if year==2009 & party==1111 & wl==1, noobs


** 江田けんじの衆議院選挙結果（2000-2009）を示す（表5.14）
list year party age nocand rank status wl previous vote ///
    if name=="EDA, KENJI", noobs


** hr96-09.dtaという名称のデータセットを保存する
save hr96-09.dta, replace


** 2009年衆議院選挙における社民党候補者の年齢の幹葉図を作成する（図5.2）
stem age if party==1002 & year==2009, lines(1)


** 2009年衆議院選挙における社民党候補者の年齢の幹葉図を作成する（図5.3）
stem age if party==1002 & year==2009


** 2009年衆院選社民党候補者に関する年齢のヒストグラム（度数）（図5.4）
histogram age if party==1002 & year==2009, ///
    width(10) start(30) frequency


** 2009年衆院選社民党候補者に関する年齢のヒストグラム（確率密度）（図5.5）
histogram age if party==1002 & year==2009, ///
    width(10) start(30)


** 2009年衆院選社民党候補者に関する年齢のヒストグラム（頻度、階級の幅は7）（図5.7）
histogram age if party==1002 & year==2009, freq bin(7)


** 2009年衆院選社民党の候補者に関する年齢の箱ひげ図を作成する（図5.9）
graph box age if year==2009 & party==1002


** 2009年衆院選政党別候補者に関する年齢の箱ひげ図を作成する（図5.10）
graph box age if year==2009 & wl==1, over(party)


** 2009年衆院選小選挙区における当選者年齢（自民党）の五数、平均値、標準偏差（表5.16）
tabstat age if year==2009 & party==800 & wl==1, ///
    stat(min p25 median p75 max mean sd)

** 2009年衆院選小選挙区における当選者年齢（民主党）の五数、平均値、標準偏差（表5.17）
tabstat age if year==2009 & party==1001 & wl==1, ///
    stat(min p25 median p75 max mean sd)

** 2009年衆院選小選挙区における当選者年齢（社民党）の五数、平均値、標準偏差（表5.18）
tabstat age if year==2009 & party==1002 & wl==1, ///
    stat(min p25 median p75 max mean sd)


** 2009年衆院選小選挙区における社民党当選者のプロフィールを表示する（表5.19）
list name ku kun party age ///
    if year==2009 & wl==1 & party==1002, noobs


** ログを閉じる
log close






