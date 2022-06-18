; *********************************************************************************
; * IST-UL
;
; * Grupo: 4
;
; * Membros do Grupo:
;		- Miguel Sol 102710
;		- Joao Mestre 102779
;		- Rodrigo Moreira 103440
;
;
; *********************************************************************************

; *********************************************************************************
; Constantes Memória
; *********************************************************************************

KEY_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
KEY_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
MASK				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
DISPLAY				EQU 0A000H 	; endereço do display
DISPLAY_TIME		EQU 0FFFBH	; value that the interruption will make the display decrease
DISPLAY_COIN		EQU 000AH	; value that increases display in colision with coin
DISPLAY_METEOR 		EQU 0005H   ; value that increases display of missile colision with coin		
DISPLAY_MISSILE 	EQU 0FFFBH	; value that decreases display by the fire of a missil


DEF_LIN    			EQU 600AH      	; endereco do comando para definir a linha
DEF_COL   			EQU 600CH      	; endereco do comando para definir a coluna
DEF_PIXEL    		EQU 6012H      	; endereco do comando para escrever um pixel
CLEAR_WARNING     	EQU 6040H      	; endereco do comando para apagar o aviso de nenhum cenário selecionado
CLEAR_SCREEN	 	EQU 6002H      	; endereco do comando para apagar todos os pixels ja desenhados
BACKGROUND_SELECT 	EQU 6042H      	; endereco do comando para selecionar uma imagem de fundo
PLAY_SOUND			EQU 605AH      	; endereco do comando para tocar um som

; ********************************************************************************
; Constantes
; ********************************************************************************
MASK_DISPLAY		EQU 0FFFH	; isolar os 12 bits de menor peso, ao ler o valor do display
HEXTODEC 			EQU 0AH
ON					EQU 1	; activate the update_display routine
OFF					EQU 0	; activate the update_display routine
TRUE 				EQU 1
FALSE				EQU 0

KEY_LEFT			EQU 4		; tecla para movimentar para a esquerda (tecla 4)
KEY_RIGHT			EQU 6		; tecla para movimentar para a direita (tecla 6)
KEY_FIRE_MISSILE	EQU 1		; tecla para disparar umm missil (tecla 1)
KEY_START			EQU 8		; tecla para iniciar/continuar o jogo (tecla 8)

LINE_ROVER      EQU  28     ; linha do boneco (posicao mais baixa)
COL_ROVER		EQU  30     ; coluna do boneco (a meio do ecra)

COL_MIN			EQU  0		; numero da coluna mais a esquerda
COL_MAX			EQU  63   	; numero da coluna mais a direita 
LINE_MIN		EQU	 0		; numero da linha mais em cima 
LINE_MAX		EQU	 0F80H	; numero da linha mais em baixo
OBJ_LINE_MAX 	EQU 32		; numero maximo que o meteoro pode atingir de forma a nao afetar o rover

DISPLAY_MAX			EQU 64H 	; numero maximo que o display deve mostrar (100 dec)
DISPLAY_MIN			EQU 0H  	; numero minimo que o display deve mostrar
DISPLAY_INIT		EQU 0100H	; valor inicial do display

WIDTH_ROVER			EQU	5		; largura do ROVER
HEIGH_ROVER			EQU 4		; altura do ROVER

WIDTH_FRAGMENT_1	EQU 1		; largura do fragmento 1
HEIGH_FRAGMENT_1	EQU 1		; altura do fragmento 1

WIDTH_FRAGMENT_2	EQU 2		; largura do fragmento 2
HEIGH_FRAGMENT_2	EQU 2		; altura do fragmento 2

WIDTH_METEOR_1		EQU 3		; largura do meteoro nivel 1
HEIGHT_METEOR_1		EQU 3		; altura do meteoro nivel 1

WIDTH_METEOR_2		EQU 4		; largura do meteoro nivel 2
HEIGHT_METEOR_2		EQU 4		; altura do meteoro nivel 2

WIDTH_METEOR_3		EQU	5		; largura do meteoro nivel 3
HEIGHT_METEOR_3		EQU 5		; altura do meteoro nivel 3

WIDTH_COIN_1		EQU 3		; largura do moeda nivel 1
HEIGHT_COIN_1		EQU 3		; altura do moeda nivel 1

WIDTH_COIN_2		EQU 4		; largura do moeda nivel 2
HEIGHT_COIN_2		EQU 4		; altura do moeda nivel 2

WIDTH_COIN_3		EQU	5		; largura do moeda nivel 3
HEIGHT_COIN_3		EQU 5		; altura do moeda nivel 3

WIDTH_EXPLOSION		EQU 5		; largura da explosao
HEIGHT_EXPLOSION	EQU 5		; altura da explosao

WIDTH_MISSILE		EQU 1		; largura do missil
HEIGHT_MISSILE		EQU 1		; altura do missil

MISSILE_LIN_MAX		EQU 19		; máximo altura missil

TYPE_EXPLOSION		EQU 3
TYPE_COIN			EQU 2		; define os tipos para comparações
TYPE_METEOR			EQU 1
TYPE_UNDEFINED		EQU 0

MOVE_NEXT_WORD				EQU 2		;passa para a próxima word da tabela
MOVE_NEXT_TWO_WORDS			EQU 4		;passa duas palavras para a frente
MOVE_PREVIOUS_WORD			EQU 2
MOVE_PREVIOUS_TWO_WORDS		EQU 4

START_MENU				EQU 0		
STANDARD_BACKGROUND 	EQU 1
LOSE_CONTACT_METEOR		EQU 2
PAUSE_MENU				EQU 3		

FIRE_MISSILE_SOUND		EQU 0
TOUCH_COIN_SOUND		EQU 1
HIT_COIN_SOUND			EQU 2
HIT_METEOR_SOUND		EQU 3
TOUCH_METEOR_SOUND		EQU 4

RED		EQU	0FF00H		; cor vermelha
BLACK	EQU 0F000H		; cor preta
WHITE 	EQU 0FFFFH		; cor branca
BLUE	EQU 0F3CDH		; cor azul
GRAY	EQU 0FCCCH		; cor cinzenta
GREEN	EQU 0F0F0H		; cor verde
BROWN	EQU 0F840H		; cor castanha 
YELLOW	EQU 0FFF0H		; cor amarela 
MUSTARD	EQU 0FFD5H		; cor mostarda
DRKBLUE EQU 0F16BH		; cor azul escuro
ORANGE 	EQU 0FFB2H		; cor laranja

; *********************************************************************************
; Dados 
; *********************************************************************************

PLACE 3000H

POS_ROVER_X:				WORD	0000H	; endereco de memoria da coluna do rover
POS_ROVER_Y:				WORD	0000H	; endereco de memoria da linha do rover
POS_MISSILE_X:				WORD	0000H	; endereco de memoria da coluna do missil
POS_MISSILE_Y:				WORD	0000H	; endereco de memoria da linha do missil
DISPLAY_VAL:				WORD	0000H	; endereco de memoria do valor do display
INC_DEC_DISPLAY: 			WORD	0000H	; endereço de memória de valor a acrescentar ao display
INTERRUPTION_METEOR: 		WORD 0000H	; endereço de memória do valor de ativação do movimento do meteoro
INTERUPTION_MISSILE:  		WORD 0000H	; endereço de memória do valor de ativação do movimento do missíl
INTERRUPTION_ENERGIA: 		WORD 0000H	; endereço de memória do valor de ativação da redução da energia
MISSILE_NUMBER:				WORD 0000H	; endereco de memoria do numero de misseis no ecra
PRESSED_KEY:				WORD 0000H	; endereco de memoria da tecla premida
RANDOM_NUMBER:  			WORD 0000H	; endereco de memoria do numero random
STOP:						WORD 0000H	; endereco de memoria do condicao
COLISION_MISSILE_HAPPENED: 	WORD 0000H	; endereco de memoria da condicao  
COLISION_MISSILE_POSSIBLE: 	WORD 0000H	; endereco de memoria da condicao  


PLACE 2000H

pilha:
	STACK 100H			; espaco reservado para a pilha 
						; (200H bytes, pois sao 100H words)
SP_inicial:				; este e o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)

; **************************************************************************************
; Definicoes
; ***************************************************************************************

DEF_ROVER:				; tabela que define o rover (cor, largura, altura, pixels)
	WORD		WIDTH_ROVER
	WORD		HEIGH_ROVER
	WORD		0, 	0, 	BLUE, 0, 0
	WORD		0, GRAY, BLUE, GRAY, 0		
	WORD		GRAY, GRAY, GRAY, GRAY, GRAY
    WORD		0, 0, RED, 0, 0

DEF_FRAGMENT_1:			; tabela que define o fragmento 1 (cor, largura, altura, pixels)
	WORD		WIDTH_FRAGMENT_1
	WORD		HEIGH_FRAGMENT_1
	WORD		GRAY

DEF_FRAGMENT_2:			; tabela que define o fragmento 2 (cor, largura, altura, pixels)
	WORD		WIDTH_FRAGMENT_2
	WORD		HEIGH_FRAGMENT_2
	WORD		GRAY, GRAY
	WORD		GRAY, GRAY

DEF_METEOR_1:			; tabela que define o meteoro nivel 1 (cor, largura, altura, pixels)
	WORD		WIDTH_METEOR_1
	WORD		HEIGHT_METEOR_1
	WORD		YELLOW, 0, YELLOW
	WORD		RED, BROWN, RED
	WORD		0, BROWN, 0

DEF_METEOR_2:			; tabela que define o meteoro nivel 2 (cor, largura, altura, pixels)
	WORD		WIDTH_METEOR_2
	WORD		HEIGHT_METEOR_2
	WORD		YELLOW, 0, 0, YELLOW
	WORD		YELLOW, RED, RED, YELLOW
	WORD		RED, BROWN, BROWN, RED
	WORD		0, BROWN, BROWN, 0

DEF_METEOR_3:			; tabela que define o meteoro nivel 3 (cor, largura, altura, pixels)
	WORD		WIDTH_METEOR_3
	WORD		HEIGHT_METEOR_3
	WORD		YELLOW , 0 , YELLOW , 0 , YELLOW
	WORD		0 , YELLOW , RED , YELLOW , 0
	WORD		YELLOW , RED , BROWN , RED , YELLOW
    WORD		RED , BROWN , BROWN , BROWN , RED
	WORD		0 , RED , BROWN , RED , 0

DEF_COIN_1:			; tabela que define a moeda nivel 1 (cor, largura, altura, pixels)
	WORD		WIDTH_COIN_1
	WORD		HEIGHT_COIN_1
	WORD		0, YELLOW, 0
	WORD		YELLOW, MUSTARD, YELLOW
	WORD		0, YELLOW, 0	

DEF_COIN_2:			; tabela que define a moeda nivel 2 (cor, largura, altura, pixels)
	WORD		WIDTH_COIN_2
	WORD		HEIGHT_COIN_2
	WORD		0, YELLOW, YELLOW, 0
	WORD		YELLOW, WHITE, MUSTARD, YELLOW
	WORD		YELLOW, MUSTARD, YELLOW, YELLOW
	WORD		0, YELLOW, YELLOW, 0

DEF_COIN_3:			; tabela que define a moeda nivel 3 (cor, largura, altura, pixels)
	WORD		WIDTH_COIN_3
	WORD		HEIGHT_COIN_3
	WORD		0, YELLOW, YELLOW, YELLOW, 0
	WORD		YELLOW, WHITE, MUSTARD, MUSTARD, YELLOW
	WORD		YELLOW, MUSTARD, YELLOW, YELLOW, YELLOW
	WORD		YELLOW, MUSTARD, YELLOW, YELLOW, YELLOW
	WORD		0, YELLOW, YELLOW, YELLOW, 0

DEF_EXPLOSION:			; tabela que define a explosao (cor, largura, altura, pixels)
	WORD		WIDTH_EXPLOSION
	WORD		HEIGHT_EXPLOSION
	WORD		0, YELLOW, 0, YELLOW, 0
	WORD		YELLOW, ORANGE, RED, ORANGE, YELLOW
	WORD		0, RED, BLUE, RED, 0
	WORD		YELLOW, ORANGE, RED, ORANGE, YELLOW
	WORD		0, YELLOW, 0, YELLOW, 0

DEF_MISSILE:				; tabela que define o missil (cor, largura, altura, pixels)
	WORD		WIDTH_MISSILE
	WORD		HEIGHT_MISSILE
	WORD		DRKBLUE

DEF_SCREEN:
	WORD		64
	WORD 		32

interruptions:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2

coord_0:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro
coord_1:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro
coord_2:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro
coord_3:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro

coord_objects:
	WORD coord_0				; objeto 0 
	WORD coord_1				; objeto 1 
	WORD coord_2				; objeto 2 
	WORD coord_3				; objeto 3 

; *********************************************************************************
; Codigo
; *********************************************************************************

PLACE   0H                   ; o codigo tem de comecar em 0000H

beginning:
	MOV  SP, SP_inicial						; inicializa SP para a palavra a seguir a ultima da pilha 
	MOV  BTE, interruptions					; inicializa BTE (registo de Base da Tabela de Exce��es)
    MOV  [CLEAR_WARNING], R1				; apaga o aviso de nenhum cenario selecionado (o valor de R1 nao e relevante)
    MOV  [CLEAR_SCREEN], R1					; apaga todos os pixels ja desenhados (o valor de R1 nao e relevante)
	EI0										; permite interrupções 0
	EI1										; permite interrupções 1
	EI2										; permite interrupções 2
	EI										; permite interrupções (geral)


; *****************
;
;*****************
start_menu:
	MOV	R1, START_MENU								; cenario de fundo numero 0
    MOV  [BACKGROUND_SELECT], R1	
	CALL wait_key_play
	CALL restart
	JMP main

; *****************
;
;*****************
lost:
	CALL  lose_contact
	CALL wait_key_play
	CALL restart
	JMP main

; *****************
;
;*****************
restart:
	CALL init_game_various
	CALL init_display	;dá reset ao display
	CALL init_rover
	CALL reset_objects
	
	RET

; *****************
;
;*****************
main:
	CALL keyboard			; leitura às tecla
	CALL test_pause
	CALL rover				; Move Rover caso tecla tenha sido premida
	CALL missile
	CALL meteor
	CALL colision_object_init
	CALL colision_missile_init
	CALL update_display
	MOV R1, ON				; ESTA PARTE ESTÁ FEIA -------------------------
	MOV R2, [STOP]			; NAO SEI COMO MELHORAR-----------------------
	CMP R2, R1
	JZ lost
	JMP main




; **********************************************************************
; Missile_colision - Verifies if the missile colides with the meteor or 
;					the coin
; **********************************************************************

colision_missile_init:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R9
	MOV R9, FALSE
	MOV [COLISION_MISSILE_HAPPENED], R9
	MOV R0, [MISSILE_NUMBER]
	CMP R0, 0
	JZ 	end_colision_missile 	; se nao houver missil nao e necessario verificar a colisao
	MOV R3 , 0					; counter iteracao iniciado a 0
	
colision_missile_main:				; PODE SER FACILMENTE CLEANED UP -------------------------
	MOV R7, R3					
	SHL R7, 1		
	MOV R0, coord_objects		;endereço da tabela das coordenadas
	ADD R0, R7					; R0 enderco da tabela coord
	MOV R1,[R0]					; R1 = enderco da pos Y
	MOV R6, [R1]				; R6 = pos Y do objeto
	MOV R4,	15				; altura a que os objetos ficam no seu tamanho maximo
	CMP R6,R4						
	JLT next_object			;se a colisao nao for possivel entao salta para o proximo objeto

	ADD R1, MOVE_NEXT_TWO_WORDS	
	MOV R2, [R1]					; R2 passa a ser o tipo de objeto
	CMP R2, TYPE_METEOR			; se for um meteoro
	JZ colisao_missil_meteoro
	CMP R2, TYPE_COIN				; se for uma moeda
	JZ colision_missile_coin
	JMP next_object					; se for uma explosao



colisao_missil_meteoro:			; PODE SER JUNTA COM A COLISAO MISSILE COIN
	SUB R1, MOVE_PREVIOUS_TWO_WORDS					; R1 de volta a pos Y
	MOV R0, R1
	MOV R4, DEF_METEOR_3		; colisoes so podem acontecer com objetos grandes
	CALL colision_missile		; R0 = tabela do objeto, R4 = def do objeto
	CMP R8 , 1
	JNZ next_object
	CALL handle_colision_missile_meteor ;se houve colisao
	JMP next_object

colision_missile_coin:
	SUB R1, MOVE_PREVIOUS_TWO_WORDS			; R1 de volta a pos Y
	MOV R0, R1
	MOV R4, DEF_COIN_3		; colisoes so podem acontecer com objetos grandes
	CALL colision_missile	; R0 = tabela do objeto, R4 = def do objeto
	CMP R8 , 1
	JNZ next_object	; se houve colisao
	CALL handle_colision_missile_coin
	JMP next_object

next_object:
	ADD R3, 1
	CMP R3 ,4
	JZ end_colision_missile		;quando já tiver passado pelos quatro meteoros
	JMP colision_missile_main


end_colision_missile:
	CALL colision_happened_check
	POP R9
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET



; **********************
;
;******************

colision_happened_check:
	PUSH R9
	MOV R9, [COLISION_MISSILE_HAPPENED]
	CMP R9, TRUE
	JNZ end_colision_happened_check
	MOV R9, 0
	MOV [MISSILE_NUMBER], R9
	MOV [COLISION_MISSILE_HAPPENED], R9
end_colision_happened_check:
	POP R9
	RET


; **********************
;
;******************

handle_colision_missile_meteor:
	PUSH R1
	PUSH R5
	MOV R1, DISPLAY_METEOR
	MOV [INC_DEC_DISPLAY], R1
	MOV R1, HIT_METEOR_SOUND	
	MOV [PLAY_SOUND], R1	; faz o som
	MOV R5, DEF_METEOR_3
	CALL draw_explosion
	POP R5
	POP R1
	RET

; **********************
;
;******************
handle_colision_missile_coin:
	PUSH R1
	PUSH R5
	MOV R1, HIT_COIN_SOUND
	MOV [PLAY_SOUND], R1		; faz o som
	MOV R5, DEF_COIN_3
	CALL draw_explosion
	POP R5
	POP R1
	RET



; **********************
;
;******************
draw_explosion:
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R9

	MOV R1, [POS_MISSILE_Y]
	MOV R2, [POS_MISSILE_X]
	MOV R4, DEF_MISSILE
	CALL erase_object		;apaga o missil

	MOV R1, [R0]			; R1 = POS Y
	ADD R0, MOVE_NEXT_WORD
	MOV R2, [R0]			; R2= POS X
	MOV R4, R5	; R4 = DEF
	CALL erase_object		; apaga o boneco

	MOV R4, DEF_EXPLOSION	; R4 = DEF
	CALL draw_object		; desenha a explosao
	
	ADD R0, MOVE_NEXT_WORD
	MOV R4, TYPE_EXPLOSION
	MOV [R0], R4			; muda o tipo do objeto para explosao
	MOV R9, TRUE	; houve colisao
	MOV [COLISION_MISSILE_HAPPENED], R9

	POP  R9
	POP R4
	POP R2
	POP R1
	RET

; *************************************************
; R0 = tabela do objeto
; R4 = Def do objeto
; ***********************************************

colision_missile: 				; R0 endereco do meteoro
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	MOV  R8, FALSE

	CALL set_coordinates_colision_missile

	CMP  R4, R1
	JLT  exit_missile_colision
	CMP  R4, R5
	JGT  exit_missile_colision
	CMP  R7, R2
	JLT  exit_missile_colision
	CMP  R7, R6 	
	JGT  exit_missile_colision 	; testam se o missil esta fora da "caixa" em que o meteoro se insere

	MOV  R8, TRUE
exit_missile_colision:
	POP	R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	

; **********************
;
;******************

set_coordinates_colision_missile:
	MOV R2, [R0] 				; coordenada Y do meteoro
	ADD  R0, MOVE_NEXT_WORD
	MOV R1, [R0] 				; coordenada X do meteoro

	MOV R5, [R4] 				; largura do meteoro
	ADD  R5,R1 					
	SUB R5, 1					; coordenada x mais a direita do meteoro
	ADD  R4, MOVE_NEXT_WORD
	MOV R6, [R4] 				; altura do meteoro
	ADD  R6,R2 				
	SUB R6, 1						; coordenada y mais a baixo do meteoro
	MOV R4, [POS_MISSILE_X] 				; coordenada x do missil
	MOV R7, [POS_MISSILE_Y] 				; coordenada y do missil
	RET

;************************************************************************





colision_object_init:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9

	MOV R9, 0	; iteração

colision_main:
	MOV R3, coord_0 		; tabela do objeto 0
	MOV R1, 15			; linha em que os objetos ficam grandes
	CMP R3, R1			; nao vale a pena comparar se o objeto nao estiver ainda grande
	JLT cycle			
	ADD R3, R9			; passa para a tabela do objeto correto
	ADD R3, MOVE_NEXT_TWO_WORDS		; chegar ao tipo de objeto
	MOV R6, [R3]		; R6 = tipo objeto
	CMP R6, TYPE_METEOR	
	JZ colision_meteor	; se for meteoro
	CMP R6, TYPE_COIN
	JZ colision_moeda	; se for moeda
	JMP cycle

colision_meteor:
	SUB R3, MOVE_PREVIOUS_TWO_WORDS	; volta a posicao Y
	MOV R1, [R3]	; R1 = pos Y do meteoro
	MOV R6, DEF_METEOR_3	; vai buscar o meteoro
	ADD R6, MOVE_NEXT_WORD				; vai buscar a altura do meteoro
	MOV R5, [R6]			; R5 = altura do meteoro
	ADD R1, R5				; R1 passa a ser a linha de baixo do meteoro
	MOV R4, [POS_ROVER_Y]	; R4 = linha de cima do rover
	CMP R1, R4
	JGE meteor_test_X		; se for possivel haver colisao
	JMP cycle
meteor_test_X:
	MOV R4, [POS_ROVER_X]
	ADD R3, MOVE_NEXT_WORD				; endereco da coordenada X do meteoro
	MOV R7, [R3] 			; posicao X do meteoro
	MOV R6, [DEF_METEOR_3] ; largura do meteoro
	SUB R6, 1				
	ADD R7, R6		; posicao direita X do meteoro
	CMP R4, R7		; ve se a posicao do rover e maior que o limite direito do meteoro
	JGT cycle

	MOV R4, [POS_ROVER_X]
	MOV R7, [R3]			; posicao X do meteoro
	MOV R6, [DEF_ROVER]		
	ADD R4, R6
	SUB R4, 1				; limite direito do rover
	CMP R4, R7	; ve se o limite direito do rover e menor que o a posicao do meteoro
	JLT cycle
	
	JMP handle_colision_meteor

colision_moeda:
	SUB R3,	MOVE_PREVIOUS_TWO_WORDS		; volta a posicao Y
	MOV R1, [R3]	; R1 = pos Y da moeda
	MOV R6, DEF_COIN_3	; vai buscar a moeda
	ADD R6, MOVE_NEXT_WORD			; vai buscar a altura da moeda
	MOV R5, [R6]			; R5 = altura da moeda
	ADD R1, R5		; R1 passa a ser a linha de baixo da moeda
	MOV R4, [POS_ROVER_Y]	; R4 = linha de cima do rover
	CMP R1, R4
	JGE coin_test_X		; se for possivel haver colisao
	JMP cycle

coin_test_X:
	MOV R4, [POS_ROVER_X]
	ADD R3, MOVE_NEXT_WORD 	 ; enderco da coordenada X da moeda
	MOV R7, [R3] ; posicao X da moeda
	MOV R6, [DEF_COIN_3] ; largura da moeda
	SUB R6, 1
	ADD R7, R6	; posicao direita X da moeda
	CMP R4, R7	; ve se a posicao do rover e maior que o limite direito da moeda
	JGT cycle

	MOV R4, [POS_ROVER_X]
	MOV R7, [R3]	; posicao X da moeda
	MOV R6, [DEF_ROVER]
	ADD R4, R6
	SUB R4, 1 	; limite direito do rover	
	CMP R4, R7	; ve se o limite direito do rover e menor que o a posicao da moeda
	JLT cycle
	JMP handle_colision_coin


handle_colision_meteor:
	MOV R1, TOUCH_METEOR_SOUND
	MOV [PLAY_SOUND], R1
	MOV R1, ON
	MOV [STOP], R1
	JMP end_colision


handle_colision_coin:   ; alterar ------------------ nao e o que deve acontecer nesta colisao
	MOV R1, DISPLAY_COIN
	MOV [INC_DEC_DISPLAY], R1
	SUB R3, MOVE_PREVIOUS_WORD			; R3 = inicio da tabela coord
	MOV R1, [R3]				; R1 = pos Y
	ADD R3, MOVE_NEXT_WORD			
	MOV R2, [R3]				; R2 = pos X
	MOV R4, DEF_COIN_3
	CALL erase_object		
	ADD R3, MOVE_NEXT_WORD
	MOV R1, TYPE_UNDEFINED
	MOV [R3], R1
	MOV R1, TOUCH_COIN_SOUND
	MOV [PLAY_SOUND], R1	
	JMP cycle

cycle:
	MOV R8, 18
	CMP R9, R8	; se ja tiver feito o ultimo objeto
	JZ end_colision
	ADD R9, 6	; para passar para a table de posicoes correta
	JMP colision_main

end_colision:
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET



; ****************************
;
; ***************************

meteor:
	PUSH R1
	PUSH R3
	MOV R1, [INTERRUPTION_METEOR]
	CMP R1, OFF
	JZ end_meteor
	MOV R3, 0				; numero do meteoro
	CALL move_object

	MOV R3, 1
	CALL move_object	
	
	MOV R3, 2
	CALL move_object
	
	MOV R3, 3
	CALL move_object

	MOV R1, OFF
	MOV [INTERRUPTION_METEOR], R1

end_meteor:
	POP R3
	POP R1
	RET



; ***********************
;
; *********************

random_number_0_8:	; obtem um numero random entre 0 e 8
	PUSH R0
	PUSH R1
	MOV R1,KEY_COL
	MOVB R0, [R1]
	SHR R0, 5
	MOV [RANDOM_NUMBER], R0
	POP R1
	POP R0
	RET

; ***********************
;
; *********************
random_column:		; obtem uma coluna random com os valores: 0,8,16,24,32,40,48,56
	PUSH R0
	PUSH R1
	CALL random_number_0_8
	MOV R1, [RANDOM_NUMBER]
	MOV R0, 8
	MUL R1, R0
	MOV [RANDOM_NUMBER], R1
	POP R1
	POP R0
	RET

; ***********************
;
; *********************
random_type:		; obtem um tipo random sendo moeda quando o valor e 48 ou 56, e meteoro no resto
	PUSH R0
	PUSH R1
	PUSH R2
	CALL random_number_0_8
	MOV R1, [RANDOM_NUMBER]
	MOV R0, 8
	MUL R1, R0
	MOV R2, 48
	CMP R1, R2
	JGE random_type_moeda
	MOV R1, TYPE_METEOR
	MOV [RANDOM_NUMBER], R1
	JMP random_type_end
random_type_moeda:
	MOV R1, TYPE_COIN
	MOV [RANDOM_NUMBER],R1
	JMP random_type_end
random_type_end:
	MOV [RANDOM_NUMBER], R1
	POP R2
	POP R1
	POP R0
	RET
; **********************************************************************
; ANIMA_METEORO - Rotina cooperativa que desenha e faz descer o objeto
;			 numa dada coluna. Se chegar ao fundo, passa ao topo.
;			As coordenadas dos objetos sao guardadas numa tabela de 
;			tabelas (coord_objects), em que cada word possui uma tabela
;			com as coordenadas de cada objeto e o seu tipo.
; Argumentos: R3 - Numero do meteoro (0 a 3)
; **********************************************************************


 move_object:

	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8

	MOV  R6, R3				; copia de R3 (para nao destruir R3)
	SHL  R6, 1				; multiplica o numero do meteoro por 2 (porque a coord_objects e uma tabela de words)
	MOV R8, coord_objects
	MOV  R5, [R8+R6]		; R5 = enderco da pos Y
	MOV  R1, [R5]			; R1 = pos Y do objeto
	
	ADD	 R5, MOVE_NEXT_WORD 				; R5 = endereco da pos X 
	MOV  R2, [R5]			; R2 = pos X do objeto

	ADD R5, MOVE_NEXT_WORD
	MOV R3, [R5]			; R3 = tipo do objeto

	CMP R3, TYPE_UNDEFINED	
	JZ object_init			; se o objeto ainda nao tiver tipo entao deve ser criado

	CMP R3, TYPE_EXPLOSION	
	JZ explosion				; se o objeto for uma explosao

	ADD  R1, 1				; passa a linha abaixo
	MOV  R4, OBJ_LINE_MAX
	CMP  R1, R4				; ja estava na linha do fundo?
	JLT  move

	SUB R1, 1
	MOV R4, DEF_COIN_3		; o DEF_COIN_3 pode ser qualquer um dos tipos finais
	CALL erase_object		; apaga o objecto que chegou ao limite
	MOV R6, TYPE_UNDEFINED
	JMP object_init			; reinicia o objeto

object_init:
	SUB R5, MOVE_PREVIOUS_TWO_WORDS
	MOV R1, 0FFFFH			; 
	MOV [R5], R1			; poe na linha -1 para uma animacao mais fluida
	CALL random_column		; obtem uma coluna em que desenhar o objeto
	MOV R2, [RANDOM_NUMBER]	
	ADD R5, MOVE_NEXT_WORD
	MOV [R5], R2			; poe o valor da coluna  no objeto
	CALL random_type		; obtem um tipo para o objeto
	MOV R4, [RANDOM_NUMBER]
	ADD R5, MOVE_NEXT_WORD
	MOV [R5], R4			; poe o tipo do objeto no objeto
	JMP end_move_object	; desenha o objeto no ciclo seguinte para um animacao mais fluida

explosion:					; a explosao deve durar um ciclo e permitir a criacao de um objeto novo
	MOV R4, DEF_EXPLOSION
	CALL erase_object			; apaga a explosao
	MOV R3, TYPE_UNDEFINED		
	MOV [R5], R3				; passa o tipo do objeto para indefinido para ser criado um novo no proximo ciclo
	JMP end_move_object

move:	
	SUB R5, MOVE_PREVIOUS_TWO_WORDS			; R5 volta a ser o endereco da pos Y
	MOV  [R5], R1		; atualiza na tabela a linha em que esta o meteoro
	CMP R1,	1
	JLE fragment1

	MOV R7, 4
	CMP R1, R7 
	JLE fragment2

	CMP R3, TYPE_METEOR
	JZ is_meteor
	CMP R3, TYPE_COIN
	JZ is_coin
	MOV R8, 0
	CMP R8, TYPE_METEOR	; objeto e do tipo meteoro?
	JZ is_meteor			; se sim desenha um meteoro

is_coin:
	MOV R7, 8
	CMP R1, R7
	JLE coin1

	MOV R7, 14 
	CMP R1, R7
	JLE coin2


	JMP coin3

is_meteor:
	MOV R7, 8
	CMP R1, R7
	JLE meteor1

	MOV R7, 14
	CMP R1, R7
	JLE meteor2


	JMP meteor3

fragment1:
	MOV R4, DEF_FRAGMENT_1
	SUB R1, 1
	CALL erase_object
	ADD R1, 1
	CALL draw_object		; escreve o meteoro na nova linha
	JMP end_move_object

fragment2:
	MOV R4, DEF_FRAGMENT_2
	SUB R1, 1
	CALL erase_object
	ADD R1, 1
	CALL draw_object
	JMP end_move_object

meteor1:
	MOV R4, DEF_METEOR_1
	SUB R1, 1
	CALL erase_object
	ADD R1,1
	CALL draw_object
	JMP end_move_object

meteor2:
	MOV R4, DEF_METEOR_2
	SUB R1, 1
	CALL erase_object
	ADD R1,1
	CALL draw_object
	JMP end_move_object

meteor3:
	MOV R4, DEF_METEOR_3
	SUB R1, 1
	CALL erase_object
	ADD R1,1
	CALL draw_object
	JMP end_move_object

coin1:
	MOV R4, DEF_COIN_1
	SUB R1, 1
	CALL erase_object
	ADD R1,1
	CALL draw_object
	JMP end_move_object

coin2:
	MOV R4, DEF_COIN_2
	SUB R1, 1
	CALL erase_object
	ADD R1,1
	CALL draw_object
	JMP end_move_object

coin3:
	MOV R4, DEF_COIN_3
	SUB R1, 1
	CALL erase_object
	ADD R1,1
	CALL draw_object
	JMP end_move_object

end_move_object:
	POP	 R8
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	RET

; ************************************************************************
; MISSIL - moves the missil one position at a time(depends on exception 1)
;
; ************************************************************************

missile:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV R1,[PRESSED_KEY]	
	CMP R1, KEY_FIRE_MISSILE
	JNZ move_missile			; se a tecla do missil nao foi premida entao deve apenas mover o missil

	MOV R1, [MISSILE_NUMBER]
	CMP R1, 0				
	JZ draw_missile			; se a tecla foi premida e nao existe outro missil entao deve desenhar um

	JMP exit_missil

draw_missile:
	MOV R1, DISPLAY_MISSILE
	MOV [INC_DEC_DISPLAY], R1
	MOV R2, FIRE_MISSILE_SOUND
	MOV [PLAY_SOUND], R2			; toca o som de quando o missil foi disparado
	MOV R2, [POS_ROVER_X]
	MOV R1, [POS_ROVER_Y]
	SUB R1, 1
	ADD R2, 2
	MOV [POS_MISSILE_X],R2		; define as posicoes onde o missil vai aparecer
	MOV [POS_MISSILE_Y],R1
	MOV R4, DEF_MISSILE
	CALL draw_object			; desenha o missil
	MOV R4, 1
	MOV [MISSILE_NUMBER], R4		;escreve na memoria que já existe um missil
	JMP exit_missil

move_missile:
	MOV R1, [MISSILE_NUMBER]
	CMP R1, 0
	JZ exit_missil			; se nao existe um missil entao nao deve mover
	
	MOV R1,[INTERUPTION_MISSILE]
	CMP R1 , ON				;verifica se a interrupção foi ativada
	JNZ exit_missil
	MOV R2,[POS_MISSILE_X]  
	MOV R1,[POS_MISSILE_Y]
	MOV R4, DEF_MISSILE
	CALL test_upper_limit_missile	
	CMP R0,0				;verifica se o missil chegou ao limite do ecra
	JZ missile_disapear		; se chegou ao limite este deve desaparecer
	
	CALL erase_object	; apaga o missil na posicao atual
	SUB R1,1
	MOV [POS_MISSILE_Y],R1
	CALL draw_object		; desenha o boneco no pixel acima
	MOV R1,OFF
	MOV [INTERUPTION_MISSILE],R1	; reset ao valor da interrupcao
	JMP exit_missil

missile_disapear:				; apaga o missil existente
	MOV R3, 0
	MOV [MISSILE_NUMBER], R3
	MOV R2, [POS_MISSILE_X]
	MOV R1, [POS_MISSILE_Y]
	MOV R4, DEF_MISSILE
	CALL erase_object
	JMP exit_missil

exit_missil:
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET


; ********************************************************
;
;******************************************************

test_upper_limit_missile:
	PUSH R3
	MOV R3,MISSILE_LIN_MAX
	CMP R1,R3
	JZ erase_missile
	JMP end_test_upper_limit_missile
erase_missile:
	CALL erase_object
	MOV R0,0
	MOV [MISSILE_NUMBER],R0
end_test_upper_limit_missile:
	POP R3
	RET


; ************************************************************************
; update_display - 
;
; ************************************************************************
update_display:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R6

	MOV R2,[INC_DEC_DISPLAY]	; R2 = valor a somar ao display
	CMP R2, 0
	JZ exit_update_display
	MOV R1, [DISPLAY_VAL]
	CALL test_display_limits
	MOV [DISPLAY_VAL], R1		; guarda em memoria o novo valor do display
	MOV R6, DISPLAY_MAX
	CMP R1, R6
	JZ	change_display_100
	CALL HEX_TO_DEC				; altera-se este vaor para decimal

change_display:
	MOV [DISPLAY], R1			; altera o display com o valor em decimal
	MOV R3, OFF
	MOV [INC_DEC_DISPLAY],R3
	JMP exit_update_display

change_display_100:
	MOV R1, DISPLAY_INIT
	MOV [DISPLAY], R1			; altera o display com o valor em decimal
	MOV R3, OFF
	MOV [INC_DEC_DISPLAY],R3

exit_update_display:
	POP R6
	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; HEX_TO_DEC - changes the number in hexadecimal to decimal
; Argumentos:   R1 - número hexadecimal
;
; **********************************************************************
HEX_TO_DEC: 				; converto numeros hexadecimais (até 63H EXCLUSIVE) para decimal
	PUSH R0 					; converte o numero em R1, e deixa-o em R1
	PUSH R2

	MOV  R0, HEXTODEC
	MOV  R2, R1
	DIV  R1, R0 				; coloca o algarismo das dezenas em decimal em R1
	MOD  R2, R0 				; coloca o algarismo das unidades em decimal em R2
	SHL  R1, 4
	OR   R1, R2					; coloca o numero em decimal em R1
	
	POP  R2
	POP  R0
	RET

; ***********************************************************
; TESTA_LIMITES_DISPLAY - Testa se o valor do display  esta 
;				dentro dos limite estabelecidos (0-64 hexa)
; Argumentos:	R1 - valor do display
;				R2 - valor a aumentar ou diminuir no display
;
; Retorna: 		R2 - 0 se ja tiver chegado ao limite, inalterado caso contrario
;
; **********************************************************
test_display_limits:
	PUSH R2
	PUSH R5	
	ADD R1, R2

test_display_min:
	MOV R5, DISPLAY_MIN					; valor minimo do display
	CMP R1, R5
	JZ end_test_display_limits			; ja nao pode diminuir mais
	; OUT OF GAS

test_display_max:
	MOV R5, DISPLAY_MAX					; valor minimo do display
	CMP R1, R5
	JLE end_test_display_limits			; ja nao pode diminuir mais
	MOV R1, R5

end_test_display_limits:
	POP R5
	POP R2
	RET

; **********************************************************************
; ROVER - Move o Rover caso a tecla para o mesmo tenha sido premida
; Argumentos:   R0 - tecla premida
;  
; **********************************************************************

rover:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R7

get_key:				
	CMP R0, -1				; R0 = -1 se nenhuma tecla foi premida
	JZ exit_rover
	CALL test_rover_limits		;retorna 1(direita),-1(esquerda),0 não existe movimento
	CMP R7,0
	JZ exit_rover

move_rover:
	
	MOV R1, [POS_ROVER_Y]		; guarda a posicao Y do rover
	MOV R2, [POS_ROVER_X]		; guarda a posicao X do rover
	MOV R4, DEF_ROVER			; guarda a definicao do rover
	CALL erase_object		; apaga o rover na sua posicao corrente

coluna_seguinte:
	MOV R2, [POS_ROVER_X]
	ADD R2, R7					; calcula a nova coluna do rover
	MOV	[POS_ROVER_X], R2		; altera a coluna  do rover
	CALL draw_object			; desenha o rover na sua nova posicao
	JMP exit_rover

exit_rover:
	POP R7
	POP R4
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
draw_object:       		; desenha o boneco a partir da tabela
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH 	R7
	PUSH	R8

	MOV	R7, R2				; guarda o valor da coluna 
	MOV	R5, [R4]			; obtem a largura do boneco
	MOV R8, R5				; guarda a largura
	ADD R4, MOVE_NEXT_WORD				; endereço da tabela que define a altura do boneco
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, MOVE_NEXT_WORD				; primeira cor

desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			; obtem a cor do proximo pixel do boneco
	CALL draw_pixel
	ADD	R4, MOVE_NEXT_WORD				; endereco da cor do proximo pixel (2 porque cada cor de pixel e uma word)
    ADD  R2, 1             ; proxima coluna
    SUB  R5, 1				; menos uma coluna para tratar
    JNZ  desenha_pixels    ; continua ate percorrer toda a largura do objeto
	ADD R1, 1				; proxima linha
	MOV R2, R7				; repoe a coluna no principio 
	MOV R5, R8				; repoe a largura  
	SUB R6, 1				; menos uma linha para tratar
	JNZ desenha_pixels		; continua até percorrer todas as linhas
	
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET

; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
;
; **********************************************************************
erase_object:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH 	R6
	PUSH 	R7

	MOV R7, R2				; guarda o valor da coluna
	MOV	R5, [R4]			; obtem a largura do boneco
	ADD R4, MOVE_NEXT_WORD				; passa para altura
	MOV R6, [R4]			; obtem a altura do boneco
	SUB R4, MOVE_PREVIOUS_WORD				; repoe o R4 com o valor da largura

erase_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0				; cor para apagar o próximo pixel do boneco
	CALL	draw_pixel	; escreve cada pixel do boneco
     ADD  R2, 1             ; proxima coluna
     SUB  R5, 1				; menos uma coluna para tratar
     JNZ  erase_pixels      ; continua ate percorrer toda a largura do objeto
	MOV R5, [R4]			; repoe a largura	
	MOV R2, R7				; repoe a coluna
	 ADD R1, 1				; proxima linha
	 SUB R6, 1				; menos uma linha para tratar
	 JNZ erase_pixels

	POP R7
	POP R6
	POP	R5
	POP R4
	POP	R3
	POP	R2
	POP R1
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
draw_pixel:
	MOV  [DEF_LIN], R1		; seleciona a linha
	MOV  [DEF_COL], R2	; seleciona a coluna
	MOV  [DEF_PIXEL], R3		; altera a cor do pixel na linha e coluna ja selecionadas
	RET




; **********************************************************************
; TESTA_LIMITES - Testa se o rover chegou aos limites do ecra e nesse caso
;			   impede o movimento (forca R7 a 0)
; Argumentos:	R2 - coluna em que o objeto está
;				R6 - largura do boneco
;				R7 - sentido de movimento do boneco (valor a somar a coluna
;					em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 		R7 - 0 se ja tiver chegado ao limite, inalterado caso contrario	
;
; **********************************************************************
test_rover_limits:
	PUSH	R2
	PUSH	R5
	PUSH	R6
lado_a_testar:
	CMP	R0, KEY_RIGHT					
	JZ	test_right_limit	; se se for deslocar para a direita
	CMP R0, KEY_LEFT
	JZ	test_left_limit	; se se for deslocar para a esquerda
	MOV R1, 0
	JMP end_test_rover_limits
test_left_limit:			; vê se o rover chegou ao limite esquerdo
	MOV	R5, COL_MIN			; obtem o valor da coluna minima
	MOV R2, [POS_ROVER_X]		; obtem coluna em que o rover esta
	CMP	R2, R5					; compara a posicao do rover com o limite esquerdo
	JZ	no_movement		; ja nao pode mover mais
	MOV R7, -1
	JMP end_test_rover_limits		; entre limites, mantem o valor do R7
test_right_limit:			; ve se o boneco chegou ao limite direito	
	MOV R2, [POS_ROVER_X]		; obtem coluna em que o rover esta
	MOV R6, [DEF_ROVER]			; obtem a largura do rover
	ADD	R6, R2					; posicao do extremo direito do boneco + 1
	SUB R6, 1					; posicao do extremo direito do boneco
	MOV	R5, COL_MAX			; obtem o valor da coluna maxima
	CMP	R6, R5
	JZ no_movement			; ja nao pode mover mais
	MOV R7, 1
	JMP	end_test_rover_limits		; entre limites, mantem o valor do R7
no_movement:
	MOV	R7, 0					; impede o movimento, forçando R7 a 0
end_test_rover_limits:	
	POP	R6
	POP	R5
	POP R2
	RET


; **********************************************************************
; TECLADO - Faz uma leitura as teclas de todas linha do teclado e retorna o valor lido
;
; Retorna: 	R0 - valor lido das colunas do teclado
;           R0 = -1 no caso de nenhuma tecla ter sido lida
;
; *************************************************************************
keyboard:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH 	R9

    MOV  R2, KEY_LIN   	; endereco do periferico das linhas
    MOV  R3, KEY_COL   	; endereco do periferico das colunas
    MOV  R5, MASK   	; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ciclo:
    MOV R0, 1          	; inicializa o R0 a um 
    MOV R1, 0          	; inicializa o R1 a zero 
    MOV R6, R1         	; escreve coluna a zero
    MOV R7, R1         	; escreve calculo posicao linha a zero
    MOV R8, R1         	; escreve caluclo posicao coluna a zero
	MOV R9, 8
wait_key:          	; neste ciclo espera-se ate uma tecla ser premida
    MOVB [R2],R0       	; ler pertiferico de saida (linhas)
    MOVB R1, [R3]      	; ler do periferico de entrada (colunas)
    AND  R1, R5        	; elimina bits para alem dos bits 0-3
    CMP  R1, 0         	; ha tecla premida?
    MOV R6,R0          	; para poder verificar se a tecla ainda está pressionada
    JNZ  calculate_col   	; tecla premida começa a calcular qual foi premida
    CMP R0,R9          	; verifica se ja chegou ao valor 8
    JZ no_key
    SHL R0,1           	; passa para a proxima linha
    JMP wait_key   	; se nenhuma tecla premida repete
calculate_col:
    SHR R1,1           	; realiza um shift right
    CMP R1,0           	; verifica se ainda nao está na coluna certa
    JZ calculate_line    	; se ja estiver na coluna certa vai calcular as linhas
    INC R8             	; se ainda nao estiver a coluna certa incrmenta o contador
    JMP calculate_col    	; enquanto nao estiver na coluna certa continua a correr
calculate_line:
    SHR R0,1           	; realiza um shift right
    CMP R0,0           	; verifica se ainda nao esta na coluna certa
    JZ key           	; se ja estiver na coluna certa vai calcular a tecla premida
    INC R7             	; se ainda nao estiver na linha certa incrmenta o contador das linhas
    JMP calculate_line   	; enquanto nao estiver na linha certa continua a correr
key:
    SHL R7,2           	; vai multiplicar o numero da linha por 4
    ADD R8,R7          	; vai adicionar a coluna o numero de linhas
    AND R8,R5          	; elimina bits para alem dos bits 0-3
    MOV R0,R8          	; saber que tecla foi pressionada
	MOV [PRESSED_KEY],R8
	JMP end_keyboard
no_key:
	MOV R0, -1			; nenhuma tecla premida
	MOV [PRESSED_KEY], R0
	JMP end_keyboard

end_keyboard:	
	POP R9
	POP	R8
	POP	R7
	POP	R6
	POP	R5
	POP	R3
	POP	R2
	POP	R1
	RET	


; **********************************************************************
;		Rotinas Auxiliares
; **********************************************************************

; **************************
;
; **************************


; **************************
;
; **************************

reset_objects:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	MOV R3, -2
	MOV R4, 22
reset_objects_cycle:	
	MOV R2, coord_0
	ADD R3, 2
	ADD R2, R3
	MOV R1, 0
	MOV [R2], R1
	CMP R3, R4
	JNZ reset_objects_cycle
end_reset_objects:
	POP R4
	POP R3
	POP R2
	POP R1
	RET
; **************************
;
; **************************

init_rover:
	PUSH R1
	PUSH R2
	PUSH R4
    MOV  R1, LINE_ROVER			; linha do boneco
    MOV  R2, COL_ROVER			; coluna do boneco
	MOV  [POS_ROVER_X], R2			; poe a coluna do rover na memoria
	MOV  [POS_ROVER_Y], R1			; poe a linha do rover na memoria
	MOV  R4, DEF_ROVER				; define o rover
	CALL draw_object
	POP R4
	POP R2
	POP R1
	RET
; **************************
;
; **************************
init_game_various:
	PUSH R1
	MOV R1, 0
	MOV [INC_DEC_DISPLAY], R1
	MOV [INTERRUPTION_ENERGIA], R1
	MOV [INTERRUPTION_METEOR], R1
	MOV [INTERUPTION_MISSILE], R1
	MOV [MISSILE_NUMBER], R1
	MOV [PRESSED_KEY], R1
	MOV [STOP], R1
	MOV R1, STANDARD_BACKGROUND
	MOV  [BACKGROUND_SELECT], R1		; seleciona o cenario de fundo
	POP R1
	RET
; *****************
;
;*****************

wait_key_play:
	PUSH R1
	PUSH R2
wait_play:			; seleciona o cenario de fundo
	CALL keyboard
	MOV R2, [PRESSED_KEY]
	MOV R1, KEY_START
	CMP R2, R1
	JNZ wait_play

wait_play_2:
	CALL keyboard
	MOV R2, [PRESSED_KEY]
	MOV R1, KEY_START
	CMP R2, R1
	JNZ end_wait_key_play
	JMP wait_play_2

end_wait_key_play:
	POP R2
	POP R1
	RET


; **************************
;
; **************************

test_pause:
	PUSH R1
	PUSH R2

	MOV R1, [PRESSED_KEY]
	MOV R2, KEY_START
	CMP R2, R1
	JNZ end_test_pause

	CALL wait_release_pause
	MOV R1, PAUSE_MENU
	MOV [BACKGROUND_SELECT], R1
game_paused:
	CALL keyboard
	MOV R1, [PRESSED_KEY]
	MOV R2, KEY_START
	CMP R2, R1

	JNZ game_paused
	CALL wait_release_pause
	MOV R1, STANDARD_BACKGROUND
	MOV [BACKGROUND_SELECT], R1
end_test_pause:
	
	POP R2
	POP R1
	RET



; ********************************
;
; ********************************
wait_release_pause:
	PUSH R1
	PUSH R2
wait_release_pause_cycle:
	CALL keyboard
	MOV R1, [PRESSED_KEY]
	MOV R2, KEY_START
	CMP R2, R1
	JZ wait_release_pause_cycle
end_wait_release_pause:
	POP R2
	POP R1
	RET


; *************************
;
; **************************

lose_contact:
	PUSH R1
	PUSH R2
	PUSH R4
	MOV R1, 0
	MOV R2, 0
	MOV R4, DEF_SCREEN
	CALL erase_object
	MOV R1, LOSE_CONTACT_METEOR
	MOV [BACKGROUND_SELECT], R1
	POP R4
	POP R2
	POP R1
	RET


; *************************
;
; **************************
init_display:
	PUSH R1
	MOV R1, DISPLAY_INIT		
	MOV [DISPLAY], R1						; reinicia o display
	MOV R1, DISPLAY_MAX
	MOV [DISPLAY_VAL], R1					; reinicia o valor do display
	POP R1
	RET

; **********************************************************************
;		Rotinas de Interrupcao
; **********************************************************************

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;			Faz com que os meteoros se movam uma casa para baixo 
;			periodicamente
; **********************************************************************
rot_int_0:
	PUSH R1 
	MOV R1, ON
	MOV [INTERRUPTION_METEOR], R1
	POP R1
	RFE					; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_1 -	Rotina de atendimento da interrup��o 1
;			Faz com que o missil se mova uma casa para cima periodicamente
; **********************************************************************
rot_int_1:
	PUSH R1 
	MOV R1, ON
	MOV [INTERUPTION_MISSILE], R1
	POP R1
	RFE					; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_2 -	Rotina de atendimento da interrupcao 2
;			Records in the memory the value 1 and the value of how much
;			the display will decrease (5%)
; **********************************************************************
rot_int_2:
	PUSH R1
	MOV R1, DISPLAY_TIME
	MOV [INC_DEC_DISPLAY],R1
	POP R1
	RFE					; Return From Exception (diferente do RET)


