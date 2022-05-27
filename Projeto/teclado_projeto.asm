; *********************************************************************
; * IST-UL
; * Modulo:    lab3.asm
; * Descri��o: Exemplifica o acesso a um teclado.
; *            L� uma linha do teclado, verificando se h� alguma tecla
; *            premida nessa linha.
; *
; * Nota: Observe a forma como se acede aos perif�ricos de 8 bits
; *       atrav�s da instru��o MOVB
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
; ATEN��O: constantes hexadecimais que comecem por uma letra devem ter 0 antes.
;          Isto n�o altera o valor de 16 bits e permite distinguir n�meros de identificadores
DISPLAYS   EQU 0A000H  ; endere�o dos displays de 7 segmentos (perif�rico POUT-1)
TEC_LIN    EQU 0C000H  ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL    EQU 0E000H  ; endere�o das colunas do teclado (perif�rico PIN)
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
ESQUERDA   EQU 0000    ; comparar e mover a nave para a esquerda
CIMA       EQU 0001    ; comparar e mover a nave para cima
BAIXO      EQU 0010    ; comparar e mover a nave para baixo
DIREITA    EQU 0011    ; comparar e mover a nave para a direita

; **********************************************************************
; * C�digo
; **********************************************************************
PLACE      0
inicio:		
; inicializa��es
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R4, DISPLAYS  ; endere�o do perif�rico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; corpo principal do programa
ciclo:
    MOV R0, 1          ; incializa o R1 a zero
    MOV R1, 0          ;
    MOV R6, R1         ; escreve coluna a zero
    MOV R7, R1         ; escreve calculo posição linha a zero
    MOV R8, R1         ; escreve caluclo posição coluna a zero
    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays
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
    MOVB [R4],R8       ; escreve a tecla pressionada no display
    MOV R0,R8          ; saber que tecla foi pressionada

    
ha_tecla:              ; neste ciclo espera-se at� NENHUMA tecla estar premida     ; escrever no perif�rico de sa�da (linhas)
    MOVB [R2],R6       ; ler pertiferico de saída (linhas)
    MOVB R1, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R1, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R1, 0         ; h� tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera at� n�o haver
    JMP  ciclo         ; repete ciclo

