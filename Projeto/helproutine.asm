;****************************************************************
;test_X_init - verifies if the colision is possible
;
;
;****************************************************************

test_X_init:
    PUSH R0
    PUSH R1
    PUSH R3
    PUSH R4

test_X:
	MOV R1, [POS_ROVER_X]
	ADD R3, 2 				; endereco da coordenada X do meteoro
	MOV R7, [R3] 			; posicao X do meteoro
	MOV R6, [DEF_METEORO_3] ; largura do meteoro
	SUB R6, 1				
	ADD R7, R6		; posicao direita X do meteoro
	CMP R1, R7		; ve se a posicao do rover e maior que o limite direito do meteoro
	JGT cycle

	MOV R1, [POS_ROVER_X]
	MOV R7, [R3]			; posicao X do meteoro
	MOV R6, [DEF_ROVER]		
	ADD R1, R6
	SUB R1, 1				; limite direito do rover
	CMP R1, R7	; ve se o limite direito do rover e menor que o a posicao do meteoro
	JLT cycle

exit_test_X:
