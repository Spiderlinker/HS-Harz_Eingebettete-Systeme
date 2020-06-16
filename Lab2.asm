;RAHMEN2.asm, Oliver Lindemann, u33873, I18, 15.06.2020
;Praktikum 2
;-------------------------------------------------------------------------------------------------
stack_seg segment para stack 'stack'    ;Stacksegment
        db 100 dup(66h)			    ;initialisiere 100 Byte mit Inhalt 66h, Stacklänge 100 Byte
stack_seg ends
;-------------------------------------------------------------------------------------------------
data_seg segment 'data'                 ; Datensegment
        messreihe1 		 db 0F0h,0F0h,0Ch,18h,24h,30h,3Ch,48h,54h,60h
            			 db  6Ch,78h,84h,90h,9Ch,0A8h,0B3h,0C0h,0CCh,0D8h
        messreihe2 		 db 0F0h,0F0h,0Ch,18h,24h,30h,3Ch,48h,54h,60h
            			 db  6Ch,78h,84h,90h,9Ch,0A8h,0B3h,0C6h,0D2h,0DEh
        startoffset		 dw 1111h 
	  anzahl	    	 	 dw 2222h
	  gueltigewerte 		 db 20 dup(33h)
	  mittelwert		 db 44h
        skaliertewerte       	 db 20 dup(55h)
	  sinuswerte 	 	 db 20 dup(66h)
        sinusliste	       db 00,07,14,21,27,34,40,46,51,57,61,66,69,73,75,77,79
               		       db 80,80,80,79,77,75,73,69,66,61,57,51,46,40,34,27,21
					 db 14,07,00

data_seg ends

;-------------------------------------------------------------------------------------------------
prog_seg segment 'prog'				;Programmsegment
assume cs:prog_seg, ds:data_seg, ss:stack_seg

start:   mov ax,data_seg 	   	; Datensegmentadresse nach AX laden 
         mov ds,ax		   	; Datensegmentadresse in Datensegmentregister DX laden

;--------------------------------------Beginn eigener Code----------------------------------------

		NOP					; -- Suchen der gültigen Werte (ungleich 0F0h)
		MOV ES,AX				; ES auf gleiche Adresse wie DS
		PUSH AX				; Adresse zusätzlich sichern auf Stack
		MOV CX,20				; Zähler (max.)
		LEA DI, messreihe1		; Adresse der Werte bestimmen
		MOV AL, 0F0h			; Vergleichswert laden
		REPZ SCASB			; Vergleich durchführen bis Werte verschieden sind von 0F0h sind

		INC CX				; CX um 1 inkrementieren, da von Vergleich einmal zuviel dekrementiert
		DEC DI				; DI (Startoffset) um 1 dekrementieren, da von Vergleich einmal zuviel inkrementiert
		MOV startoffset,DI		; Startoffset in Variable laden
		
		NOP					; -- Messwerte beider Messreihen vergleichen		

		LEA DI, messreihe1		; Offset für Messreihe 1 setzen
		ADD DI, startoffset

		MOV AX,data_seg		; Messreihe 2 laden vorbereiten
		MOV DS,AX				; Messreihe 2 laden
		LEA SI, messreihe2		; Offset für Messreihe 2 setzen							
		ADD SI, startoffset

		REPZ CMPSB			; Vergleich der beiden Messreihen bis zur ersten Ungleichheit

		DEC DI				; Inkrement des Vergleichs rueckgaengig machen
		SUB DI,startoffset		; Startoffset von der Anzahl abziehen
		MOV anzahl,DI			; Errechneter Wert aus Di in anzahl speichern
		
		MOV BX, anzahl			; Anzahl gueltiger Werte speichern

		NOP					; -- Gueltige Messwerte kopieren

		; Datensegment ist schon in ES geladen
		LEA DI, gueltigeWerte	; Offset von gueltigeWerte setzen

		; Datensegment ist schon in DS geladen
		LEA SI, messreihe1		; Messreihe 1 laden					
		ADD SI, startoffset		; Offset für Messreihe 1 setzen	

		MOV CX,anzahl			; Anzahl der gueltigen Messwerte zum Kopieren setzen
		REP MOVSB				; Gueltige Werte CX-mal kopieren (anzahl)

		; In 'gueltigeWerte' sind nun Werte von 0Ch bis 0B3h

		NOP					; #### Aufgabe 2
		
		LEA SI,gueltigewerte	; gueltigeWerte laden
		MOV CX,anzahl			; Anzahl der Schleifendurchgaenge setzen
		MOV BX,0				; BX auf 0 setzen, BX soll Summe aller gueltigen Werte enthalten
		MOV AX,0				; AX auf 0 setzen, AX soll aktuell geladenen gueltigen Wert laden
mittw:	LODSB				; naechsten gueltigen Wert holen
		ADD BX,AX				; aktuell gueltigen Wert auf BX aufaddieren
		DEC CX				; Counter dekrementieren
		JNZ mittw				; Wenn counter (CX) != 0 -> naechster Schleifendurchlauf

		; Mittelwert bilden
		MOV AX,BX				; Zu teilenden Wert in AX schreiben
		MOV BX,anzahl			; Dividend in BL schreiben
		DIV BX				; Dividieren
		MOV mittelwert,AL		; Ergebnis von AX nach mittelwert laden		
				
		NOP					; #### Aufgabe 3

		LEA SI,gueltigewerte	; gueltigeWerte laden
		LEA DI,skaliertewerte	; skalierteWerte laden
		MOV CX,anzahl			; Anzahl der Schleifendurchgaenge setzen
		MOV BX,5				; BX auf 5 setzen, Mit diesem Wert sollen alle gueltigen Winkelwerte dividiert werden
		MOV AX,0				; AX auf 0 setzen, AX soll aktuell geladenen gueltigen Wert laden
skal:	LODSB				; naechsten gueltigen Wert holen und in AL speichern
		DIV BL				; AX durch BX (5) dividieren
		STOSB				; Skalierten Wert in skalierteWert schreiben
		MOV AH,0				; AH zuruecksetzen
		DEC CX				; Counter dekrementieren
		JNZ skal				; Wenn counter (CX) != 0 -> naechster Schleifendurchlauf

		NOP					; #### Aufgabe 4

		LEA SI,skaliertewerte	; skalierteWerte laden
		LEA DI,sinuswerte		; sinuswerte laden
		MOV CX,anzahl			; Anzahl der Schleifendurchgaenge setzen
		MOV AX,0				; AX auf 0 setzen, AX soll aktuell geladenen skalierten Wert laden
		LEA BX,sinusliste		; Adress von Sinusliste in BX laden für XLAT
sin:		LODSB				; naechsten gueltigen Wert holen und in AL speichern
		XLAT
		STOSB				; Skalierten Wert in skalierteWert schreiben
		DEC CX				; Counter dekrementieren
		JNZ sin				; Wenn counter (CX) != 0 -> naechster Schleifendurchlauf

		NOP					; #### Aufgabe 5

		; Ausgabe vorbereiten
		MOV AX,0b800h			; Bildschirmspeicheradresse laden
		MOV ES,AX				; Bildschirmspeicheradresse in ES laden
		MOV DI, 160			; Offset angeben, Bildschirmbreite: 80 * 2 Bytes, In zweiter Zeile anfangen = 2*80 = 160

		LEA SI,sinuswerte		; Sinuswerte laden
		MOV CX,anzahl			; Anzahl der Schleifendurchgaenge setze
		MOV AX,0				; AX auf 0 setzen, AX soll aktuell geladenen Sinuswert laden
		
print:	LODSB				; naechsten Sinuswert holen und in AL speichern
		; Sinuswert holen, Anzahl an innerer Schleifendurchlaeufe	
		PUSH CX				; Counter der 'ausseren Schleife' auf den Stack sichern	
		MOV CX,AX				; Sinuswert in CX laden fuer Anzahl innerer Schleifendurchlaeufe
		PUSH AX				; Geladenen Sinuswert auf den Stack sichern

		; -- Lila Balken ausgeben
		MOV AH,5				; Farbe fuer die Ausgabe waehlen (5 = Magenta)
		MOV AL,219			; Symbol, das ausgegeben werden soll (Block) waehlen
		REPE STOSW			; Symbol mit Farbe auf den Bildschirm CX-mal schreiben

		; -- Bildschirm mit schwarzen Balken auffuellen
		POP AX				; Zuvor geladenen Sinuswert von Stack holen (Anzahl der ausgegebenen Zeichen)
		MOV CX, 80			; Bildschirm ist 80 breit, verbleibende Bildschirmbreite mit schwarzen Balken ausfuellen
		SUB CX,AX				; Anzahl verbleibender Balken berechnen (80 - Anzahl ausgegebener Zeichen)
		
		MOV AH,0				; Farbe fuer restliche Balken auswaehlen (0 = Schwarz)
		REPE STOSW			; Schwarze Balken ausgeben und somit Bildschirm bis Ende auffuellen
	
		; Auessere Schleife - Bedingung
		POP CX				; Zaehler der aeusseren Schleife vom Stack holen
		DEC CX				; Counter dekrementieren
		JNZ print				; Wenn counter (CX) != 0 -> naechster Schleifendurchlauf
		

;---------------------------------------Ende eigener Code-----------------------------------------

        mov ah,4ch		    	; Funktion 4ch für int21h vorbereiten
        int 21h			; beendet das Programm und gibt die Kontrolle an das Betriebssystem zurück
prog_seg ends
end start

