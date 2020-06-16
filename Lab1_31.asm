;RAHMEN.asm, Oliver Lindemann, u33873, Informatik, 08.06.2020
;Praktikum 1, Aufgabe 3.1
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
   
	  	
		MOV AX,0AA55h				; AA55h in AX laden
		; AX (Wert AA55h) in alle anderen Register kopieren
		MOV BX,AX					; AA55h aus AX in BX kopieren
		MOV CX,AX					; AA55h aus AX in CX kopieren
		MOV DX,AX					; AA55h aus AX in DX kopieren
		MOV SI,AX					; AA55h aus AX in SI kopieren
		MOV DI,AX					; AA55h aus AX in DI kopieren


;---------------------------------------Ende eigener Code-----------------------------------------

        	mov ah,4ch		    		;Funktion 4ch fuer int21h vorbereiten
        	int 21h						;beendet das Programm und gibt die Kontrolle an das Betriebssystem zurueck
prog_seg ends
end start

