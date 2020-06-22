;RAHMEN.asm, Oliver Lindemann, u33873, Informatik, 22.06.2020
;Praktikum 3, Aufgabe 1
;-------------------------------------------------------------------------------------------------
stack_seg segment para stack 'stack'    ;Stacksegment
            db 100 dup(66h)             ;initialisiere 100 Byte mit Inhalt 66h, Stacklänge 100 Byte
stack_seg ends
;-------------------------------------------------------------------------------------------------
data_seg segment 'data'                 ;Datensegment
        datei db 'C:\text3.txt',00h     ;Dateipfad der Datei, die eingelesen werden soll.
        handle dw 3333h                 ; Dateihandle beim Oeffnen der Datei erhalten
        anzahl dw 4444h                 ; Anzahl gelesener Bytes
        inhalt db 1024 dup('$')          ;Reservierter Speicher für Inhalt der Datei
        converted db 1024 dup('$')       ; Konvertierter Inhalt der Datei

data_seg ends
;-------------------------------------------------------------------------------------------------
prog_seg segment 'prog'                 ;Programmsegment
assume 	cs:prog_seg, ds:data_seg, ss:stack_seg

;-------------------------------------------------------------------------------------------------
start:      mov ax,data_seg             ;Datensegmentadresse nach AX laden 
            mov ds,ax                   ;Datensegmentadresse in Datensegmentregister DX laden

;--------------------------------------Beginn eigener Code----------------------------------------	   

        NOP	                    ; ## Aufgabe 1

; -- Alternative mit 40h / 42h - Start
;        MOV AH,3Ch              ; Create Handle
;        LEA DX,datei            ; Dateipfad angeben
;        MOV CX,0                ; Read only
;        INT 21h                 ; Interrupt ausloesen, Handle erzeugen

;        MOV handle,AX           ; Handle-Nummer speichern
;        
;        MOV AH,42h              ; Open-Handle
;        MOV BX,handle           ; Handle-Nummer in BX fuer weitere Interrupts speichern
;        MOV AL,0                ; Nur lesen
;        INT 21h                 ; Interrupt ausloesen, Handle oeffnen
; -- Alternative - Ende


        ; -- Datei oeffnen
        MOV AH,3dh              ; Open-Handle (Acess-Code)
        MOV AL,0                ; Open as read only
        LEA DX,datei            ; Dateipfad laden
        INT 21h                 ; Interrupt zum Oeffnen durchfuehren
        MOV handle,AX           ; Handle-Nummer in 'dateihandle' speichern

        ; -- Datei lesen
        MOV AH,3Fh
        MOV BX,handle           ; Handle(nummer) vom Oeffnen angeben
        MOV CX,1024             ; Anzahl zu lesender Zeichen angeben
        LEA DX,inhalt           ; Speicherort der gelesenen Zeichen angeben
        INT 21h                 ; Datei lesen

        MOV anzahl,AX           ; Anzahl gelesener Bytes aus AX in anzahl speichern

        ; -- Datei schliessen
        MOV AH,3Eh              ; 3Eh - Code zum Schließen der Datei mit Interrupt 21h
        MOV BX,handle 		; Handle(nummer) angeben, die geschlossen werden soll
        INT 21h                 ; Datei schliessen	

        NOP                     ; ## Aufgabe 2

        MOV AX,data_seg         ; Laden von Datensegment vorbereiten
        MOV ES,AX               ; Datensegment in ES laden
        LEA DI,converted        ; Reservierter Speicher 'converted' laden

        ; Anzahl: Bytes in Words umwandeln
        MOV AX,anzahl           ; Anzahl geladener Bytes laden
        MOV BL,2                ; Divisor laden (2)
        DIV BL                  ; AX durch 2 teilen (Anzahl Bytes durch 2 teilen -> Anzahl Words)
        MOV CX,AX               ; Anzahl Words in CX laden, CX wird Counter von Schleife werden

        LEA SI,inhalt           ; Inhalt adressieren
        MOV BX,0                ; BX leeren, Wird fuer Zwischenspeicherungen benoetigt
        MOV AX,0                ; AX leeren, In AX wird der aktuelle Wert geladen aus adressierter Adresse
convert:    LODSW               ; naechstes Word laden

        ; AL und AH tauschen
        MOV BL,AL               ; AL in BL zwischenspeichern
        MOV AL,AH               ; AH in AL speichern
        MOV AH,BL               ; Zwischengespeichertes AL aus BL in AH speichern

        STOSW                   ; Vertauschtes Word (AX, AH -> AL, AL -> AH) in 'converted' speichern

        DEC CX                  ; Counter dekrementieren
        JNZ convert             ; Wenn counter (CX) != 0 -> naechster Schleifendurchlauf	

        NOP                     ; ## Aufgabe 3

        LEA SI,inhalt           ; Inhalt adressieren
        MOV CX,anzahl           ; Laenge der zu untersuchenden Zeichenkette
        MOV BX,0                ; BX soll hoechsten Byte-Wert enthalten
        MOV AX,0                ; AX leeren, In AX wird der aktuelle Wert geladen aus adressierter Adresse
max:    LODSB                   ; naechstes Byte laden

        CMP AX,BX               ; AX mit BX vergleichen (Ist AX = BX?)
        JBE belowEq             ; Falls AX kleiner gleich BX ist (AX <= BX), dann ueberspringe Zuweisung von BX = AX und gehe weiter zur Schleifenbedingung

        ; Neuer hoechster Wert gefunden, speichern
        MOV BX,AX               ; Kein Sprung, AX ist groesser als aktuelles BX, weise BX aktuellen AX-Wert zu

; Sprungmarke, falls AX kleiner gleich des aktuell hoechsten Wertes ist
belowEq:    DEC CX              ; Counter dekrementieren
        JNZ max                 ; Wenn counter (CX) != 0 -> naechster Schleifendurchlauf	

        PUSH BX                 ; Hoechsten Wert auf Stack sichern

        NOP                     ; ## Aufgabe 4

        MOV DH,9                ; Zeile des Cursors setzen
        MOV DL,25               ; Spalte des Cursors setzen
        MOV AH,2                ; Interrupt vorbereiten -> Cursor setzen
        INT 10h                 ; Interrupt ausloesen und Cursor auf Position Zeile:9,Spalte:25 setzen

        NOP                     ; ## Aufgabe 5

        MOV AH, 09h             ; Interrupt mitteilen, dass der gesamter String bis $ soll ausgegeben werden 
        MOV DX, offset converted; Daten für den Interrupt laden
        INT 21h                 ; Interrupt auslösen

;---------------------------------------Ende eigener Code-----------------------------------------

            mov ah,4ch           ; Funktion 4ch fuer int21h vorbereiten
            int 21h              ; beendet das Programm und gibt die Kontrolle an das Betriebssystem zurueck
prog_seg ends
end start
