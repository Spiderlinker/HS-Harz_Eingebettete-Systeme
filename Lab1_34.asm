;RAHMEN.asm, Oliver Lindemann, u33873, Informatik, 08.06.2020
;Praktikum 1, Aufgabe 3.4
;-------------------------------------------------------------------------------------------------
stack_seg segment para stack 'stack'	;Stacksegment
        	db 100 dup(66h)				;initialisiere 100 Byte mit Inhalt 66h, Stacklänge 100 Byte
stack_seg ends
;-------------------------------------------------------------------------------------------------
data_seg segment 'data'					;Datensegment
	   	bytezaehler db 100   			;definiert ein Byte mit dem Namen "bytezaehler" mit dem Wert 100 dez.	
	   	wordmerker dw 3FFFh  			;definiert ein Word mit dem Namen "wordmerker" mit dem Wert 3FFFh 
	   	ausgabe db '1 . B I L D S C H I R M A U S G A B E '	;definiert die Ausgabe '1. Bildschirmausgabe'
data_seg ends
;-------------------------------------------------------------------------------------------------
prog_seg segment 'prog'					;Programmsegment
assume 	cs:prog_seg, ds:data_seg, ss:stack_seg

;-------------------------------------------------------------------------------------------------
start:  	mov ax,data_seg 	   		;Datensegmentadresse nach AX laden 
        	mov ds,ax		   			;Datensegmentadresse in Datensegmentregister DX laden

;--------------------------------------Beginn eigener Code----------------------------------------	   

		MOV SI,offset ausgabe		; Zeichenkette 'ausgabe' in SI laden
		MOV AX,0B800H				; Bildwiederholspeicher addressieren
		MOV ES,AX	
		MOV DI,0H					; Offset angeben
		CLD		
		; Bildschirmausgabe vorbereiten
		MOV CX,40					; Zeichenkette 'ausgabe' ist 40 (20 Zeichen + 20 Leerzeichen für Farbcodierung) Zeichen lang
		REP MOVSB					; Alle Zeichen in Bildschirmspeicher schreiben (so oft, wie in CX angegeben)


;---------------------------------------Ende eigener Code-----------------------------------------

        	mov ah,4ch		    		;Funktion 4ch fuer int21h vorbereiten
        	int 21h						;beendet das Programm und gibt die Kontrolle an das Betriebssystem zurueck
prog_seg ends
end start

