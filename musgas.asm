.data

	#-----TEMPOS-----
	#semibreve: 	1500 ms
	#minima:	750 ms
	#semiminima:	375 ms
	#colcheia:	187 ms
	#semicolcheia: 	94 ms
	#fusa:		47 ms
	#semifusa:	24 ms (morre aq)

	nomeArquivo: .asciiz "arquivo.txt"

	inicial: .asciiz "C partitura(Sol,4/4)\n" #primeira linha

	#Figuras musicais
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
	identacao: .asciiz "\t"

	numUm: .asciiz "1"
	numDois: .asciiz "2"
	numTres: .asciiz "3"


	#Acordes:
	acoZ: .asciiz "C"
	acoS: .asciiz "C#"
	acoX: .asciiz "D"
	acoD: .asciiz "D#"
	acoC: .asciiz "E"
	acoV: .asciiz "F"
	acoG: .asciiz "F#"
	acoB: .asciiz "G"
	acoH: .asciiz "G#"
	acoN: .asciiz "A"
	acoJ: .asciiz "A#"
	acoM: .asciiz "B"
	acoVirgula: .asciiz "C"

.text


	# z - c3
	# s - c#3
	# x - d3
	# d - d#3
	# c - e3
	# v - f3
	# g - f#3
	# b - g3
	# h - g#3
	# n - a3
	# j - a#3
	# m - b3
	# , - c4
	# q - c4
	# 2 - c#4
	# w - d4
	# 3 - d#4
	# e - e4
	# r - f4
	# 5 - f#4
	# t - g4
	# 6 - g#4
	# y - a4
	# 7 - a#4
	# u - b4
	# i - c5


	j main

#######################################################################################################################



#######################################################################################################################




#######################################################################################################################

	set_key:

		# salva o valor de $ra e zera o contador de loops
		add $t7, $zero, $ra
		add $t6, $zero, $zero

		#salva argumentos na pilha
		addi $sp, $sp, -12

		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)


		#$t9 é a ultima tecla pressionada
		#$t8 é a tecla atualmente pressionada
		#TODO: ver a espera da suscall para escrever duas notas seguidas de mesmo tom

		beq $t9, $t8, return_key

		#beq $t9, $zero, write_z
		#jal printEspaco


	primeiro:
		#cada loop tem cerca de 30 ms
		mul $t6, $t6, 30

		#faz aproximação e escreve o tempo da nota

		#TODO: fazer aproximação



		################################################################################

		beq $t9, $zero, write_z
		jal printColcheia

		#switch case
		write_z:
			bne $t9, 122, write_s
			jal printAcoZ
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_s:
			bne $t9, 115, write_x
			jal printAcoS
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_x:
			bne $t9, 120, write_d
			jal printAcoX
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_d:
			bne $t9, 100, write_c
			jal printAcoD
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_c:
			bne $t9, 99, write_v
			jal printAcoC
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_v:
			bne $t9, 118, write_g
			jal printAcoV
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_g:
			bne $t9, 103, write_b
			jal printAcoG
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_b:
			bne $t9, 98, write_h
			jal printAcoB
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_h:
			bne $t9, 104, write_n
			jal printAcoH
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_n:
			bne $t9, 110, write_j
			jal printAcoN
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_j:
			bne $t9, 106, write_m
			jal printAcoJ
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_m:
			bne $t9, 109, write_comma
			jal printAcoM
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_comma:
			bne $t9, 44, write_none_of_above
			jal printAcoVirgula
			beq $t8, 45, end_switch
			jal printEspaco
			j end_switch

		write_none_of_above:
			#



		end_switch:

		#verifica se é chave de fechar o programa
		beq $t8, 45, exit_at_all

		## salvar aargumentos na pilha talvez esteja custando mais do reescrever no loop
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		addi $sp, $sp, -12



		################################################################################



		#switch case
		check_z:
			bne $t8, 122, check_s
			add $a0, $zero, 48
			j put_key

		check_s:
			bne $t8, 115, check_x
			add $a0, $zero, 49
			j put_key

		check_x:
			bne $t8, 120, check_d
			add $a0, $zero, 50
			j put_key

		check_d:
			bne $t8, 100, check_c
			add $a0, $zero, 51
			j put_key

		check_c:
			bne $t8, 99, check_v
			add $a0, $zero, 52
			j put_key

		check_v:
			bne $t8, 118, check_g
			add $a0, $zero, 53
			j put_key

		check_g:
			bne $t8, 103, check_b
			add $a0, $zero, 54
			j put_key

		check_b:
			bne $t8, 98, check_h
			add $a0, $zero, 55
			j put_key

		check_h:
			bne $t8, 104, check_n
			add $a0, $zero, 56
			j put_key

		check_n:
			bne $t8, 110, check_j
			add $a0, $zero, 57
			j put_key

		check_j:
			bne $t8, 106, check_m
			add $a0, $zero, 58
			j put_key

		check_m:
			bne $t8, 109, check_comma
			add $a0, $zero, 59
			j put_key

		check_comma:
			bne $t8, 44, none_of_above
			add $a0, $zero, 60
			j put_key

		none_of_above:
			addi $a0, $zero, 0


		put_key:
			add $t9, $zero, $t8
		return_key:
			# salva o valor correto de $ra
			add $ra, $zero, $t7
			jr $ra


#######################################################################################################################


	main:

		#Abre arquivo
		addi $v0, $zero, 13	#13 = abre arquivo
		la $a0, nomeArquivo 	#noem do arquivo
		addi $a1, $zero, 9 	#0(read only);1(write only);9(append)
		add $a2, $zero, $zero 	#ignora
		syscall
		add $s0, $zero, $v0 	#salva o file descriptor

		add $t9, $zero, $zero

		jal printInicial
		jal printIdentacao

		addi $a0, $zero, 63
		addi $a1, $zero, 550
		addi $a2, $zero, 88
		addi $a3, $zero, 80

#######################################################################################################################

	loop:
		addi $v0, $zero, 12
		syscall

		add $t8, $zero, $v0

		addi $t6, $t6, 1
		jal set_key

		#j exit_at_all

		addi $v0, $zero, 31
		syscall
		j loop


#######################################################################################################################


#----------------------------------------------------------
#------------PRINT DOS FIGURAS MUSICAIS E OUTROS-----------
#----------------------------------------------------------

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
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoS:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoS
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoX:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoX
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoD:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoD
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoC:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoC
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoV:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoV
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoG:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoG
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoB:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoB
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoH:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoH
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoN:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoN
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoJ:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoJ
		addi $a2, $zero, 2 	#numero de caracteres
		syscall
		jr $ra

printAcoM:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoM
		addi $a2, $zero, 1 	#numero de caracteres
		syscall
		jr $ra

printAcoVirgula:
		addi $v0, $zero, 15 	#Escreve em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoVirgula
		addi $a2, $zero, 3 	#numero de caracteres
		syscall
		jr $ra


#######################################################################################################################

exit_at_all:

	#fechar arquivo
	addi $v0, $zero, 16 	#16 = fecha arquivo
	add $a0, $zero, $s0
	syscall
