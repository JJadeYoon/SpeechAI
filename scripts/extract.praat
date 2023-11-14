# @author : JJadeYoon
# @date : 2023. 11. 13.
# @content : 레이블 별로 음원 추출 후 특정 구간으로 병합

# 음원 추출하기 (label 별로 나뉜 음원에서)
inputFolder$ = "/음성ai/scriptsPrac"
outputFolder$ = "/음성ai/scriptsPrac/extractPrac"


# 파일 읽기
form
	word inputName
endform
inputText$ = "'inputName$'.TextGrid"
inputSound$ = "'inputName$'.nsp"

Read from file: "'inputFolder$'/'inputText$'"
Rename... textObj
Read from file: "'inputFolder$'/'inputSound$'"
Rename... soundObj
selectObject: "TextGrid textObj"
plusObject: "Sound soundObj"


# 레이블링 된 음절 음원으로 추출
Extract non-empty intervals: 1, "no"
# 읽은 파일 삭제
selectObject: "TextGrid textObj"
plusObject: "Sound soundObj"
Remove


# 음절 별로 나뉜 음원 번호 매기기
for i to 32
	select all
	sound = selected('i')
	selectObject: sound
	Rename... 'i'
endfor


# 음절 특정 단위로 합쳐주기
# 높은 산에 올라가 / 맑은 공기를 마시며 / 소리를 지르면 / 가슴이 활짝 / 열리는 듯하다
sound [1] = 7
sound [2] = 8
sound [3] = 6
sound [4] = 5
sound [5] = 6

index [1] = 1
index [2] = 8
index [3] = 16
index [4] = 22
index [5] = 27

for i to 5

	# 음원 추출
	start = index [i]
	end = index [i] + sound [i] - 1
	for j from start to end
		if 'j' == 1
			selectObject: "Sound 'j'"
		else
			plusObject: "Sound 'j'"
		endif
	endfor

	Concatenate
	outputPath$ = "'outputFolder$'/'inputName$'_comb'i'.nsp"
	Save as text file: "'outputPath$'"
	Remove

	# 추출하는데 쓰인 파일 삭제
	for j from start to end
		if 'j' == 1
			selectObject: "Sound 'j'"
		else
			plusObject: "Sound 'j'"
		endif
	endfor
	Remove

endfor

select all
Remove