# @author : JJadeYoon
# @date : 2023. 11. 13.
# @content : 레이블 별로 음원 추출 후 특정 구간으로 병합

## 파일 읽기
# 구조에 맞게 디렉토리 주소 설정
inputTextPath$ = "~/text"
inputSoundPath$ = "~/sound"
outputFolder$ = "~/extractPrac"

# 폴더에서 파일 읽어 list로 만들기
Create Strings as file list: "fileListText", "'inputTextPath$'/*.TextGrid"
numTextStr$ = Get number of strings
numTextStr$ = left$("'numTextStr$'", 1)
numText = number("'numTextStr$'")

Create Strings as file list: "fileListSound", "'inputSoundPath$'/*.nsp"
numSoundStr$ = Get number of strings
numSoundStr$ = left$("'numSoundStr$'", 1)
numSound = number("'numSoundStr$'")

# 텍스트 파일과 사운드 파일 개수 다를 시 경고
if numText != numSound
	pause Warning: Number of text and sound are different
endif


## list의 파일 하나씩 읽기
for i to 'numText'
	select Strings fileListText
	inputText$ = Get string... i
	where = index ("'inputText$'", ".")
	where = where - 1
	inputTextName$ = left$("'inputText$'", 'where')
	Read from file: "'inputTextPath$'/'inputText$'"
	Rename... textObj

	select Strings fileListSound
	inputSound$ = Get string... i
	where = index ("'inputSound$'", ".")
	where = where - 1
	inputSoundName$ = left$("'inputSound$'", 'where')
	Read from file: "'inputSoundPath$'/'inputSound$'"
	Rename... soundObj

	# 텍스트 파일과 사운드 파일 이름 다를 시 경고
	if "'inputTextName$'" != "'inputSoundName$'"
		pause Warning: Name of text and sound are different
	endif


	## 레이블링 된 음절 음원으로 추출
	selectObject: "TextGrid textObj"
	plusObject: "Sound soundObj"
	Extract non-empty intervals: 1, "no"
	pause Check if all labels are OK

	# 읽은 파일 삭제
	selectObject: "TextGrid textObj"
	plusObject: "Sound soundObj"
	Remove


	## 음절 별로 나뉜 음원 번호 매기기
	for j to 32
		select all
		sound = selected("Sound", 'j')
		selectObject: sound
		Rename... 'j'
	endfor


	## 음절 설정한 단위로 합쳐주기
	# 높은 산에 올라가 / 맑은 공기를 마시며 / 소리를 지르면 / 가슴이 활짝 / 열리는 듯하다
	# 자를 음절 개수 단위
	sound [1] = 7
	sound [2] = 8
	sound [3] = 6
	sound [4] = 5
	sound [5] = 6
	
	#누적 인덱스
	index [1] = 1
	index [2] = 8
	index [3] = 16
	index [4] = 22
	index [5] = 27	

	newFile$ = "'inputTextName$'_con"
	system mkdir 'outputFolder$'/'newFile$'

	for j to 5

		# 음원 합치기
		start = index [j]
		end = index [j] + sound [j] - 1
		for k from start to end
			if 'k' == 1
				selectObject: "Sound 'k'"
			else
				plusObject: "Sound 'k'"
			endif
		endfor
		
		Concatenate
		outputPath$ = "'outputFolder$'/'newFile$'/'newFile$''j'.wav"
		Save as WAV file: "'outputPath$'"
		Remove

		# 합치는데 쓰인 음성 파일 삭제
		for k from start to end
			if 'k' == 1
				selectObject: "Sound 'k'"
			else
				plusObject: "Sound 'k'"
			endif
		endfor
		Remove

	endfor


	## 리스트 외의 음성 파일 삭제
	select all
	minus Strings fileListText
	minus Strings fileListSound
	Remove

endfor
selec all
Remove