; programme de test pour le modulo et les routines d'i/o

        include macro.lib

; Segment de pile
pile    segment stack
        dw      100h dup(?)
pile    ends

; Segment de donnees
donnees segment public
nb      dw      ?                   ; Parametre de todec et tidec
Texte1  db      "Donnez le premier nombre : $"
Texte2  db      "Donnez le second nombre  : $"
TexteR  db      "Le modulo du premier par le second donne $"
donnees ends

; Segment de code
code    segment public

        assume  cs:code

        extrn   todec:far, tidec:far

        include mod.asm             ; Inclusion de la routine de multiplication

debut   label   far

        mov     ax,donnees          ; Mise en place des registres de segment
        mov     ds,ax
        assume  cs:code, ds:donnees, ss:pile, es:nothing

; On rentre le premier nombre
        print   texte1
        push    ds                  ; Prepare le parametre
        mov     ax,offset nb
        push    ax
        call    tidec
        crlf
        mov     dx,nb               ; On met dans DX le premier nombre

; On rentre le second
        print   Texte2
        push    ds                  ; Prepare le parametre
        mov     ax,offset nb
        push    ax
        call    tidec
        crlf
        mov     bx,nb               ; On met dans AX le second nombre

; On effectue la division
        mov     ax,dx
        mov     dx,0
        call    modulo              ; reste de DX|AX par BX

; On affiche le resultat
        mov     nb,ax
        print   TexteR
        push    ds                  ; Prepare le parametre
        mov     ax,offset nb
        push    ax
        call    todec
        crlf

fin:    mov     ax,4c00h            ; Fonction de terminaison du programme
        int     21h

code    ends

        end     debut               ; Le debut du programme = adresse "debut"
