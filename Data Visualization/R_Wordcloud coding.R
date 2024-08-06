# Setting working directory and loading libraries
setwd("C:\\Users\\zlal1\\Documents\\myRproject")
library(stringr)
library(KoNLP)
library(wordcloud)
library(RColorBrewer)
useNIADic()

# Dictionary and Text Data Setup
mergeUserDic(data.frame(readLines("dicword.txt"), "ncn"))
data1 <-readLines("total.txt")
head(data1, 10)
length(data1)
data1 <-unique(data1)

# Text cleaning and noun extraction
data2 <-str_replace_all(data1, "[^[:alpha:]]", " ")
data3 <-extractNoun(data2)
head(data3, 5)
data4 <-lapply(data3, unique)
data5 <-gsub("\\d+", "", unlist(data4))

# Word normalization
data5 <-gsub(paste(c("프로그램", "남성육아프로그램", "양육남성육아프로그램"), collapse='|'), "남성육아프로그램", data5)
data5 <-gsub(paste(c("합계출산율"), collapse='|'), "출산율", data5)
data5 <-gsub(paste(c("저출산정책"), collapse='|'), "저출산대책", data5)
data5 <-gsub(paste(c("육아", "보육", "돌봄"), collapse='|'), "양육", data5)
data5 <-gsub(paste(c("경단", "경력", "단절", "경력단절"), collapse='|'), "경력단절", data5)
data5 <-gsub(paste(c("회사", "조직", "현장", "기업"), collapse='|'), "기업", data5)
data5 <-gsub(paste(c("아기", "어린이", "아이", "아이들", "아동", "유아"), collapse='|'), "자녀", data5)
data5 <-gsub(paste(c("양성평등", "평등", "성평등"), collapse='|'), "성평등", data5)
data5 <-gsub(paste(c("워라밸", "워라벨", "일가정양립", "일과삶의균형", "일생활양립", "일육아양립", "일생활", "일상", "일육아양립", "육아일양립", "가정일양립", "일양립", "가정양립", "생활일양립", "생활양립", "가정양립", "양립", "일가족일가정양립"), collapse='|'), "일가정양립", data5)
data5 <-gsub(paste(c("일육아병행", "양육병행", "육아병행", "일가정병행"), collapse='|'), "육아병행", data5)
data5 <-gsub(paste(c("롯데그룹"), collapse='|'), "롯데", data5)
data5 <-gsub(paste(c("가정"), collapse='|'), "가족", data5)
data5 <-gsub(paste(c("근로", "근로자"), collapse='|'), "기업", data5)
data5 <-gsub(paste(c("출산휴가", "휴가"), collapse='|'), "출산휴가", data5)
data5 <-gsub(paste(c("협력기구"), collapse='|'), "OECD", data5)
data5 <-gsub(paste(c("서울"), collapse='|'), "서울시", data5)
data5 <-gsub(paste(c("유급", "유급휴가", "유급출산휴가"), collapse='|'), "유급휴가", data5)
data5 <-gsub(paste(c("가사", "분담", "가사분담"), collapse='|'), "가사분담", data5)
data5 <-gsub(paste(c("휴직자", "양육휴직자", "육아휴직자"), collapse='|'), "육아휴직자", data5)
data5 <-gsub(paste(c("통상임금", "임금", "소득", "수입", "월급"), collapse='|'), "수입", data5)
data5 <-gsub(paste(c("지급"), collapse='|'), "지원", data5)
data5 <-gsub(paste(c("역할", "성역할"), collapse='|'), "성역할", data5)
data5 <-gsub(paste(c("차별", "성차별"), collapse='|'), "성차별", data5)
data5 <-gsub(paste(c("비용"), collapse='|'), "예산", data5)
data5 <-gsub(paste(c("눈치", "시선", "장려", "주변", "분위기"), collapse='|'), "분위기", data5)
data5 <-gsub(paste(c("유연", "유연근로", "재택", "재택근무", "유연근무"), collapse='|'), "유연근무", data5)
data5 <-gsub(paste(c("노동시간단축", "근로시간단축", "시간단축", "근로단축", "단축", "노동근로단축", "단축근무"), collapse='|'), "단축근무", data5)
data5 <-gsub(paste(c("남녀고용평등", "고용평등"), collapse='|'), "고용평등", data5)
data5 <-gsub(paste(c("아동수당", "육아수당", "양육수당", "수당", "자녀수당"), collapse='|'), "수당", data5)
data5 <-gsub(paste(c("아빠육아", "남성육아"), collapse='|'), "남성육아", data5)
data5 <-gsub(paste(c("아버지"), collapse='|'), "아빠", data5)
data5 <-gsub(paste(c("퇴근", "출퇴근"), collapse='|'), "출퇴근", data5)
data5 <-gsub(paste(c("인천", "인천시"), collapse='|'), "인천시", data5)
data5 <-gsub(paste(c("가사분담노동"), collapse='|'), "가사노동", data5)
data5 <-gsub(paste(c("서울시시"), collapse='|'), "서울시", data5)
data5 <-gsub(paste(c("성성평등"), collapse='|'), "성평등", data5)
data5 <-gsub(paste(c("성성차별"), collapse='|'), "성차별", data5)
data5 <-gsub(paste(c("양육지원"), collapse='|'), "지원", data5)
data5 <-gsub(paste(c("경기", "경기도"), collapse='|'), "경기도", data5)
data5 <-gsub(paste(c("저출산고령", "저출산고령화"), collapse='|'), "저출산고령화", data5)
data5 <-gsub(paste(c("고령", "고령화"), collapse='|'), "고령화", data5)
data5 <-gsub(paste(c("분위기금"), collapse='|'), "장려금", data5)
data5 <-gsub(paste(c("연장", "연장근무"), collapse='|'), "연장근무", data5)
data5 <-gsub(paste(c("우려", "걱정", "염려"), collapse='|'), "걱정", data5)
data5 <-gsub(paste(c("여성부", "가족부", "여성가족부"), collapse='|'), "여성가족부", data5)
data5 <-gsub(paste(c("독박양육"), collapse='|'), "독박육아", data5)
data5 <-gsub(paste(c("노동부", "고용고동부"), collapse='|'), "고용노동부", data5)
data5 <-gsub(paste(c("고용성평등법"), collapse='|'), "고용평등법", data5)
data5 <-gsub(paste(c("캠페인", "홍보"), collapse='|'), "홍보", data5)
data5 <-gsub(paste(c("출산분위기"), collapse='|'), "출산장려", data5)
data5 <-gsub(paste(c("인센티브", "포인트"), collapse='|'), "포인트", data5)
data5 <-gsub(paste(c("고충", "어려움", "힘듬"), collapse='|'), "어려움", data5)
data5 <-gsub(paste(c("고용고용노동부"), collapse='|'), "고용노동부", data5)
data5 <-gsub(paste(c("협력기구", "OECD"), collapse='|'), "OECD", data5)
data5 <-gsub(paste(c("양육휴직"), collapse='|'), "육아휴직", data5)

# Additional word removal
txt <-readLines("남성gsub.txt")
txt
cnt_txt <-length(txt)
cnt_txt
for ( i in 1:cnt_txt) {
  data5 <-gsub((txt[i]), "", data5)
}
head(data5, 5)

# Final text cleaning
data6 <-sapply(data5, function(x) {Filter(function(y) { nchar(y) >=2}, x)})
head(data6, 5)

# Word counting
wordcount <-table(unlist(data6))
head(sort(wordcount, decreasing=T), 200)

# Word cloud generation
palete <-brewer.pal(7, "Set2")
wordcloud(names(wordcount), freq=wordcount, scale=c(5,1), rot.per=0.25, min.freq=50, random.order=F, random.color=T, colors=palete)

data2 <-str_replace_all(data1, "[^[:alpha:]]", " ")


> head(data3,5)sap

data5 <-gsub(paste(c("

data6  <-str_replace_all(data5, "[^[:alpha:]]", " ")
data6 <-sapply(data5, function(x) {Filter(function(y) { nchar(y)>=2},x)})
wordcount <-table(unlist(data6))
head(sort(wordcount, decreasing=T), 150)
