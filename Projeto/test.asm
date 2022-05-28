; *********************************************************************************
; * IST-UL
; * Modulo:    lab5-move-boneco-teclado.asm
; * Descrição: Este programa ilustra o movimento de um boneco do ecrã, sob controlo
; *			do teclado.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
TEC_LIN				EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO		EQU 8		; linha a testar (4ª linha, 1000b)
MASCARA				EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA		EQU 4		; tecla para movimentar para a esquerda (tecla 4)
TECLA_DIREITA		EQU 6		; tecla para movimentar para a direita (tecla 6)
TECLA_BAIXO			EQU 9		; tecla para movimentar para baixo (tecla 9)

DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo

LINHA_NAVE      		EQU  28        ; linha do boneco (posição mais baixa)
COLUNA_NAVE				EQU  30        ; coluna do boneco (a meio do ecrã)
LINHA_METEORITO      	EQU  30        ; linha do meteorito
COLUNA_METEORITO		EQU  30        ; coluna do meteorito (a meio do ecrã)

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
MIN_LINHA		EQU	 0
MAX_LINHA		EQU	 31
ATRASO			EQU	400H		; atraso para limitar a velocidade de movimento do boneco

LARGURA_NAVE		EQU	5			; largura da nave
ALTURA_NAVE		EQU 4			; altura da nave
LARGURA_METEORITO		EQU	4			; largura da METEORITO
ALTURA_METEORITO		EQU 4			; altura da METEORITO
RED		EQU	0FF00H		; cor vermelha
BLACK	EQU 0F000H		; cor preta
WHITE 	EQU 0FFFFH		; cor branca
BLUE	EQU 0F3CDH		; cor azul
GRAY	EQU 0FCCCH		; cor cinzenta

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
	WORD		LARGURA_NAVE
	WORD		ALTURA_NAVE
	WORD		0, 	0, 	BLUE, 0, 0
	WORD		GRAY, 0, BLUE, 0, GRAY		
	WORD		GRAY, GRAY, GRAY, GRAY, GRAY
    WORD		0, RED, 0, RED

DEF_METEORITO:					; tabela que define o meteorito (cor, largura, altura, pixels)
	WORD		LARGURA_METEORITO
	WORD		ALTURA_METEORITO
	WORD		RED, 0 , 0 , RED
	WORD		RED, 0 , 0 , RED
	WORD		0, RED , RED, 0
    WORD		RED, 0 , 0 , RED


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
	MOV	R7, 1			; valor a somar à coluna do boneco, para o movimentar
	MOV R10, TECLA_DIREITA
	MOV R11, TECLA_ESQUERDA

posição_meteorito:
     MOV  R1, LINHA_METEORITO			; linha do boneco
     MOV  R2, COLUNA_METEORITO		; coluna do boneco
	MOV	R4, DEF_METEORITO		; endereço da tabela que define o boneco

mostra_meteorito:
	CALL	desenha_boneco		; desenha o boneco a partir da tabela 

posição_nave:
     MOV  R1, LINHA_NAVE			; linha do boneco
     MOV  R2, COLUNA_NAVE		; coluna do boneco
	MOV	R4, DEF_BONECO		; endereço da tabela que define o boneco

mostra_nave:
	CALL	desenha_boneco		; desenha o boneco a partir da tabela

wait_tecla:				; neste ciclo espera-se até uma tecla ser premida
	CALL	teclado			; leitura às tecla
	CMP	R0, R11
	JNZ	testa_direita
	MOV	R7, -1			; vai deslocar para a esquerda
	JMP	ve_limites
testa_direita:
	CMP	R0, R10
	JNZ	wait_tecla		; tecla que não interessa
	MOV	R7, +1			; vai deslocar para a direita
	
ve_limites:
	MOV	R6, [R4]			; obtém a largura do boneco
	CALL	testa_limites		; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	R7, 0
	JZ	wait_tecla		; se não é para movimentar o objeto, vai ler o teclado de novo

move_boneco:
	CALL	apaga_boneco		; apaga o boneco na sua posição corrente
	
coluna_seguinte:
	ADD	R2, R7			; para desenhar objeto na coluna seguinte (direita ou esquerda)

	JMP	mostra_nave		; vai desenhar o boneco de novo


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
	MOV R8, R5				; repor a largura
	ADD R4, 2				; endereço da tabela que define a altura do boneco
	MOV R6, [R4]			; obtem a altura do boneco
	ADD	R4, 2				; primeira cor

desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	R3, [R4]			; obtém a cor do próximo pixel do boneco
	MOV  [DEFINE_LINHA], R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	; altera a cor do pixel na linha e coluna selecionadas
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
	PUSH	R5
	PUSH	R6
testa_limite_esquerdo:		; vê se o boneco chegou ao limite esquerdo
	MOV	R5, MIN_COLUNA
	CMP	R2, R5
	JGT	testa_limite_direito
	CMP	R7, 0			; passa a deslocar-se para a direita
	JGE	sai_testa_limites
	JMP	impede_movimento	; entre limites. Mantém o valor do R7
testa_limite_direito:		; vê se o boneco chegou ao limite direito
	ADD	R6, R2			; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA
	CMP	R6, R5
	JLE	sai_testa_limites	; entre limites. Mantém o valor do R7
	CMP	R7, 0			; passa a deslocar-se para a direita
	JGT	impede_movimento
	JMP	sai_testa_limites
impede_movimento:
	MOV	R7, 0			; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	R6
	POP	R5
	RET

; **********************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************
teclado:
; inicializa��es
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH	R9	
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; corpo principal do programa
ciclo:
    MOV R0, 1          ; incializa o R1 a zero
    MOV R1, 0          ;
    MOV R6, R1         ; escreve coluna a zero
    MOV R7, R1         ; escreve calculo posição linha a zero
    MOV R8, R1         ; escreve caluclo posição coluna a zero
    MOV R9, 8          ; para comparar com R0

espera_tecla:          ; neste ciclo espera-se at� uma tecla ser premida
    MOVB [R2],R0       ; ler pertiferico de saída (linhas)
    MOVB R1, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R1, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R1, 0         ; h� tecla premida?
    MOV R6,R0          ; para poder verificar se a tecla ainda está pressionada
    JNZ  calcula_col   ; tecla premida começa a calcular qual foi premida
    CMP R0,R9          ; verifica se já chegou ao valor 8
    JZ reiniciar_linha ; vai reiniciar o valor da linha para 1
    SHL R0,1           ; passa para a próxima linha
    JMP espera_tecla   ; se nenhuma tecla premida repete

reiniciar_linha:
    MOV R0,1               ;volta a colocar o valor para a primeira coluna
    JMP espera_tecla   ;volta para o loop a espera de uma tecla ser pressionada

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
	POP	R9
	POP	R8
	POP	R7
	POP	R6
	POP	R5
	POP	R3
	POP	R2
	POP	R1
	RET	

