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
; * Modulo:    grupo04.asm
;
; * Descrição: Este programa tem como objetivo reproduzir um esboco daquilo que
;	sera um jogo no estilo space invaders.
;	Nesta fase do projeto as seguintes features estao implementadas:
;		-implementacao de um teclado
;		-implementacao de um display (3 digitos) em hexadecimal
;		-implementacao de um display grafico (media center)
;		-imagem de fundo
;		-design do rover
;		-design do meteoro
;		-movimento continuo do rover premindo a tecla 4 (esquerda) ou tecla 6 (direita)
;		-movimento com efeito sonoro do meteoro clicando na tecla 9
;		-incremento ou decremento do display hexadecimal premindo a tecla 3 
;		ou 7 respetivamente
;
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
DISPLAY				EQU 0A000H 	; endereço do display
DISPLAY_INCREASE	EQU 0FFFBH	; value that the interruption will make the display increase
ON					EQU 0001H	; activate the update_display routine
OFF					EQU 0000H	; activate the update_display routine
MASCARA_DISPLAY		EQU 0FFFH	; isolar os 12 bits de menor peso, ao ler o valor do display

TECLA_ESQUERDA		EQU 4		; tecla para movimentar para a esquerda (tecla 4)
TECLA_DIREITA		EQU 6		; tecla para movimentar para a direita (tecla 6)
TECLA_BAIXO			EQU 9		; tecla para movimentar para baixo (tecla 9)
TECLA_MISSIL		EQU 1		; tecla para disparar umm missil

DEFINE_LINHA    		EQU 600AH      	; endereco do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      	; endereco do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      	; endereco do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      	; endereco do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 			EQU 6002H      	; endereco do comando para apagar todos os pixels ja desenhados
SELECIONA_CENARIO_FUNDO EQU 6042H      	; endereco do comando para selecionar uma imagem de fundo
TOCA_SOM				EQU 605AH      	; endereco do comando para tocar um som

LINHA_ROVER      	EQU  28     ; linha do boneco (posicao mais baixa)
COLUNA_ROVER		EQU  30     ; coluna do boneco (a meio do ecra)
LINHA_METEORO      	EQU  2      ; linha do meteoro 
COLUNA_METEORO		EQU  30     ; coluna do meteoro (a meio do ecra) 

MIN_COLUNA			EQU  0		; numero da coluna mais a esquerda
MAX_COLUNA			EQU  074H   	; numero da coluna mais a direita 
MIN_LINHA			EQU	 0		; numero da linha mais em cima 
MAX_LINHA			EQU	 0F80H	; numero da linha mais em baixo
MAX_LINHA_METEORO 	EQU 23		; numero maximo que o meteorito pode atingir de forma a nao afetar o rover
DISPLAY_MAX			EQU 64H 	; numero maximo que o display deve mostrar (100 dec)
DISPLAY_MAX_INIT	EQU 0100H	; valor inicial do display
DISPLAY_MIN			EQU 0H  	; numero minimo que o display deve mostrar
DECREMENTACAO_DISPLAY	EQU 5	; valor que vai ser subtraido periodicamente
HEXTODEC 			EQU 0AH

ATRASO			EQU	0400H		; atraso para limitar a velocidade de movimento do boneco

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

; *********************************************************************************
; * Dados 
; *********************************************************************************
PLACE 1400H
POS_ROVER_X:	WORD	0000H; endereco de memoria da coluna do rover
POS_ROVER_Y:	WORD	0000H; endereco de memoria da linha do rover
POS_METEORO_X:	WORD	0000H; endereco de memoria da coluna do meteoro
POS_METEORO_Y:	WORD	0000H; endereco de memoria da linha do meteoro
POS_MISSIL_X:	WORD	0000H;
POS_MISSIL_Y:	WORD	0000H;
DISPLAY_VAL:	WORD	0000H; endereco de memoria do valor do display
INC_DEC_DISPLAY: WORD	0000H; endereço de memória de valor a acrescentar ao display
INTERRUPCAO_METEORO: WORD 0000H; endereço de memória do valor de ativação do movimento do meteoro
INTERRUPCAO_MISSIL:  WORD 0000H; endereço de memória do valor de ativação do movimento do missíl
INTERRUPCAO_ENERGIA: WORD 0000H; endereço de memória do valor de ativação da redução da energia
MISSIL_NUMBER:	WORD 0000H; adress of the number of missils in screen
PRESSED_KEY:	WORD 0000H; Pressed key

PLACE 1000H

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

DEF_METORO_1:			; tabela que define o meteoro nivel 1 (cor, largura, altura, pixels)
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
	WORD		YELLOW, BROWN, RED, BROWN, YELLOW
	WORD		0, RED, BLUE, RED, 0
	WORD		YELLOW, BROWN, RED, BROWN, YELLOW
	WORD		0, YELLOW, 0, YELLOW, 0

DEF_MISSIL:				; tabela que define o missil (cor, largura, altura, pixels)
	WORD		LARGURA_MISSIL
	WORD		ALTURA_MISSIL
	WORD		DRKBLUE

tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2


; *********************************************************************************
; * Codigo
; *********************************************************************************
PLACE   0                     ; o codigo tem de comecar em 0000H
inicio:
	MOV  SP, SP_inicial						; inicializa SP para a palavra a seguir a ultima da pilha 
	MOV  BTE, tab							; inicializa BTE (registo de Base da Tabela de Exce��es)
    MOV  [APAGA_AVISO], R1					; apaga o aviso de nenhum cenario selecionado (o valor de R1 nao e relevante)
    MOV  [APAGA_ECRA], R1					; apaga todos os pixels ja desenhados (o valor de R1 nao e relevante)
	MOV	R1, 0								; cenario de fundo numero 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenario de fundo
	EI0										; permite interrupções 0
	EI1										; permite interrupções 1
	EI2										; permite interrupções 2
	EI									; permite interrupções (geral)

init_display:
	MOV R1, DISPLAY_MAX_INIT
	MOV R2, DISPLAY_MAX		
	MOV [DISPLAY], R1						; reinicia o display
	MOV [DISPLAY_VAL], R2					; reinicia o valor do display

init_meteoro:
     MOV  R1, LINHA_METEORO			; linha do meteoro
     MOV  R2, COLUNA_METEORO		; coluna do meteoro
	 MOV  [POS_METEORO_X], R2		; poe a coluna do meteoro na memoria
	 MOV  [POS_METEORO_Y], R1		; poe a linha do meteoro na memoria
	 MOV  R4, DEF_METEORO_3			; define o meteoro
	 CALL desenha_boneco

init_ROVER:
     MOV  R1, LINHA_ROVER			; linha do boneco
     MOV  R2, COLUNA_ROVER			; coluna do boneco
	 MOV  [POS_ROVER_X], R2			; poe a coluna do rover na memoria
	 MOV  [POS_ROVER_Y], R1			; poe a linha do rover na memoria
	 MOV  R4, DEF_ROVER				; define o rover
	 CALL desenha_boneco

main:
	CALL Teclado			; leitura às tecla
	CALL Rover				; Move Rover caso tecla tenha sido premida
	CALL UPDATE_DISPLAY
	CALL Missil
	JMP main

;testa_display_baixo:
;	CMP R0, R8					; compara a tecla premida com a tecla que decrementa (7)
;	JNZ testa_display_cima		; caso esta nao seja a display_baixo (7), vamos testar a display_cima (3)
;	MOV R9, R8					; valor da tecla de descer o display
;	CALL espera_nao_tecla		; espera até que a tecla deixe de ser premida
;	MOV R7, -1					; vai decrementar o display
;	JMP ve_limites_display	



	

;ve_limites_display:
;	CALL testa_limites_display		; ve se chegou aos limites do display e se sim forca R7 a 0
;	CMP R7, 0
;	JZ obtem_tecla					; se nao e para incremenetar o display, vai ler o teclado de novo
;	JMP altera_display

;move_meteoro:
;	MOV R1, [POS_METEORO_Y]		; guarda a posicao Y do rover
;	MOV R2, [POS_METEORO_X]		; guarda a posicao X do rover
;	MOV R4, DEF_METEORO_3		; guarda a definicao do rover
;	CALL apaga_boneco			; apaga o meteoro na sua posicao corrente
;	JMP linha_seguinte	


;linha_seguinte:
;	MOV R1, [POS_METEORO_Y]
;	ADD R1, R7					; calcula a nova linha do meteoro
;	MOV [POS_METEORO_Y], R1		; altera a linha do meteoro
;	CALL desenha_boneco			; desenha o meteoro na sua nova posica
;	JMP obtem_tecla
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
	PUSH R2
	MOV R1, ON;
	MOV [INTERRUPCAO_ENERGIA],R1
	MOV R2, DISPLAY_INCREASE;
	MOV [INC_DEC_DISPLAY], R2
	POP R2
	POP R1
	RFE					; Return From Exception (diferente do RET)

; ************************************************************************
; MISSIL - moves the missil one position at a time(depends on exception 1)
;
; ************************************************************************

Missil:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	MOV R1,[PRESSED_KEY]		
	CMP R1, TECLA_MISSIL	;vê se a tecla do missil foi premida
	JNZ Move_missil
	MOV R1, [MISSIL_NUMBER]
	CMP R1, 0				;vê se já existe um missíl no ecrã
	JZ Draw_missil
	JMP exit_missil

Draw_missil:
	MOV R1, [POS_ROVER_X]
	MOV R2, [POS_ROVER_Y]
	SUB R1, 3
	ADD R2, 4
	MOV [POS_MISSIL_X],R1
	MOV [POS_MISSIL_Y],R2
	MOV R4, DEF_MISSIL
	CALL desenha_boneco
	MOV R4, 1
	MOV [MISSIL_NUMBER], R4	;escreve na memoria que já existe um missil
	JMP exit_missil

Move_missil:
	MOV R1,[INTERRUPCAO_MISSIL]
	CMP R1 , ON				;verifica se a interrupção foi ativada
	JNZ exit_missil
	MOV R1,[POS_MISSIL_X]
	MOV R2,[POS_MISSIL_Y]
	MOV R4,DEF_MISSIL
	CALL testa_limite_cima
	CMP R0,0				;verifica se o missil chegou ao limite do ecra
	JZ exit_missil
	CALL apaga_boneco
	SUB R1,1
	MOV [POS_MISSIL_X],R1
	CALL desenha_boneco
	MOV R1,OFF
	MOV [INTERRUPCAO_MISSIL],R1

exit_missil:
	POP R4
	POP R2
	POP R1
	POP R0
	RET

testa_limite_cima:
	PUSH R3
	MOV R3,MIN_LINHA
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
; UPDATE_DISPLAY - updates the display by increasing 5% or decreasing 10%
;
; ************************************************************************
UPDATE_DISPLAY:
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R2,[INTERRUPCAO_ENERGIA]
	CMP R2,0
	JZ EXIT_UPDATE_DISPLAY
	MOV R1, [DISPLAY_VAL]
	CALL testa_limites_display
	MOV [DISPLAY_VAL], R1
	CALL HEX_TO_DEC
	MOV [DISPLAY], R1			; altera o display 
	MOV R3, OFF
	MOV [INTERRUPCAO_ENERGIA],R3

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
;
; Retorna: 		R7 - 0 se ja tiver chegado ao limite, inalterado caso contrario
;
; **********************************************************
testa_limites_display:
	PUSH R2
	PUSH R5
	PUSH R6
	MOV R2,[INC_DEC_DISPLAY]
	CMP R2, 0
	JGT testa_display_min
	JZ sai_testa_limites_display
testa_display_min:
	MOV R5, DISPLAY_MIN					; valor minimo do display
	CMP R1, R5
	JZ impede_movimento_display			; ja nao pode diminuir mais
	ADD R1, R2		; valor atual do display
	MOV [DISPLAY_VAL], R1		; altera o valor guardado do display
	JMP sai_testa_limites_display
impede_movimento_display:
	ADD R1,DECREMENTACAO_DISPLAY		; impede a alteracao
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

obtem_tecla:				; neste ciclo espera-se até uma tecla ser premida
	CMP R0, -1				; R0 = -1 se nenhuma tecla foi premida
	JZ exit_rover
	CALL testa_limites		;retorna 1(direita),-1(esquerda),0 não existe movimento
	CMP R7,0
	JZ exit_rover

move_rover:
	MOV R1, [POS_ROVER_Y]		; guarda a posicao Y do rover
	MOV R2, [POS_ROVER_X]		; guarda a posicao X do rover
	MOV R4, DEF_ROVER			; guarda a definicao do rover
	CALL atraso
	CALL apaga_boneco		; apaga o rover na sua posicao corrente

coluna_seguinte:
	MOV R2, [POS_ROVER_X]
	ADD R2, R7					; calcula a nova coluna do rover
	MOV	[POS_ROVER_X], R2		; altera a coluna  do rover
	CALL desenha_boneco			; desenha o rover na sua nova posicao
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
desenha_boneco:       		; desenha o boneco a partir da tabela
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

; **********************************************************
; TESTA_LIMITES_METEORO - Testa se o meteoro chegou a linha
;				onde o rover pode estar 
;				(linhas ocupadas pelo rover)	
;				e nesse caso impede o movimento (força R7 a 0)
; Argumentos:	R2 - linha em que o meteoro esta
;				R6 - largura do meteoro
;				R7 - sentido de movimento do meteoro (valor a somar a linha
;				em cada movimento: +1 para baixo)
;
; Retorna: 		R7 - 0 se já tiver chegado ao limite, inalterado caso contrário
;
; ******************************************************
testa_limites_meteoro:
	PUSH	R2
	PUSH	R5
	PUSH	R6
testa_limite_baixo:					; ve se o meteoro chegou ao limite inferior do ecra
	MOV	R5, MAX_LINHA_METEORO		; obtem o valor da coluna maxima
	MOV R2, [POS_METEORO_Y]			; obtem a posicao atual do meteoro
	CMP	R2, R5	
	JZ impede_movimento_meteoro		; ja nao pode mover mais
	JMP sai_testa_limites_meteoro	; entre limites. Mantem o valor do R7
impede_movimento_meteoro:
	MOV	R7, 0						; impede o movimento, forçando R7 a 0
sai_testa_limites_meteoro:	
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
    MOV R7, R1         	; escreve calculo posicao linha a zero
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


