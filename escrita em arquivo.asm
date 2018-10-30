.data

	nomeArquivo: .asciiz "arquivo.txt"

	inicial: .asciiz "C partitura(Sol,4/4)\n" #primeira linha
	identacao: .asciiz "\t"
	semibreve: .asciiz "sb"
	minima: .asciiz "m"
	semiminima: .asciiz "sm"
	colcheia: .asciiz "c"
	semicolcheia: .asciiz "sc"
	fusa: .asciiz "f"
	semifusa: .asciiz "sf"
	sustenido: .asciiz "#"

	mais: .asciiz "+"
	espaco: .asciiz " "
	quebraLinha: .asciiz "\n"

	numUm: .asciiz "1"
	numDois: .asciiz "2"
	numTres: .asciiz "3"


	#Acordes:
	acoZ: .asciiz "c3"
	acoS: .asciiz "c#3"
	acoX: .asciiz "d3"
	acoD: .asciiz "d#3"
	acoC: .asciiz "e3"
	acoV: .asciiz "f3"
	acoG: .asciiz "f#3"
	acoB: .asciiz "g3"
	acoH: .asciiz "g#3"
	acoN: .asciiz "a3"
	acoJ: .asciiz "a#3"
	acoM: .asciiz "b3"
	acoVirgula: .asciiz "c4"


.text

	#Abre arquivo
	addi $v0, $zero, 13	#13 = abre arquivo
	la $a0, nomeArquivo 	#noem do arquivo
	addi $a1, $zero, 9 	#0(read only);1(write only);9(append)
	add $a2, $zero, $zero 	#ignora
	syscall
	add $s0, $zero, $v0 	#salva o file descriptor


	jal printInicial
	jal printIdentacao
	jal printSemicolcheia
	jal printAcoZ
	jal printMais
	jal printUm
	jal printEspaco
	jal printColcheia
	jal printAcoV
	jal printEspaco
	jal printFusa
	jal printAcoVirgula
	#scc3+1 cf3 fc4


	#fechar arquivo
	addi $v0, $zero, 16 	#16 = fecha arquivo
	add $a0, $zero, $s0
	syscall

	j end
	
	
	
#---------------------------------------
#------------PRINT DOS COISA------------
#---------------------------------------

printInicial:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, inicial
		addi $a2, $zero, 22 	#numero de caracteres
		syscall
		jr $ra

printIdentacao:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, identacao
		addi $a2, $zero, 1	#numero de caracteres
		syscall
		jr $ra

printQuebraLinha:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, quebraLinha
		addi $a2, $zero, 1	#numero de caracteres
		syscall
		jr $ra

printMais:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, mais
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printEspaco:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, espaco
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printUm:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, numUm
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printDois:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, numDois
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printTres:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, numTres
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra


printSemibreve:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, semibreve
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printMinima:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, minima
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printSemiminima:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, semiminima
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printColcheia:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, colcheia
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printSemicolcheia:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, semicolcheia
		addi $a2, $zero, 2	#numero de caracteres
		syscall
		jr $ra

printFusa:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, fusa
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printSemifusa:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, semifusa
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printSustenido:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, sustenido
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra


#-----------------------------------------
#-----------PRINT DOS ACORDES-------------
#-----------------------------------------


printAcoZ:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoZ
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoS:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoS
		addi $a2, $zero, 3 	#numero de caracteres
		syscall
		jr $ra

printAcoX:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoX
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoD:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoD
		addi $a2, $zero, 3 	#numero de caracteres
		syscall
		jr $ra

printAcoC:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoC
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoV:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoV
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoG:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoG
		addi $a2, $zero, 3 	#numero de caracteres
		syscall
		jr $ra

printAcoB:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoB
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoH:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoH
		addi $a2, $zero, 3 	#numero de caracteres
		syscall
		jr $ra

printAcoN:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoN
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoJ:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoJ
		addi $a2, $zero, 3 	#numero de caracteres
		syscall
		jr $ra

printAcoM:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoM
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoVirgula:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoVirgula
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra


end:
