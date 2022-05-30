
; *********************************************************************************
; * Constantes
; *********************************************************************************
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

TECLA_ESQUERDA		EQU 4		; tecla para movimentar para a esquerda (tecla 4)
TECLA_DIREITA		EQU 6		; tecla para movimentar para a direita (tecla 6)
TECLA_BAIXO			EQU 9		; tecla para movimentar para baixo (tecla 9)

POS_ROVER_X			EQU 1406H
POS_ROVER_Y			EQU 1408H
POS_METEOR_X		EQU 140AH
POS_METEOR_Y		EQU 140CH

DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo

LINHA_ROVER      		EQU  28        ; linha do boneco (posição mais baixa)
COLUNA_ROVER				EQU  30        ; coluna do boneco (a meio do ecrã)
LINHA_METEORITO      	EQU  2        ; linha do meteorito 
COLUNA_METEORITO		EQU  30        ; coluna do meteorito (a meio do ecrã) 

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
MIN_LINHA		EQU	 0		
MAX_LINHA		EQU	 31
MAX_LINHA_METEORO 	EQU 23

ATRASO			EQU	0400H		; atraso para limitar a velocidade de movimento do boneco

LARGURA_ROVER		EQU	5			; largura da ROVER
ALTURA_ROVER		EQU 4			; altura da ROVER
LARGURA_METEORITO		EQU	5			; largura da METEORITO #
ALTURA_METEORITO		EQU 5			; altura da METEORITO
RED		EQU	0FF00H		; cor vermelha
BLACK	EQU 0F000H		; cor preta
WHITE 	EQU 0FFFFH		; cor branca
BLUE	EQU 0F3CDH		; cor azul
GRAY	EQU 0FCCCH		; cor cinzenta
GREEN	EQU 0F0F0H		; cor verde #
BROWN	EQU 0F840H		; cor castanha #
YELLOW	EQU 0FFF0H		; cor amarela #

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
							
DEF_BONECO:					; tabela que define o boneco (cor, largura, altura, pixels)
	WORD		LARGURA_ROVER
	WORD		ALTURA_ROVER
	WORD		0, 	0, 	BLUE, 0, 0
	WORD		0, GRAY, BLUE, GRAY, 0		
	WORD		GRAY, GRAY, GRAY, GRAY, GRAY
    WORD		0, 0, RED, 0, 0

DEF_METEORITO:					; tabela que define o meteorito (cor, largura, altura, pixels)
	WORD		LARGURA_METEORITO
	WORD		ALTURA_METEORITO
	WORD		YELLOW , 0 , YELLOW , 0 , YELLOW
	WORD		0 , YELLOW , RED , YELLOW , 0
	WORD		YELLOW , RED , BROWN , RED , YELLOW
    WORD		RED , BROWN , BROWN , BROWN , RED
	WORD		0 , RED , BROWN , RED , 0


; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						; à última da pilha
                            
     MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
     MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 0			; cenário de fundo número 0
     MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV	R7, 0			; valor a somar à coluna do boneco, para o movimentar

init_meteorito:
     MOV  R1, LINHA_METEORITO		; linha do meteorito
     MOV  R2, COLUNA_METEORITO		; coluna do meteorito
	 MOV  [POS_METEOR_X], R2		; poe a coluna do meteorito na memoria
	 MOV  [POS_METEOR_Y], R1		; poe a linha do meteorito na memoria
	 MOV  R4, DEF_METEORITO			; define o meteorito
	 CALL desenha_boneco

init_ROVER:
     MOV  R1, LINHA_ROVER			; linha do boneco
     MOV  R2, COLUNA_ROVER		; coluna do boneco
	 MOV  [POS_ROVER_X], R2		; poe a coluna do rover na memoria
	 MOV  [POS_ROVER_Y], R1		; poe a linha do rover na memoria
	 MOV  R4, DEF_BONECO		; define o rover
	 CALL desenha_boneco

obtem_tecla:				; neste ciclo espera-se até uma tecla ser premida
	CALL	teclado			; leitura às tecla
	CMP R0, -1
	JZ obtem_tecla
	MOV R8, TECLA_ESQUERDA		; valor da tecla esquerda
	CMP	R0, R8				; compara a tecla carregada com a tecla esquerda (4)
	JNZ	testa_direita		; tecla que nao interessa
	MOV	R7, -1				; vai deslocar para a esquerda
	JMP	ve_limites

testa_direita:
	MOV R9, TECLA_DIREITA		; valor da tecla direita
	CMP	R0, R9			; compara a tecla carregada com a tecla direita (6)
	JNZ	testa_baixo		; tecla que não interessa
	MOV	R7, +1			; vai deslocar para a direita
	JMP ve_limites

testa_baixo:
	MOV R10, TECLA_BAIXO		; valor da tecla baixo (meteoro)
	CMP R0, R10			; compara a tecla carregada com a tecla baixo (9)
	JNZ obtem_tecla		; tecla que nao interessa

espera_nao_tecla_meteoro:	
	CALL teclado
	CMP R0, -1
	JNZ espera_nao_tecla_meteoro
	MOV R7, +1			; vai deslocar para baixo
	JMP ve_limites_meteoro
	
ve_limites:
	CALL	testa_limites		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	R7, 0
	JZ	obtem_tecla				; se não é para movimentar o objeto, vai ler o teclado de novo
	JMP move_rover		

ve_limites_meteoro:
	CALL  testa_limites_meteoro		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP R7, 0
	JZ obtem_tecla					; se não é para movimentar o objeto, vai ler o teclado de novo
	JMP move_meteoro

move_rover:
	MOV R1, [POS_ROVER_Y]
	MOV R2, [POS_ROVER_X]
	MOV R4, DEF_BONECO
	CALL atraso
	CALL	apaga_boneco		; apaga o rover na sua posição corrente
	JMP coluna_seguinte

move_meteoro:
	MOV R1, [POS_METEOR_Y]
	MOV R2, [POS_METEOR_X]
	MOV R4, DEF_METEORITO
	CALL apaga_boneco		; apaga o meteoro na sua posicao corrente
	JMP linha_seguinte
	
coluna_seguinte:
	MOV R2, [POS_ROVER_X]
	ADD R2, R7
	MOV	[POS_ROVER_X], R2			; altera a coluna  do rover

	CALL desenha_boneco		; desenha o rover na sua nova posicao
	JMP obtem_tecla

linha_seguinte:
	MOV R1, [POS_METEOR_Y]
	ADD R1, R7
	MOV [POS_METEOR_Y], R1			; altera a linha do meteoro
	CALL desenha_boneco		; desenha o meteoro na sua nova posica
	JMP obtem_tecla


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
	MOV	R5, [R4]			; obtém a largura do boneco
	MOV R8, R5				; guarda a largura
	ADD R4, 2				; endereço da tabela que define a altura do boneco
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, 2				; primeira cor

desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
	CALL escreve_pixel

	ADD	R4, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
     ADD  R2, 1               ; próxima coluna
     SUB  R5, 1			; menos uma coluna para tratar
     JNZ  desenha_pixels      ; continua até percorrer toda a largura do objeto
	ADD R1, 1			; proxima linha
	MOV R2, R7			; Repõe a coluna no principio 
	MOV R5, R8		; Repõe a largura 
	SUB R6, 1			; menos uma linha para tratar
	JNZ desenha_pixels	; continua até percorrer todas as linhas
	
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
	MOV	R5, [R4]			; obtém a largura do boneco
	ADD R4, 2				; passa para altura
	MOV R6, [R4]			; obtem a altura do boneco
	SUB R4, 2				; repõe o R4 com o valor da largura

apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, 0			; cor para apagar o próximo pixel do boneco
	CALL	escreve_pixel		; escreve cada pixel do boneco
     ADD  R2, 1               ; próxima coluna
     SUB  R5, 1			; menos uma coluna para tratar
     JNZ  apaga_pixels      ; continua até percorrer toda a largura do objeto
	MOV R5, [R4]		; repoe a largura	
	MOV R2, R7			; repoe a coluna
	 ADD R1, 1			; proxima linha
	 SUB R6, 1			; menos uma linha para tratar
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
	MOV  [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna já selecionadas
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
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)
; Argumentos:	R2 - coluna em que o objeto está
;			R6 - largura do boneco
;			R7 - sentido de movimento do boneco (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************
testa_limites:
	PUSH	R2
	PUSH	R5
	PUSH	R6

lado_a_testar:
	CMP	R7, 0	
	JGE	testa_limite_direito	; se se for deslocar para a direita
	CMP R7, 0
	JLE	testa_limite_esquerdo

testa_limite_esquerdo:		; vê se o rover chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA		; obtem o valor da coluna minima
	MOV R2, [POS_ROVER_X]	; obtem coluna em que o rover esta
	CMP	R2, R5				
	JZ	impede_movimento	; entre limites. Mantém o valor do R7
	JMP sai_testa_limites
testa_limite_direito:		; vê se o boneco chegou ao limite direito
	MOV R6, [DEF_BONECO]
	ADD	R6, R2				; posição do extremo direito do boneco + 1
	SUB R6, 1				; posicao do extremo direito do boneco
	MOV	R5, MAX_COLUNA		; obtem o valor da coluna maxima
	CMP	R6, R5
	JZ impede_movimento
	JMP	sai_testa_limites
impede_movimento:
	MOV	R7, 0			; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	R6
	POP	R5
	POP R2
	RET

testa_limites_meteoro:
	PUSH	R2
	PUSH	R5
	PUSH	R6
testa_limite_baixo:	; vê se o boneco chegou ao limite esquerdo
	MOV	R5, MAX_LINHA_METEORO
	MOV R2, [POS_METEOR_Y]
	CMP	R2, R5
	JZ impede_movimento_meteoro
	JMP sai_testa_limites_meteoro
impede_movimento_meteoro:
	MOV	R7, 0			; impede o movimento, forçando R7 a 0
sai_testa_limites_meteoro:	
	POP	R6
	POP	R5
	POP R2
	RET
	
; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************
teclado:
; inicializacoes
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH	R9	
    MOV  R2, TEC_LIN   ; endereco do periferico das linhas
    MOV  R3, TEC_COL   ; endereco do periferico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; corpo principal do programa
ciclo:
    MOV R0, 1          ; inicializa o R0 a um #
    MOV R1, 0          ; inicializa o R1 a zero #
    MOV R6, R1         ; escreve coluna a zero
    MOV R7, R1         ; escreve calculo posição linha a zero
    MOV R8, R1         ; escreve caluclo posição coluna a zero
    MOV R9, 8          ; para comparar com R0

espera_tecla:          ; neste ciclo espera-se ate uma tecla ser premida
    MOVB [R2],R0       ; ler pertiferico de saída (linhas)
    MOVB R1, [R3]      ; ler do periferico de entrada (colunas)
    AND  R1, R5        ; elimina bits para alem dos bits 0-3
    CMP  R1, 0         ; ha tecla premida?
    MOV R6,R0          ; para poder verificar se a tecla ainda está pressionada
    JNZ  calcula_col   ; tecla premida começa a calcular qual foi premida
    CMP R0,R9          ; verifica se já chegou ao valor 8
    JZ fim_sem_tecla

    SHL R0,1           ; passa para a próxima linha
    JMP espera_tecla   ; se nenhuma tecla premida repete

calcula_col:
    SHR R1,1           ; realiza um shift right
    CMP R1,0           ; verifica se ainda não está na coluna certa
    JZ calcula_line    ; se já estiver na coluna certa vai calcular as linhas
    INC R8             ; se ainda não estiver a coluna certa incrmenta o contador
    JMP calcula_col    ; enquanto não estiver na coluna certa continua a correr

calcula_line:
    SHR R0,1           ; realiza um shift right
    CMP R0,0           ; verifica se ainda não está na coluna certa
    JZ tecla           ; se já estiver na coluna certa vai calcular a tecla premida
    INC R7             ; se ainda não estiver na linha certa incrmenta o contador das linhas
    JMP calcula_line   ; enquanto não estiver na linha certa continua a correr

tecla:
    SHL R7,2           ; vai multiplicar o número da linha por 4
    ADD R8,R7          ; vai adicionar á coluna o número de linhas
    AND R8,R5          ; elimina bits para além dos bits 0-3
    MOV R0,R8          ; saber que tecla foi pressionada
end:	
	POP	R9
	POP	R8
	POP	R7
	POP	R6
	POP	R5
	POP	R3
	POP	R2
	POP	R1
	RET	

fim_sem_tecla:
	MOV R0, -1
	JMP end
