; Mit Bildschirmspeicher arbeiten:
; Bildschirmspeicher liegt an Adresse B800H, dann muss noch ein Offset angegeben werden, wo der Cursor positioniert werden soll
; Oberer linker Rand ist somit B800H:0H (kein Offset bzw. Offset = 0H)
; Diese Adresse muss in ES:DI geladen werden, ES = Bildschirmspeicheradresse, DI = Offset
MOV AX,0B800h       ; ES kann nicht direkt beschrieben werden, sondern nur über ein Register
MOV ES, AX          ; Von AX nach ES laden
MOV DI,0            ; Offset angeben
; Damit man in der zweiten Zeile anfangen kann, muss die Bildschirmbreit ermittelt werden. Bei DosBox beträgt dieser 80.
; Jedes Pixel ist 2 Byte groß, sprich 80 Pixel * 2 Byte.
; Anfang der zweiten Zeile ist damit 80 * 2 = 160;
; Dann würde 'MOV DI, 160'


; Ausgabe eines Zeichens:
; Es soll nur ein Zeichen und keine Zeichenkette ausgegeben werden
; AL: Zeichen, das ausgegeben werden soll
; AH: Angabe der Farbe des Zeichens
MOV AL, 219     ; Balken soll ausgegeben werden 219 = █ (http://www.asciitable.com/)
MOV AH, 5       ; Farbe: Zeichen soll lila sein 5 = Lila (http://www.shikadi.net/moddingwiki/B800_Text)
STOSW           ; Word (2Byte) ausgeben (kein Byte STOSB), da hier Zeichen und Farbe ausgegeben werden sollen 

; Wenn das Zeichen mehrfach ausgegeben werden soll: REPE mit CX benutzen
; REPE wiederholt STOSW so oft, wie in CX angegeben
MOV CX, 15      ; 15x Zeichen ausgeben (Anzahl)
REPE STOSW      ; Zeichen wiederholt ausgeben, REPE verringert CX bis 0


; Zeichenkette ausgeben
; Im Datensegment den String definieren
String db 'Hello world!'    ; String für die Ausgabe
; Die Zeichenkette über SI adressieren
LEA SI, String              ; String in SI laden
MOV AH, 5                   ; Farbe für die Ausgabe laden
MOV CX, 12                  ; Anzahl der Zeichen des Strings angeben (12 in diesem Fall)
; Schleife für die Ausgabe des kompletten Strings
print:  LODSB               ; Nächstes Zeichen in AL laden
        STOSW               ; Zeichen + Farbe in Bildschirm schreiben
        DEC CX              ; Ein Zeichen geschrieben, Counter dekrementieren
        JNZ print           ; Solange CX noch nicht 0 ist, zurück zum Anfang der Schleife


; Ausgabe mittels Interrupt 21h
; Ausgabe eines einzelnen Zeichns mittels Interrupt 21h
; Der Interrupt 21h muss vorbereitet werden. Vom Interrupt 21h gibt es verschiedene Versionen, die über das Register AH angegeben werden
; Die Ausgabe eines einzelnen Zeichens wird über das Setzen von AH = 02h realisiert
; Der Interrupt liest dann das Register DL aus und schreibt dieses auf die Konsole
MOV AH, 02h     ; Interrupt sagen, dass nur ein Zeichen geschrieben wird
MOV DL, 219     ; Auszugebenes Zeichen laden (219 = █)
INT 21h         ; Interrupt auslösen

; Ausgabe eines Strings mittels Interrupt 21h
; Die Ausgabe einer kompletten Zeichenkette wird über das Setzen von AH = 09h realisiert
; Der Interrupt liest dann den über DX angegebenen String (Speicheradresse) bis zum ersten $ aus und schreibt alles auf die Konsole
; String im Datensegment definieren
String db 'Hello world!$'   ; Satz, der ausgegeben werden soll. $ gibt das Ende des Strings an
...
MOV AH, 09h                 ; Interrupt mitteilen, dass der gesamter String bis $ soll ausgegeben werden 
MOV DX, offset String       ; Daten für den Interrupt laden
INT 21h                     ; Interrupt auslösen

