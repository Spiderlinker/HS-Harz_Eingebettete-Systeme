;RAHMEN.asm, Oliver Lindemann, u33873, Informatik, 08.06.2020
;Praktikum 1, Aufgabe 3.5
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


		; Debugger-Bildschirmausgabe vorbereiten
		LEA DI,ES:0H

		; Bildschirmausgabe Interrupt vorbereiten (Int 21h:02h)
		MOV AH,02H

		; Zeichen definieren, mit dessen Ausgabe begonnen werden soll
		MOV AL,20H		; Anfangszeichen laden 20H
	
		; Schleife zur Ausgabe von Zeichen 20H - 7EH
schlei:	MOV CX,1			; REP STOSB vorbereiten, soll nur 1 Zeichen ausgeben
		REP STOSB			; Zeichen aus AL ausgeben

		; Bildschirmausgabe vorbereiten
		MOV DL,AL			; Auszugebenes Zeichen in DL laden für Bildschirmausgabe
		INT 21h			; Int21:02H gibt DL auf Bildschirm aus

		; Nächstes Zeichen vorbereiten
		INC AL; 			; Zeichen inkrementieren	
	
		; Schleifenbedingung vorbereiten
		MOV CL, 7EH		; maximal bis 7EH ausgeben
		CMP CL, AL		; 7EH mit aktuellem Wert aus BL vergleichen
				
		JAE schlei		; Solange BL nicht 7EH erreicht hat, wieder zum Anfang springen





;---------------------------------------Ende eigener Code-----------------------------------------

        	mov ah,4ch		    		;Funktion 4ch fuer int21h vorbereiten
        	int 21h						;beendet das Programm und gibt die Kontrolle an das Betriebssystem zurueck
prog_seg ends
end start

