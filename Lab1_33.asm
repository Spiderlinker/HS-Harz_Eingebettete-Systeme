;RAHMEN.asm, Oliver Lindemann, u33873, Informatik, 08.06.2020
;Praktikum 1, Aufgabe 3.3
;-------------------------------------------------------------------------------------------------
stack_seg segment para stack 'stack'	;Stacksegment
        	db 100 dup(66h)				;initialisiere 100 Byte mit Inhalt 66h, Stacklänge 100 Byte
stack_seg ends
;-------------------------------------------------------------------------------------------------
data_seg segment 'data'					;Datensegment
	   	bytezaehler db 100   			;definiert ein Byte mit dem Namen "bytezaehler" mit dem Wert 100 dez.	
	   	wordmerker dw 3FFFh  			;definiert ein Word mit dem Namen "wordmerker" mit dem Wert 3FFFh 
	   	bytestring db 'Hallo'			;definiert eine Folge von Bytes
data_seg ends
;-------------------------------------------------------------------------------------------------
prog_seg segment 'prog'					;Programmsegment
assume 	cs:prog_seg, ds:data_seg, ss:stack_seg

;-------------------------------------------------------------------------------------------------
start:  	mov ax,data_seg 	   		;Datensegmentadresse nach AX laden 
        	mov ds,ax		   			;Datensegmentadresse in Datensegmentregister DX laden

;--------------------------------------Beginn eigener Code----------------------------------------	   


		; ---------------------------------
		; a) Rechenoperation: 00FFh + 1FFh	
		; ---------------------------------  	
		MOV AX,00FFh				; 1. Wert für Addition in AX laden
		MOV BX,01FFh				; 2. Wert für Addition in BX laden
		ADD AX,BX					; AX und BX addieren

		; Ergebnis von 00FFh + 1FFh = 02FE
		; ---------------------------------

; ################################################################

		; ---------------------------------
		; b) Rechenoperation: 375Fh - 13CDh	  
		; ---------------------------------	
		MOV AX,375Fh 				; 1. Wert für Subtraktion in AX laden
		MOV BX,13CDh				; 2. Wert für Subtraktion in BX laden
		SUB AX,BX					; BX von AX subtrahieren

		; Ergebnis von 375Fh - 13CDh = 2392
		; ---------------------------------

; ################################################################
		
		; ---------------------------------
		; c) 1. Rechenoperation: 0FFFFH * 7FFFH	 (vorzeichenlos) 
		; ---------------------------------
		MOV AX,0FFFFH 				; 1. Wert für Mulitplikation in AX laden
		MOV BX,7FFFH				; 2. Wert für Multiplikation in BX laden
		MUL BX					; BX mit AX multiplizieren

		; Ergebnis von 0FFFFH * 7FFFH = 7FFE8001
		; der erste Teil steht in DX, der zweite Teil in AX
		; ---------------------------------

; ################################################################
		
		; ---------------------------------
		; c) 2. Rechenoperation: 0FFFFH * 7FFFH	 (vorzeichenbehaftet) 
		; ---------------------------------
		MOV AX,0FFFFH  			; 1. Wert für Mulitplikation in AX laden
		MOV BX,7FFFH				; 2. Wert für Multiplikation in BX laden
		IMUL BX					; BX mit AX multiplizieren

		; Ergebnis von 0FFFFH * 7FFFH = FFFF8001
		; der erste Teil steht in DX, der zweite Teil in AX
		; ---------------------------------

; ################################################################
		
		; ---------------------------------
		; d) 1. Rechenoperation: 933CH : 57H	(vorzeichenlos)
		; ---------------------------------
		MOV DX,0  				; Ergebnis von vorheriger Multiplikation aus DX löschen
		MOV AX,933CH 				; 1. Wert für Division in AX laden
		MOV BX,57H				; 2. Wert für Division in BX laden
		DIV BX					; AX durch BX teilen

		; Ergebnis von 933CH : 57H = 1B1
		; ---------------------------------

; ################################################################
		
		; ---------------------------------
		; d) 2. Rechenoperation: 933CH : 57H	(vorzeichenbehaftet)
		; ---------------------------------
		MOV DX,0  				; Ergebnis von vorheriger Division aus DX löschen  	
		MOV AX,933CH 				; 1. Wert für Division in AX laden
		MOV BX,57H				; 2. Wert für Division in BX laden
		IDIV BX					; Ergebnis: 1B1

		; Ergebnis von 933CH : 57H = 1B1
		; ---------------------------------

; ################################################################
		
		; ---------------------------------
		; e) Rechenoperation BCD: 2739H + 4583H
		; ---------------------------------  	
		MOV AX,2739H 
		MOV BX,4583H
		ADD AL,BL		; AL und BL zusammenaddieren
		DAA
		MOV DL,AL		; Ergebnis aus AL in DL speichern
		MOV AL,AH		; AH in AL bewegen
		ADC AL,BH		; AL und BH zusammenaddieren (ursprünglich verbleibende AH und BH)
		DAA
		MOV DH,AL		; Ergebnis jetzt komplett in DX

		; Ergebnis von BCD: 2739H + 4583H = 7322H
		; ---------------------------------

					




;---------------------------------------Ende eigener Code-----------------------------------------

        	mov ah,4ch		    		;Funktion 4ch fuer int21h vorbereiten
        	int 21h						;beendet das Programm und gibt die Kontrolle an das Betriebssystem zurueck
prog_seg ends
end start

