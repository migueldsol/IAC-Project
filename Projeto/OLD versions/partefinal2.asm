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

TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
DISPLAY				EQU 0A000H 	; endereço do display
DISPLAY_TIME	EQU 0FFFBH	; value that the interruption will make the display increase
DISPLAY_COIN	EQU 000AH	; value that increases display in colision with coin
DISPLAY_METEOR EQU 0005H   ; value that increases display of missile colision with coin		
DISPLAY_MISSIL EQU 0FFFBH	; value that decreases display by the fire of a missil


DEFINE_LINHA    		EQU 600AH      	; endereco do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      	; endereco do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      	; endereco do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      	; endereco do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 			EQU 6002H      	; endereco do comando para apagar todos os pixels ja desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H      	; endereco do comando para selecionar uma imagem de fundo
MUDAR_ECRA				EQU 6004H		; mudar ecra principal
TOCA_SOM				EQU 605AH      	; endereco do comando para tocar um som

; ********************************************************************************
; Constantes
; ********************************************************************************
MASCARA_DISPLAY		EQU 0FFFH	; isolar os 12 bits de menor peso, ao ler o valor do display
ON					EQU 0001H	; activate the update_display routine
OFF					EQU 0000H	; activate the update_display routine

TECLA_ESQUERDA		EQU 4		; tecla para movimentar para a esquerda (tecla 4)
TECLA_DIREITA		EQU 6		; tecla para movimentar para a direita (tecla 6)
TECLA_MISSIL		EQU 1		; tecla para disparar umm missil (tecla 1)
TECLA_START			EQU 8		; tecla para iniciar/continuar o jogo (tecla 8)
TECLA_PAUSE			EQU 9		; tecla para parar o jogo

LINHA_ROVER      	EQU  28     ; linha do boneco (posicao mais baixa)
COLUNA_ROVER		EQU  30     ; coluna do boneco (a meio do ecra)
LINHA_METEORO    	EQU  2      ; linha do meteoro 
COLUNA_METEORO		EQU  30     ; coluna do meteoro (a meio do ecra) 

MIN_COLUNA			EQU  0		; numero da coluna mais a esquerda
MAX_COLUNA			EQU  63   	; numero da coluna mais a direita 
MIN_LINHA			EQU	 0		; numero da linha mais em cima 
MAX_LINHA			EQU	 0F80H	; numero da linha mais em baixo
MAX_linha_objeto 	EQU 32		; numero maximo que o meteoro pode atingir de forma a nao afetar o rover
DISPLAY_MAX			EQU 64H 	; numero maximo que o display deve mostrar (100 dec)
DISPLAY_MAX_INIT	EQU 0100H	; valor inicial do display
DISPLAY_MIN			EQU 0H  	; numero minimo que o display deve mostrar
DECREMENTACAO_DISPLAY	EQU 5	; valor que vai ser subtraido periodicamente
INCREMENTACAO_DISPLAY	EQU 0AH ; valor que aumenta no display caso atinja uma moeda
HEXTODEC 			EQU 0AH

ATRASO			EQU	1200H		; atraso para limitar a velocidade de movimento do boneco

LARGURA_ROVER		EQU	5		; largura do ROVER
ALTURA_ROVER		EQU 4		; altura do ROVER

LARGURA_FRAGMENTO1	EQU 1		; largura do fragmento 1
ALTURA_FRAGMENTO1	EQU 1		; altura do fragmento 1
LARGURA_FRAGMENTO2	EQU 2		; largura do fragmento 2
ALTURA_FRAGMENTO2	EQU 2		; altura do fragmento 2

LARGURA_METEORO1	EQU 3		; largura do meteoro nivel 1
ALTURA_METEORO1		EQU 3		; altura do meteoro nivel 1
LARGURA_METEORO2	EQU 4		; largura do meteoro nivel 2
ALTURA_METEORO2		EQU 4		; altura do meteoro nivel 2
LARGURA_METEORO3	EQU	5		; largura do meteoro nivel 3
ALTURA_METEORO3		EQU 5		; altura do meteoro nivel 3

LARGURA_MOEDA1		EQU 3		; largura do moeda nivel 1
ALTURA_MOEDA1		EQU 3		; altura do moeda nivel 1
LARGURA_MOEDA2		EQU 4		; largura do moeda nivel 2
ALTURA_MOEDA2		EQU 4		; altura do moeda nivel 2
LARGURA_MOEDA3		EQU	5		; largura do moeda nivel 3
ALTURA_MOEDA3		EQU 5		; altura do moeda nivel 3

LARGURA_EXPLOSAO	EQU 5		; largura da explosao
ALTURA_EXPLOSAO		EQU 5		; altura da explosao

LARGURA_MISSIL		EQU 1		; largura do missil
ALTURA_MISSIL		EQU 1		; altura do missil
MAX_LINHA_MISSIL	EQU 19		; máximo altura missil

TIPO_EXPLOSAO		EQU 3
TIPO_MOEDA			EQU 2		; define os tipos para comparações
TIPO_METEORO		EQU 1
TIPO_INDEFINIDO		EQU 0

COLISION_TRUE		EQU 1
COLISION_FALSE		EQU 0

MOVE_NEXT_WORD		EQU 2		;passa para a próxima word da tabela
MOVE_NEXT_TWO_WORDS	EQU 4		;passa duas palavras para a frente

START_MENU			EQU 0		
STANDARD_BACKGROUND EQU 1
LOSE_CONTACT_METEOR	EQU 2
TOUCH_COIN			EQU 3

SOM_DISPARO			EQU 0
SOM_TOCAR_MOEDA		EQU 1
SOM_ACERTAR_MOEDA	EQU 2
SOM_ACERTAR_METEORO	EQU 3

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

POS_ROVER_X:	WORD	0000H; endereco de memoria da coluna do rover
POS_ROVER_Y:	WORD	0000H; endereco de memoria da linha do rover
POS_MISSIL_X:	WORD	0000H;
POS_MISSIL_Y:	WORD	0000H;
DISPLAY_VAL:	WORD	0000H; endereco de memoria do valor do display
INC_DEC_DISPLAY: WORD	0000H; endereço de memória de valor a acrescentar ao display
INTERRUPCAO_METEORO: WORD 0000H; endereço de memória do valor de ativação do movimento do meteoro
INTERRUPCAO_MISSIL:  WORD 0000H; endereço de memória do valor de ativação do movimento do missíl
INTERRUPCAO_ENERGIA: WORD 0000H; endereço de memória do valor de ativação da redução da energia
MISSIL_NUMBER:	WORD 0000H; adress of the number of missils in screen
PRESSED_KEY:	WORD 0000H; Pressed key
RANDOM_NUMBER:  WORD 0000H	;random number
STOP:			WORD 0000H
PLACE 2000H

pilha:
	STACK 100H			; espaco reservado para a pilha 
						; (200H bytes, pois sao 100H words)
SP_inicial:				; este e o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
							
DEF_ROVER:				; tabela que define o rover (cor, largura, altura, pixels)
	WORD		LARGURA_ROVER
	WORD		ALTURA_ROVER
	WORD		0, 	0, 	BLUE, 0, 0
	WORD		0, GRAY, BLUE, GRAY, 0		
	WORD		GRAY, GRAY, GRAY, GRAY, GRAY
    WORD		0, 0, RED, 0, 0

DEF_FRAGMENTO_1:			; tabela que define o fragmento 1 (cor, largura, altura, pixels)
	WORD		LARGURA_FRAGMENTO1
	WORD		ALTURA_FRAGMENTO1
	WORD		GRAY

DEF_FRAGMENTO_2:			; tabela que define o fragmento 2 (cor, largura, altura, pixels)
	WORD		LARGURA_FRAGMENTO2
	WORD		ALTURA_FRAGMENTO2
	WORD		GRAY, GRAY
	WORD		GRAY, GRAY

DEF_METEORO_1:			; tabela que define o meteoro nivel 1 (cor, largura, altura, pixels)
	WORD		LARGURA_METEORO1
	WORD		ALTURA_METEORO1
	WORD		YELLOW, 0, YELLOW
	WORD		RED, BROWN, RED
	WORD		0, BROWN, 0

DEF_METEORO_2:			; tabela que define o meteoro nivel 2 (cor, largura, altura, pixels)
	WORD		LARGURA_METEORO2
	WORD		ALTURA_METEORO2
	WORD		YELLOW, 0, 0, YELLOW
	WORD		YELLOW, RED, RED, YELLOW
	WORD		RED, BROWN, BROWN, RED
	WORD		0, BROWN, BROWN, 0

DEF_METEORO_3:			; tabela que define o meteoro nivel 3 (cor, largura, altura, pixels)
	WORD		LARGURA_METEORO3
	WORD		ALTURA_METEORO3
	WORD		YELLOW , 0 , YELLOW , 0 , YELLOW
	WORD		0 , YELLOW , RED , YELLOW , 0
	WORD		YELLOW , RED , BROWN , RED , YELLOW
    WORD		RED , BROWN , BROWN , BROWN , RED
	WORD		0 , RED , BROWN , RED , 0

DEF_MOEDA_1:			; tabela que define a moeda nivel 1 (cor, largura, altura, pixels)
	WORD		LARGURA_MOEDA1
	WORD		ALTURA_MOEDA1
	WORD		0, YELLOW, 0
	WORD		YELLOW, MUSTARD, YELLOW
	WORD		0, YELLOW, 0	

DEF_MOEDA_2:			; tabela que define a moeda nivel 2 (cor, largura, altura, pixels)
	WORD		LARGURA_MOEDA2
	WORD		ALTURA_MOEDA2
	WORD		0, YELLOW, YELLOW, 0
	WORD		YELLOW, WHITE, MUSTARD, YELLOW
	WORD		YELLOW, MUSTARD, YELLOW, YELLOW
	WORD		0, YELLOW, YELLOW, 0

DEF_MOEDA_3:			; tabela que define a moeda nivel 3 (cor, largura, altura, pixels)
	WORD		LARGURA_MOEDA3
	WORD		ALTURA_MOEDA3
	WORD		0, YELLOW, YELLOW, YELLOW, 0
	WORD		YELLOW, WHITE, MUSTARD, MUSTARD, YELLOW
	WORD		YELLOW, MUSTARD, YELLOW, YELLOW, YELLOW
	WORD		YELLOW, MUSTARD, YELLOW, YELLOW, YELLOW
	WORD		0, YELLOW, YELLOW, YELLOW, 0

DEF_EXPLOSAO:			; tabela que define a explosao (cor, largura, altura, pixels)
	WORD		LARGURA_EXPLOSAO
	WORD		ALTURA_EXPLOSAO
	WORD		0, YELLOW, 0, YELLOW, 0
	WORD		YELLOW, ORANGE, RED, ORANGE, YELLOW
	WORD		0, RED, BLUE, RED, 0
	WORD		YELLOW, ORANGE, RED, ORANGE, YELLOW
	WORD		0, YELLOW, 0, YELLOW, 0

DEF_MISSIL:				; tabela que define o missil (cor, largura, altura, pixels)
	WORD		LARGURA_MISSIL
	WORD		ALTURA_MISSIL
	WORD		DRKBLUE
DEF_ECRA:
	WORD		64
	WORD 		32
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2

cord_0:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro
	WORD 4
cord_1:
	WORD 0					;posicao Y
	WORD 0				;posicao X
	WORD 0					;tipo de meteoro
	WORD 5
cord_2:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro
	WORD 6
cord_3:
	WORD 0					;posicao Y
	WORD 0					;posicao X
	WORD 0					;tipo de meteoro
	WORD 7

coord_objetos:
	WORD cord_0				; objeto 0 
	WORD cord_1				; objeto 1 
	WORD cord_2				; objeto 2 
	WORD cord_3				; objeto 3 

; *********************************************************************************
; Codigo
; *********************************************************************************

PLACE   0H                   ; o codigo tem de comecar em 0000H
inicio:
	MOV  SP, SP_inicial						; inicializa SP para a palavra a seguir a ultima da pilha 
	MOV  BTE, tab							; inicializa BTE (registo de Base da Tabela de Exce��es)
    MOV  [APAGA_AVISO], R1					; apaga o aviso de nenhum cenario selecionado (o valor de R1 nao e relevante)
    MOV  [APAGA_ECRA], R1					; apaga todos os pixels ja desenhados (o valor de R1 nao e relevante)
	EI0										; permite interrupções 0
	EI1										; permite interrupções 1
	EI2										; permite interrupções 2
	EI										; permite interrupções (geral)


start_menu:
	MOV	R1, START_MENU								; cenario de fundo numero 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	
wait_play:			; seleciona o cenario de fundo
	CALL Teclado
	MOV R2, [PRESSED_KEY]
	MOV R1, TECLA_START
	CMP R2, R1
	JNZ wait_play
wait_play_2:
	CALL Teclado
	MOV R2, [PRESSED_KEY]
	MOV R1, TECLA_START
	CMP R2, R1
	JNZ restart
	JMP wait_play_2

lost:
	MOV R1, 0
	MOV R2, 0
	MOV R4, DEF_ECRA
	CALL apaga_boneco
	MOV R1, LOSE_CONTACT_METEOR
	MOV [SELECIONA_CENARIO_FUNDO], R1
	JMP wait_play


restart:
	CALL init_display	;dá reset ao display
	
	MOV R1, STANDARD_BACKGROUND
	MOV  [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenario de fundo

	MOV R3, -2
	MOV R4, 22
reset_objects:
	MOV R2, cord_0
	ADD R3, 2
	ADD R2, R3
	MOV R1, 0
	MOV [R2], R1
	CMP R3, R4
	JNZ reset_objects

rest:
	MOV R1, 0
	MOV [INC_DEC_DISPLAY], R1
	MOV [INTERRUPCAO_ENERGIA], R1
	MOV [INTERRUPCAO_METEORO], R1
	MOV [INTERRUPCAO_MISSIL], R1
	MOV [MISSIL_NUMBER], R1
	MOV [PRESSED_KEY], R1
	MOV [STOP], R1

init_ROVER:
     MOV  R1, LINHA_ROVER			; linha do boneco
     MOV  R2, COLUNA_ROVER			; coluna do boneco
	 MOV  [POS_ROVER_X], R2			; poe a coluna do rover na memoria
	 MOV  [POS_ROVER_Y], R1			; poe a linha do rover na memoria
	 MOV  R4, DEF_ROVER				; define o rover
	 MOV R9, STANDARD_BACKGROUND	; ecrã onde vai ser escrito
	 CALL desenha_boneco
 

main:
	
	CALL Teclado			; leitura às tecla
	CALL test_pause
	CALL Rover				; Move Rover caso tecla tenha sido premida
	CALL Missil
	CALL meteoro
	CALL colision_objeto_init
	CALL colision_missile_init
	CALL UPDATE_DISPLAY
	MOV R1, 1		;solução para passar isto para rotina
	MOV R2, [STOP]
	CMP R2, R1
	JZ lost
	JMP main
	;CALL stop
	

; **********************************************************************
; Missile_colision - Verifies if the missile colides with the meteor or 
;					the coin
; **********************************************************************
stop:
	MOV R1, 1
	MOV R2, [STOP]
	CMP R2, R1
	JZ lost
	JMP main

; **********************************************************************
; Missile_colision - Verifies if the missile colides with the meteor or 
;					the coin
; **********************************************************************
test_pause:
	PUSH R1
	PUSH R2

	MOV R1, [PRESSED_KEY]
	MOV R2, TECLA_PAUSE
	CMP R2, R1
	JNZ end_test_pause
wait_pause:
	CALL Teclado
	MOV R1, [PRESSED_KEY]
	MOV R2, TECLA_PAUSE
	CMP R2, R1
	JZ wait_pause
game_paused:
	CALL Teclado
	MOV R1, [PRESSED_KEY]
	MOV R2, TECLA_PAUSE
	CMP R2, R1
	JNZ game_paused
wait_pause_2:
	CALL Teclado
	MOV R1, [PRESSED_KEY]
	MOV R2, TECLA_PAUSE
	CMP R2, R1
	JNZ end_test_pause
	JMP wait_pause_2
end_test_pause:
	POP R2
	POP R1
	RET


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
	MOV R9, COLISION_FALSE
	
	MOV R0, [MISSIL_NUMBER]
	CMP R0, 0
	JZ 	exit_missile_routine 	; se nao houver missil nao e necessario verificar a colisao

	MOV R3 , 0					; counter iteracao iniciado a 0
	
colision_missile_main:	
	MOV R7, R3					
	SHL R7, 1		
	MOV R0, coord_objetos		;endereço da tabela das coordenadas
	ADD R0, R7					; R0 enderco da tabela coord
	MOV R1,[R0]					; R1 = enderco da pos Y
	MOV R6, [R1]				; R6 = pos Y do objeto
	MOV R4,	15				; altura a que os objetos ficam no seu tamanho maximo
	CMP R6,R4						
	JLT next_objeto			;se a colisao nao for possivel entao salta para o proximo objeto

	ADD R1, MOVE_NEXT_TWO_WORDS	
	MOV R2, [R1]					; R2 passa a ser o tipo de objeto
	CMP R2, TIPO_METEORO			; se for um meteoro
	JZ colisao_missil_meteoro
	CMP R2, TIPO_MOEDA				; se for uma moeda
	JZ colision_missile_coin
	JMP next_objeto					; se for uma explosao
colisao_missil_meteoro:
	SUB R1, 4					; R1 de volta a pos Y
	MOV R0, R1
	MOV R4, DEF_METEORO_3		; colisoes so podem acontecer com objetos grandes
	CALL colision_missile		; R0 = tabela do objeto, R4 = def do objeto
	CMP R8 , 1
	JZ handle_colision_missile_meteor ;se houve colisao

colision_missile_coin:
	SUB R1, 4				; R1 de volta a pos Y
	MOV R0, R1
	MOV R4, DEF_MOEDA_3		; colisoes so podem acontecer com objetos grandes
	CALL colision_missile	; R0 = tabela do objeto, R4 = def do objeto
	CMP R8 , 1
	JZ handle_colision_missile_coin	; se houve colisao

next_objeto:
	ADD R3, 1
	CMP R3 ,4
	JZ exit_missile_routine		;quando já tiver passado pelos quatro meteoros
	JMP colision_missile_main

handle_colision_missile_meteor:
	;quando a colisão acontecer fazer alguma coisa
	MOV R1, DISPLAY_METEOR
	MOV [INC_DEC_DISPLAY], R1
	MOV R1, [POS_MISSIL_Y]
	MOV R2, [POS_MISSIL_X]
	MOV R4, DEF_MISSIL
	MOV R9, STANDARD_BACKGROUND
	CALL apaga_boneco		;apaga o missil
	MOV R1, [R0]			; R1 = POS Y
	ADD R0, 2
	MOV R2, [R0]			; R2 = POS X
	MOV R4, DEF_METEORO_3	; R4 = DEF
	ADD R0, MOVE_NEXT_TWO_WORDS
	MOV R9, [R0]
	SUB R0, MOVE_NEXT_TWO_WORDS
	CALL apaga_boneco		; apaga o boneco
	MOV R4, DEF_EXPLOSAO	; R4 = DEF
	CALL desenha_boneco		; desenha a explosao
	MOV R1, SOM_ACERTAR_METEORO	
	MOV [TOCA_SOM], R1	; faz o som
	ADD R0, 2			
	MOV R4, TIPO_EXPLOSAO	
	MOV [R0], R4			; muda o tipo do objeto para explosao
	MOV R9, COLISION_TRUE	; houve colisao
	
	JMP next_objeto


handle_colision_missile_coin:
	;quando a colisão acontecer fazer alguma coisa
	MOV R1, [POS_MISSIL_Y]
	MOV R2, [POS_MISSIL_X]
	MOV R4, DEF_MISSIL
	MOV R9, STANDARD_BACKGROUND
	CALL apaga_boneco		;apaga o missil
	MOV R1, [R0]			; R1 = POS Y
	ADD R0, 2
	MOV R2, [R0]			; R2= POS X
	MOV R4, DEF_METEORO_3	; R4 = DEF
	ADD R0, MOVE_NEXT_TWO_WORDS
	MOV R9, [R0]
	SUB R0, MOVE_NEXT_TWO_WORDS
	CALL apaga_boneco		; apaga o boneco
	MOV R4, DEF_EXPLOSAO	; R4 = DEF
	CALL desenha_boneco		; desenha a explosao
	MOV R1, SOM_ACERTAR_MOEDA
	MOV [TOCA_SOM], R1		; faz o som
	ADD R0, 2
	MOV R4, TIPO_EXPLOSAO
	MOV [R0], R4			; muda o tipo do objeto para explosao
	MOV R9, COLISION_TRUE	; houve colisao
	
	JMP next_objeto

exit_missile_routine:
	CMP R9, COLISION_TRUE
	JZ exit_missile_routine_with_colision	; houve colisao
	JMP missile_routine_pops
exit_missile_routine_with_colision:
	MOV R1, 0
	MOV [MISSIL_NUMBER], R1	; missil desaparece
	JMP missile_routine_pops

missile_routine_pops:
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


; *************************************************
;
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
	PUSH R9

	; R0 = tabela do objeto
	; R4 = Def do objeto

	MOV  R8, 0

	MOV R2, [R0] 				; coordenada Y do meteoro
	ADD  R0, MOVE_NEXT_WORD
	MOV R1, [R0] 				; coordenada X do meteoro

	MOV R5, [R4] 				; largura do meteoro
	ADD  R5,R1 					
	SUB R5, 1					; coordenada x mais a direita do meteoro
	ADD  R4, MOVE_NEXT_WORD
	MOV R6, [R4] 				; altura do meteoro
	ADD  R6,R2 				
	SUB R6, 1				; coordenada y mais a baixo do meteoro
	MOV R4, [POS_MISSIL_X] 				; coordenada x do missil
	MOV R7, [POS_MISSIL_Y] 				; coordenada y do missil

	CMP  R4, R1
	JLT  exit_missile_colision

	CMP  R4, R5
	JGT  exit_missile_colision

	CMP  R7, R2
	JLT  exit_missile_colision

	CMP  R7, R6 	
	JGT  exit_missile_colision 	; testam se o missil esta fora da "caixa" em que o meteoro se insere

	ADD R0, MOVE_NEXT_TWO_WORDS
	MOV R9, [R0]
	MOV  R8, 1



exit_missile_colision:
	POP R9
	POP	R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET




;************************************************************************

colision_objeto_init:
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
	MOV R3, cord_0 		; tabela do objeto 0
	MOV R1, 15			; linha em que os objetos ficam grandes
	CMP R3, R1			; nao vale a pena comparar se o objeto nao estiver ainda grande
	JLT cycle			
	ADD R3, R9			; passa para a tabela do objeto correto
	ADD R3, 4			; chegar ao tipo de objeto
	MOV R6, [R3]		; R6 = tipo objeto
	CMP R6, TIPO_METEORO	
	JZ colision_meteoro	; se for meteoro
	CMP R6, TIPO_MOEDA
	JZ colision_moeda	; se for moeda
	JMP cycle

colision_meteoro:
	SUB R3, 4		; volta a posicao Y
	MOV R1, [R3]	; R1 = pos Y do meteoro
	MOV R6, DEF_METEORO_3	; vai buscar o meteoro
	ADD R6, 2				; vai buscar a altura do meteoro
	MOV R5, [R6]			; R5 = altura do meteoro
	ADD R1, R5				; R1 passa a ser a linha de baixo do meteoro
	MOV R4, [POS_ROVER_Y]	; R4 = linha de cima do rover
	CMP R1, R4
	JGE test_X_meteoro		; se for possivel haver colisao
	JMP cycle
test_X_meteoro:
	MOV R4, [POS_ROVER_X]
	ADD R3, 2 				; endereco da coordenada X do meteoro
	MOV R7, [R3] 			; posicao X do meteoro
	MOV R6, [DEF_METEORO_3] ; largura do meteoro
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
	
	JMP handle_colision_meteoro

colision_moeda:
	SUB R3, 4		; volta a posicao Y
	MOV R1, [R3]	; R1 = pos Y da moeda
	MOV R6, DEF_MOEDA_3	; vai buscar a moeda
	ADD R6, 2				; vai buscar a altura da moeda
	MOV R5, [R6]			; R5 = altura da moeda
	ADD R1, R5		; R1 passa a ser a linha de baixo da moeda
	MOV R4, [POS_ROVER_Y]	; R4 = linha de cima do rover
	CMP R1, R4
	JGE test_X_moeda		; se for possivel haver colisao
	JMP cycle

test_X_moeda:
	MOV R4, [POS_ROVER_X]
	ADD R3, 2 	 ; enderco da coordenada X da moeda
	MOV R7, [R3] ; posicao X da moeda
	MOV R6, [DEF_MOEDA_3] ; largura da moeda
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
	JMP handle_colision_moeda


handle_colision_meteoro:
	MOV R1, 1
	MOV [STOP], R1
	JMP sai_colision


handle_colision_moeda:   ; alterar ------------------ nao e o que deve acontecer nesta colisao
	MOV R1, DISPLAY_COIN
	MOV [INC_DEC_DISPLAY], R1
	SUB R3, 2
	MOV R1, [R3]
	ADD R3, 2
	MOV R2, [R3]
	MOV R4, DEF_MOEDA_3
	CALL apaga_boneco
	ADD R3, 2
	MOV R1, TIPO_INDEFINIDO
	MOV [R3], R1
	MOV R1, SOM_TOCAR_MOEDA
	MOV [TOCA_SOM], R1	
	JMP cycle

cycle:
	MOV R8, 18
	CMP R9, R8	; se ja tiver feito o ultimo objeto
	JZ sai_colision
	ADD R9, 6	; para passar para a table de posicoes correta
	JMP colision_main

sai_colision:
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

meteoro:
	PUSH R1
	PUSH R3
	MOV R1, [INTERRUPCAO_METEORO]
	CMP R1, OFF
	JZ sai_meteoro
	MOV R3, 0				; numero do meteoro
	CALL anima_meteoro

	MOV R3, 1
	CALL anima_meteoro	
	
	MOV R3, 2
	CALL anima_meteoro
	
	MOV R3, 3
	CALL anima_meteoro

	MOV R1, OFF
	MOV [INTERRUPCAO_METEORO], R1
sai_meteoro:
	POP R3
	POP R1
	RET





random_number_0_8:	; obtem um numero random entre 0 e 8
	PUSH R0
	PUSH R1
	MOV R1,TEC_COL
	MOVB R0, [R1]
	SHR R0, 5
	MOV [RANDOM_NUMBER], R0
	POP R1
	POP R0
	RET

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

random_tipo:		; obtem um tipo random sendo moeda quando o valor e 48 ou 56, e meteoro no resto
	PUSH R0
	PUSH R1
	PUSH R2
	CALL random_number_0_8
	MOV R1, [RANDOM_NUMBER]
	MOV R0, 8
	MUL R1, R0
	MOV R2, 48
	CMP R1, R2
	JGE random_tipo_moeda
	MOV R1, TIPO_METEORO
	MOV [RANDOM_NUMBER], R1
	JMP random_tipo_end
random_tipo_moeda:
	MOV R1, TIPO_MOEDA
	MOV [RANDOM_NUMBER],R1
	JMP random_tipo_end
random_tipo_end:
	MOV [RANDOM_NUMBER], R1
	POP R2
	POP R1
	POP R0
	RET
; **********************************************************************
; ANIMA_METEORO - Rotina cooperativa que desenha e faz descer o objeto
;			 numa dada coluna. Se chegar ao fundo, passa ao topo.
;			As coordenadas dos objetos sao guardadas numa tabela de 
;			tabelas (coord_objetos), em que cada word possui uma tabela
;			com as cordenadas de cada objeto e o seu tipo.
; Argumentos: R3 - Numero do meteoro (0 a 3)
; **********************************************************************


 anima_meteoro:

	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9

	MOV  R6, R3				; copia de R3 (para nao destruir R3)
	SHL  R6, 1				; multiplica o numero do meteoro por 2 (porque a coord_objetos e uma tabela de words)
	MOV R8, coord_objetos
	MOV  R5, [R8+R6]		; R5 = enderco da pos Y
	MOV  R1, [R5]			; R1 = pos Y do objeto
	
	ADD	 R5, MOVE_NEXT_WORD ; R5 = endereco da pos X 
	MOV  R2, [R5]			; R2 = pos X do objeto

	ADD R5, MOVE_NEXT_WORD
	MOV R3, [R5]			; R3 = tipo do objeto

	ADD R5, MOVE_NEXT_WORD
	MOV R9, [R5]
	SUB R5, MOVE_NEXT_WORD

	CMP R3, TIPO_INDEFINIDO	
	JZ object_init			; se o objeto ainda nao tiver tipo entao deve ser criado

	CMP R3, TIPO_EXPLOSAO	
	JZ explosao				; se o objeto for uma explosao

	ADD  R1, 1				; passa a linha abaixo
	MOV  R4, MAX_linha_objeto
	CMP  R1, R4				; ja estava na linha do fundo?
	JLT  move

	SUB R1, 1
	MOV R4, DEF_MOEDA_3		; o DEF_MOEDA_3 pode ser qualquer um dos tipos finais
	CALL apaga_boneco		; apaga o objecto que chegou ao limite
	MOV R6, TIPO_INDEFINIDO
	JMP object_init			; reinicia o objeto

object_init:
	SUB R5, 4
	MOV R1, 0FFFFH			; 
	MOV [R5], R1			; poe na linha -1 para uma animacao mais fluida
	CALL random_column		; obtem uma coluna em que desenhar o objeto
	MOV R2, [RANDOM_NUMBER]	
	ADD R5, 2
	MOV [R5], R2			; poe o valor da coluna  no objeto
	CALL random_tipo		; obtem um tipo para o objeto
	MOV R4, [RANDOM_NUMBER]
	ADD R5, 2
	MOV [R5], R4			; poe o tipo do objeto no objeto
	JMP sai_anima_meteoro	; desenha o objeto no ciclo seguinte para um animacao mais fluida

explosao:					; a explosao deve durar um ciclo e permitir a criacao de um objeto novo
	MOV R4, DEF_EXPLOSAO
	CALL apaga_boneco			; apaga a explosao
	MOV R3, TIPO_INDEFINIDO		
	MOV [R5], R3				; passa o tipo do objeto para indefinido para ser criado um novo no proximo ciclo
	JMP sai_anima_meteoro

move:	
	SUB R5, 4			; R5 volta a ser o endereco da pos Y
	MOV  [R5], R1		; atualiza na tabela a linha em que esta o meteoro
	CMP R1,	1
	JLE fragmento1

	MOV R7, 4
	CMP R1, R7 
	JLE fragmento2

	CMP R3, TIPO_METEORO
	JZ is_meteor
	CMP R3, TIPO_MOEDA
	JZ is_coin

	
	; RANDOM for object type comes in here 
	; 0 if meteor 1 if coin (changed the EQU)
	MOV R8, 0
	CMP R8, TIPO_METEORO	; objeto e do tipo meteoro?
	JZ is_meteor			; se sim desenha um meteoro

is_coin:
	MOV R7, 8
	CMP R1, R7
	JLE moeda1

	MOV R7, 14
	CMP R1, R7
	JLE moeda2


	JMP moeda3

is_meteor:
	MOV R7, 8
	CMP R1, R7
	JLE meteoro1

	MOV R7, 14
	CMP R1, R7
	JLE meteoro2


	JMP meteoro3

fragmento1:
	MOV R4, DEF_FRAGMENTO_1
	SUB R1, 1
	CALL apaga_boneco
	ADD R1, 1
	CALL desenha_boneco		; escreve o meteoro na nova linha
	JMP sai_anima_meteoro

fragmento2:
	MOV R4, DEF_FRAGMENTO_2
	SUB R1, 1
	CALL apaga_boneco
	ADD R1, 1
	CALL desenha_boneco
	JMP sai_anima_meteoro

meteoro1:
	MOV R4, DEF_METEORO_1
	SUB R1, 1
	CALL apaga_boneco
	ADD R1,1
	CALL desenha_boneco
	JMP sai_anima_meteoro

meteoro2:
	MOV R4, DEF_METEORO_2
	SUB R1, 1
	CALL apaga_boneco
	ADD R1,1
	CALL desenha_boneco
	JMP sai_anima_meteoro

meteoro3:
	MOV R4, DEF_METEORO_3
	SUB R1, 1
	CALL apaga_boneco
	ADD R1,1
	CALL desenha_boneco
	JMP sai_anima_meteoro

moeda1:
	MOV R4, DEF_MOEDA_1
	SUB R1, 1
	CALL apaga_boneco
	ADD R1,1
	CALL desenha_boneco
	JMP sai_anima_meteoro

moeda2:
	MOV R4, DEF_MOEDA_2
	SUB R1, 1
	CALL apaga_boneco
	ADD R1,1
	CALL desenha_boneco
	JMP sai_anima_meteoro

moeda3:
	MOV R4, DEF_MOEDA_3
	SUB R1, 1
	CALL apaga_boneco
	ADD R1,1
	CALL desenha_boneco
	JMP sai_anima_meteoro

sai_anima_meteoro:
	POP  R9
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

Missil:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV R9, STANDARD_BACKGROUND
	MOV R1,[PRESSED_KEY]	
	CMP R1, TECLA_MISSIL
	JNZ Move_missil			; se a tecla do missil nao foi premida entao deve apenas mover o missil

	MOV R1, [MISSIL_NUMBER]
	CMP R1, 0				
	JZ Draw_missil			; se a tecla foi premida e nao existe outro missil entao deve desenhar um

	JMP exit_missil

Draw_missil:
	MOV R1, DISPLAY_MISSIL
	MOV [INC_DEC_DISPLAY], R1
	MOV R2, SOM_DISPARO
	MOV [TOCA_SOM], R2			; toca o som de quando o missil foi disparado
	MOV R2, [POS_ROVER_X]
	MOV R1, [POS_ROVER_Y]
	SUB R1, 1
	ADD R2, 2
	MOV [POS_MISSIL_X],R2		; define as posicoes onde o missil vai aparecer
	MOV [POS_MISSIL_Y],R1
	MOV R4, DEF_MISSIL
	CALL desenha_boneco			; desenha o missil
	MOV R4, 1
	MOV [MISSIL_NUMBER], R4		;escreve na memoria que já existe um missil
	JMP exit_missil

Move_missil:
	MOV R1, [MISSIL_NUMBER]
	CMP R1, 0
	JZ exit_missil			; se nao existe um missil entao nao deve mover
	
	MOV R1,[INTERRUPCAO_MISSIL]
	CMP R1 , ON				;verifica se a interrupção foi ativada
	JNZ exit_missil
	MOV R2,[POS_MISSIL_X]  
	MOV R1,[POS_MISSIL_Y]
	MOV R4, DEF_MISSIL
	CALL testa_limite_cima	
	CMP R0,0				;verifica se o missil chegou ao limite do ecra
	JZ missil_disapear		; se chegou ao limite este deve desaparecer
	
	CALL apaga_boneco	; apaga o missil na posicao atual
	SUB R1,1
	MOV [POS_MISSIL_Y],R1
	CALL desenha_boneco		; desenha o boneco no pixel acima
	MOV R1,OFF
	MOV [INTERRUPCAO_MISSIL],R1	; reset ao valor da interrupcao
	JMP exit_missil

missil_disapear:				; apaga o missil existente
	MOV R3, 0
	MOV [MISSIL_NUMBER], R3
	MOV R2, [POS_MISSIL_X]
	MOV R1, [POS_MISSIL_Y]
	MOV R4, DEF_MISSIL
	CALL apaga_boneco
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

testa_limite_cima:
	PUSH R3
	MOV R3,MAX_LINHA_MISSIL
	CMP R1,R3
	JZ apaga_missil
	JMP sai_limite_cima
apaga_missil:
	CALL apaga_boneco
	MOV R0,0
	MOV [MISSIL_NUMBER],R0
sai_limite_cima:
	POP R3
	RET


; ************************************************************************
; UPDATE_DISPLAY - 
;
; ************************************************************************
UPDATE_DISPLAY:
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R2,[INC_DEC_DISPLAY]
	CMP R2,0
	JZ EXIT_UPDATE_DISPLAY
	MOV R1, [DISPLAY_VAL]
	CALL testa_limites_display
	CALL HEX_TO_DEC
	MOV [DISPLAY], R1			; altera o display 
	MOV R3, OFF
	MOV [INC_DEC_DISPLAY],R3

EXIT_UPDATE_DISPLAY:
	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; HEX_TO_DEC - changes the number in hexadecimal to decimal
; Argumentos:   R1 - número hexadecimal
;
; **********************************************************************
HEX_TO_DEC: 				; converto numeros hexadecimais (até 63H) para decimal
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
; Retorna: 		R7 - 0 se ja tiver chegado ao limite, inalterado caso contrario
;
; **********************************************************
testa_limites_display:
	PUSH R2
	PUSH R5
	PUSH R6
testa_display_min:
	MOV R5, DISPLAY_MIN					; valor minimo do display
	CMP R1, R5
	JZ sai_testa_limites_display			; ja nao pode diminuir mais
	ADD R1, R2		; valor atual do display
testa_display_max:
	MOV R6, DISPLAY_MAX
	CMP R1,R6
	JGT max_display				; chegou ao máximo
	MOV [DISPLAY_VAL], R1		; altera o valor guardado do display
	JMP sai_testa_limites_display
max_display:
	MOV [DISPLAY_VAL],R6
sai_testa_limites_display:
	POP R6
	POP R5
	POP R2
	RET

; **********************************************************************
; ROVER - Move o Rover caso a tecla para o mesmo tenha sido premida
; Argumentos:   R0 - tecla premida
;  
; **********************************************************************

Rover:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R7
	PUSH R9

obtem_tecla:				; neste ciclo espera-se até uma tecla ser premida
	CMP R0, -1				; R0 = -1 se nenhuma tecla foi premida
	JZ exit_rover
	CALL testa_limites		;retorna 1(direita),-1(esquerda),0 não existe movimento
	CMP R7,0
	JZ exit_rover

move_rover:
	CALL atraso
	MOV R9, STANDARD_BACKGROUND
	MOV R1, [POS_ROVER_Y]		; guarda a posicao Y do rover
	MOV R2, [POS_ROVER_X]		; guarda a posicao X do rover
	MOV R4, DEF_ROVER			; guarda a definicao do rover
	CALL apaga_boneco		; apaga o rover na sua posicao corrente

coluna_seguinte:
	MOV R2, [POS_ROVER_X]
	ADD R2, R7					; calcula a nova coluna do rover
	MOV	[POS_ROVER_X], R2		; altera a coluna  do rover
	CALL desenha_boneco			; desenha o rover na sua nova posicao
	JMP exit_rover

exit_rover:
	POP R9
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
;				R9 - ecrã em que vai ser escrito o boneco
;
; **********************************************************************
desenha_boneco:       		; desenha o boneco a partir da tabela
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH 	R7
	PUSH	R8
	PUSH 	R9

	MOV [MUDAR_ECRA], R9 
	MOV	R7, R2				; guarda o valor da coluna 
	MOV	R5, [R4]			; obtem a largura do boneco
	MOV R8, R5				; guarda a largura
	ADD R4, 2				; endereço da tabela que define a altura do boneco
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, 2				; primeira cor

desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			; obtem a cor do proximo pixel do boneco
	CALL escreve_pixel
	ADD	R4, 2				; endereco da cor do proximo pixel (2 porque cada cor de pixel e uma word)
    ADD  R2, 1             ; proxima coluna
    SUB  R5, 1				; menos uma coluna para tratar
    JNZ  desenha_pixels    ; continua ate percorrer toda a largura do objeto
	ADD R1, 1				; proxima linha
	MOV R2, R7				; repoe a coluna no principio 
	MOV R5, R8				; repoe a largura  
	SUB R6, 1				; menos uma linha para tratar
	JNZ desenha_pixels		; continua até percorrer todas as linhas
	
	POP R9
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
apaga_boneco:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH 	R6
	PUSH 	R7
	PUSH 	R9

	MOV [MUDAR_ECRA], R9
	MOV R7, R2				; guarda o valor da coluna
	MOV	R5, [R4]			; obtem a largura do boneco
	ADD R4, 2				; passa para altura
	MOV R6, [R4]			; obtem a altura do boneco
	SUB R4, 2				; repoe o R4 com o valor da largura

apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0				; cor para apagar o próximo pixel do boneco
	CALL	escreve_pixel	; escreve cada pixel do boneco
     ADD  R2, 1             ; proxima coluna
     SUB  R5, 1				; menos uma coluna para tratar
     JNZ  apaga_pixels      ; continua ate percorrer toda a largura do objeto
	MOV R5, [R4]			; repoe a largura	
	MOV R2, R7				; repoe a coluna
	 ADD R1, 1				; proxima linha
	 SUB R6, 1				; menos uma linha para tratar
	 JNZ apaga_pixels

	POP R9
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
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna ja selecionadas
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
testa_limites:
	PUSH	R2
	PUSH	R5
	PUSH	R6
lado_a_testar:
	CMP	R0, TECLA_DIREITA					
	JZ	testa_limite_direito	; se se for deslocar para a direita
	CMP R0, TECLA_ESQUERDA
	JZ	testa_limite_esquerdo	; se se for deslocar para a esquerda
	MOV R1, 0
	JMP sai_testa_limites
testa_limite_esquerdo:			; vê se o rover chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA			; obtem o valor da coluna minima
	MOV R2, [POS_ROVER_X]		; obtem coluna em que o rover esta
	CMP	R2, R5					; compara a posicao do rover com o limite esquerdo
	JZ	impede_movimento		; ja nao pode mover mais
	MOV R7, -1
	JMP sai_testa_limites		; entre limites, mantem o valor do R7
testa_limite_direito:			; ve se o boneco chegou ao limite direito	
	MOV R2, [POS_ROVER_X]		; obtem coluna em que o rover esta
	MOV R6, [DEF_ROVER]			; obtem a largura do rover
	ADD	R6, R2					; posicao do extremo direito do boneco + 1
	SUB R6, 1					; posicao do extremo direito do boneco
	MOV	R5, MAX_COLUNA			; obtem o valor da coluna maxima
	CMP	R6, R5
	JZ impede_movimento			; ja nao pode mover mais
	MOV R7, 1
	JMP	sai_testa_limites		; entre limites, mantem o valor do R7
impede_movimento:
	MOV	R7, 0					; impede o movimento, forçando R7 a 0
sai_testa_limites:	
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
Teclado:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH 	R9

    MOV  R2, TEC_LIN   	; endereco do periferico das linhas
    MOV  R3, TEC_COL   	; endereco do periferico das colunas
    MOV  R5, MASCARA   	; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ciclo:
    MOV R0, 1          	; inicializa o R0 a um 
    MOV R1, 0          	; inicializa o R1 a zero 
    MOV R6, R1         	; escreve coluna a zero
    MOV R7, R1         	; escreve calculo potesta_limites_displaysicao linha a zero
    MOV R8, R1         	; escreve caluclo posicao coluna a zero
	MOV R9, 8
espera_tecla:          	; neste ciclo espera-se ate uma tecla ser premida
    MOVB [R2],R0       	; ler pertiferico de saida (linhas)
    MOVB R1, [R3]      	; ler do periferico de entrada (colunas)
    AND  R1, R5        	; elimina bits para alem dos bits 0-3
    CMP  R1, 0         	; ha tecla premida?
    MOV R6,R0          	; para poder verificar se a tecla ainda está pressionada
    JNZ  calcula_col   	; tecla premida começa a calcular qual foi premida
    CMP R0,R9          	; verifica se ja chegou ao valor 8
    JZ fim_sem_tecla
    SHL R0,1           	; passa para a proxima linha
    JMP espera_tecla   	; se nenhuma tecla premida repete
calcula_col:
    SHR R1,1           	; realiza um shift right
    CMP R1,0           	; verifica se ainda nao está na coluna certa
    JZ calcula_line    	; se ja estiver na coluna certa vai calcular as linhas
    INC R8             	; se ainda nao estiver a coluna certa incrmenta o contador
    JMP calcula_col    	; enquanto nao estiver na coluna certa continua a correr
calcula_line:
    SHR R0,1           	; realiza um shift right
    CMP R0,0           	; verifica se ainda nao esta na coluna certa
    JZ tecla           	; se ja estiver na coluna certa vai calcular a tecla premida
    INC R7             	; se ainda nao estiver na linha certa incrmenta o contador das linhas
    JMP calcula_line   	; enquanto nao estiver na linha certa continua a correr
tecla:
    SHL R7,2           	; vai multiplicar o numero da linha por 4
    ADD R8,R7          	; vai adicionar a coluna o numero de linhas
    AND R8,R5          	; elimina bits para alem dos bits 0-3
    MOV R0,R8          	; saber que tecla foi pressionada
	MOV [PRESSED_KEY],R8
	JMP end
fim_sem_tecla:
	MOV R0, -1			; nenhuma tecla premida
	MOV [PRESSED_KEY], R0
	JMP end

end:	
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

; **********************************************************************
; ATRASO - Executa um ciclo para implementar um atraso.
; Argumentos:   R11 - valor que define o atraso
;
; **********************************************************************
atraso:
	PUSH	R11
	MOV R11, ATRASO
ciclo_atraso:
	
	SUB	R11, 1
	JNZ	ciclo_atraso
	POP	R11
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
	MOV [INTERRUPCAO_METEORO], R1
	POP R1
	RFE					; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_1 -	Rotina de atendimento da interrup��o 1
;			Faz com que o missil se mova uma casa para cima periodicamente
; **********************************************************************
rot_int_1:
	PUSH R1 
	MOV R1, ON
	MOV [INTERRUPCAO_MISSIL], R1
	POP R1
	RFE					; Return From Exception (diferente do RET)

; **********************************************************************
; ROT_INT_2 -	Rotina de atendimento da interrupcao 2
;			Records in the memory the value 1 and the value of how much
;			the display will increase (5%)
; **********************************************************************
rot_int_2:
	PUSH R1
	MOV R1, DISPLAY_TIME
	MOV [INC_DEC_DISPLAY],R1
	POP R1
	RFE					; Return From Exception (diferente do RET)


init_display:
	PUSH R1
	MOV R1, DISPLAY_MAX_INIT		
	MOV [DISPLAY], R1						; reinicia o display
	MOV R1, DISPLAY_MAX
	MOV [DISPLAY_VAL], R1					; reinicia o valor do display
	POP R1
	RET
