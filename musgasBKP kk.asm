.data

	#-----TEMPOS------------------
	#fixo de 80 bpm
	#semibreve: 	1500 ms
	#minima:	750 ms
	#semiminima:	375 ms
	#colcheia:	187 ms
	#semicolcheia: 	94 ms
	#fusa:		47 ms
	#semifusa:	24 ms (morre aq)
	#-----------------------------

	#Nome do arquivo
	nomeArquivo: .asciiz "arquivo.txt"

	#A partitura será escrita em Sol E terá o compasso 4 por 4
	inicial: .asciiz "C partitura(Sol,4/4)\n" #primeira linha (padrãozão)

	#Figuras musicais
	semibreve: .asciiz "sb"
	minima: .asciiz "m"
	semiminima: .asciiz "sm"
	colcheia: .asciiz "c"
	semicolcheia: .asciiz "sc"
	fusa: .asciiz "f"
	semifusa: .asciiz "sf"
	sustenido: .asciiz "#"

	#Apetrechos
	mais: .asciiz "+"
	espaco: .asciiz " "
	quebraLinha: .asciiz "\n"
	identacao: .asciiz "\t"

	numUm: .asciiz "1"
	numDois: .asciiz "2"
	numTres: .asciiz "3"


	#Notas:
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
	acoVirgula: .asciiz "C+1"

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
#=============
	#quem sabe no futuro?!
	#------------
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
	#------------
#===========
	# ' - fecha o programa
	# + aumenta volume
	# - diminui o volume
	# 0 - instrumento a frente
	# 9 - instrumento anterior

.text


	#Sugestões:
	#		[] - Implementar a oitava acima
	#		[x] - Teclas de volume
	#		[x] - Teclas de mudar de instrumento

	j main

################################################################################

	set_key:

			#---------------------------------------
			#------------ALTERAR VOLUME-------------
			#---------------------------------------

			#TODO: FLAG SE É PRA TOCAR OU NAO

			beq $t8, 61, aumenta_volume#Botão '=' (aumenta volume)
			beq $t8, 45, abaixa_volume	#Botão '-' (baixa volume)
			j saida_volume

		aumenta_volume:
				bgt $a3, 127, saida_volume	#Se atingiu o limite superior de volume
				add $a3, $a3, 1				#Soma 1 no volume
				j saida_volume					#Continua o fluxo de verificação de tecla
		abaixa_volume:
				blt $a3, 1, saida_volume	#Se atingiu o limite inferior de volume
				add $a3, $a3, -1				#Subtrai 1 no volume
				j saida_volume					#Continua o fluxo de verificação de tecla

		saida_volume:


		#--------------------------------------------
		#------------ALTERAR INSTRUMENTOS------------
		#--------------------------------------------

		beq $t8, 48, proximo_instrumento 	#Botão '0' (proximo instrumento)
		beq $t8, 57, anterior_instrumento	#Botão '9' (instrumento anterior)
		j saida_instrumento

	proximo_instrumento:
			bgt $a2, 127, saida_instrumento	#Se atingiu o limite de instrumentos
			add $a2, $a2, 1						#Proximo instrumento
			j saida_instrumento					#Continua o fluxo de verificação de tecla
	anterior_instrumento:
			blt $a2, 1, saida_instrumento#Se não tiver instrumentos anteriores
			add $a2, $a2, -1					#Altera para o instrumento anterior
			j saida_instrumento				#Continua o fluxo de verificação de tecla

	saida_instrumento:



		############################################################################

		#Se a ultima tecla pressionada for igual a que está sendo pressionada
		#agora, não se faz nada, retorna à chamada e conta mais um loop
		#$t9 é a ultima tecla pressionada
		#$t8 é a tecla atualmente pressionada

		#TODO: ver a espera da syscall para escrever duas notas seguidas de mesmo
		#tom
		beq $t9, $t8, return_key #Se for a mesma tecla pressionada


		#salva o valor de $ra, vai ser chamada outras funções por jal de forma não
		#recursiva, então não é tão necessaio ser guardado na pilha, e garante um
		#pouco mais de segurança
		add $t7, $zero, $ra

		#salva argumentos na pilha, os argumentos $an são importantes pra execução
		#do som, poderia ser reposto com literais no loop principal, mas perderia
		#em flexibilidade e ganharia em desepenho (0 ou 8 operações sendo feito
		#aqui versus 4 operações executadas com toda certeza no bloco do loop)
		addi $sp, $sp, -12
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $a2, 8($sp)

		#se o caracter anteriormente pressionado for 0, significa que é a primeira
		#iteração de todo o programa, então não é necessaria avaliar teclas
		#previamente pressionadas, desviando para a avalição da atualmente
		#pressionada
		beq $t9, $zero, write_none_of_above

		#faz aproximação e escreve o tempo da nota

		#cada loop tem cerca de 30 ms
		#$t6 tem o numero de loop executados com a mesma nota
		mul $t6, $t6, 30

		#é feita a diferença do tempo do loop pelo tempo das notas (em 80 bpm)
		#para se ter uma lista de distancias até ate cada nota

		addi $s1, $t6, -1500
		addi $s2, $t6, -750
		addi $s3, $t6, -375
		addi $s4, $t6, -187
		addi $s5, $t6, -94
		addi $s6, $t6, -47

		#pega-se os valores absolutos para a distancia indepentende do lado
		abs $s1, $s1
		abs $s2, $s2
		abs $s3, $s3
		abs $s4, $s4
		abs $s5, $s5
		abs $s6, $s6

		#Inicio do algoritmo para saber a menor distância
		#$s7 recebe um numero (quase) inalcancavel pelo loop, logo é o maior
		add $s7, $zero, $sp

		#$s7 sempre vai ter o menor valor

		bgt $s1, $s7, prox1
		add $s7, $zero, $s1

	prox1:
		bgt $s2, $s7, prox2
		add $s7, $zero, $s2
	prox2:
		bgt $s3, $s7, prox3
		add $s7, $zero, $s3
	prox3:
		bgt $s4, $s7, prox4
		add $s7, $zero, $s4
	prox4:
		bgt $s5, $s7, prox5
		add $s7, $zero, $s5
	prox5:
		bgt $s6, $s7, prox6
		add $s7, $zero, $s6
	prox6:


		#Sabendo o menor valor, volta atrás e vê qual a figura mais próxima e
		#as escreve

		#switch

	case_sb:
		bne $s7, $s1, case_m
		jal printSemibreve
		j end_switch_tempo
	case_m:
		bne $s7, $s2, case_sm
		jal printMinima
		j end_switch_tempo
	case_sm:
		bne $s7, $s3, case_c
		jal printSemiminima
		j end_switch_tempo
	case_c:
		bne $s7, $s4, case_sc
		jal printColcheia
		j end_switch_tempo
	case_sc:
		bne $s7, $s5, case_f
		jal printSemicolcheia
		j end_switch_tempo
	case_f:
		bne $s7, $s6, end_switch_tempo
		jal printFusa
		j end_switch_tempo


	end_switch_tempo:

		#o tempo já foi usado, agora está sendo pressionado uma nova tecla
		#logo o contador de loop é zerado
		add $t6, $zero, $zero



		##########################################################################

		#agora só escever a nota que estava sendo tocada
		#switch case
		write_z:
			bne $t9, 122, write_s	#Se a tecla pressionada ANTERIORMENTE == 122
			jal printAcoZ				#Escreve o acorde referente da tecla ANTERIOR
			beq $t8, 39, end_switch	#Se a tecla atual for a de fechar o programa
			jal printEspaco			#Escreve o espaço para dar inicio a uma
			j end_switch				#Termina o switch
											#Mesma coisa para os demais casos desse switch
		write_s:
			bne $t9, 115, write_x
			jal printAcoS
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_x:
			bne $t9, 120, write_d
			jal printAcoX
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_d:
			bne $t9, 100, write_c
			jal printAcoD
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_c:
			bne $t9, 99, write_v
			jal printAcoC
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_v:
			bne $t9, 118, write_g
			jal printAcoV
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_g:
			bne $t9, 103, write_b
			jal printAcoG
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_b:
			bne $t9, 98, write_h
			jal printAcoB
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_h:
			bne $t9, 104, write_n
			jal printAcoH
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_n:
			bne $t9, 110, write_j
			jal printAcoN
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_j:
			bne $t9, 106, write_m
			jal printAcoJ
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_m:
			bne $t9, 109, write_comma
			jal printAcoM
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_comma:
			bne $t9, 44, write_none_of_above #Vai terminar o switch
			jal printAcoVirgula
			beq $t8, 39, end_switch
			jal printEspaco
			j end_switch

		write_none_of_above: #Label para facilicar a leitura na sua chamada

		#Caso nenhuma das teclas
		end_switch:

		#Verifica se é chave de fechar o programa
		beq $t8, 39, exit_at_all

		#Salvar argumentos da pilha
		#Talvez esteja custando mais do que reescrever no loop
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)

		addi $sp, $sp, 12 #Desconstroi a pilha


		################################################################################


		#switch case para identificacao da tecla pressionada
		#//(O caracter lido nao eh em ascci)
		check_z:
			bne $t8, 122, check_s	#Se a tecla "122" nao foi pressionada, pula
			add $a0, $zero, 48 		#Atribuicao da nota em $a0
			j put_key					#Resgata $ra e volta para o loop
											#Mesmo esquema para os demais itens do switch
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

		#caso a tecla pressionada não tenha sido indexada, é tocado um C gravissimo
		none_of_above:
			addi $a0, $zero, 0


		put_key:
			add $t9, $zero, $t8	#Salva em t9 a antiga tecla pessionada
		return_key:
			add $ra, $zero, $t7 	#Resgata da pilha o valor correto de $ra
			jr $ra					#Volta para o loop:


################################################################################


	main:

		#Abre arquivo
		addi $v0, $zero, 13	#13 = abre arquivo
		la $a0, nomeArquivo 	#noem do arquivo
		addi $a1, $zero, 9 	#0(read only);1(write only);9(append)
		add $a2, $zero, $zero 	#ignora
		syscall
		add $s0, $zero, $v0 	#salva o file descriptor

		#Limpa o $t9 pondo 0, já que é a primeira iteração
		add $t9, $zero, $zero

		#Escreve o cabeçalho do arquivo (partitura em sol, 4/4) e quebra a linha
		jal printInicial

		#Faz uma indentação no arquivo, que já está pronto para receber as nostas
		jal printIdentacao

		#Ajuste das configurações iniciais do sintetizador
		addi $a0, $zero, 63
		addi $a1, $zero, 550
		addi $a2, $zero, 88
		addi $a3, $zero, 80

################################################################################

	loop:
		#Lê caracter do teclado
		addi $v0, $zero, 12
		syscall

		#Salva em $t8 o caracter lido atualmente
		add $t8, $zero, $v0

		jal set_key 			#Vai para a verificação de teclas
		addi $t6, $t6, 1		#Contador para identificação do tempo

		addi $v0, $zero, 31 	#Toca o som correspondente a tecla
		syscall
		j loop


#######################################################################################################################


#----------------------------------------------------------
#------------PRINT DOS FIGURAS MUSICAIS E OUTROS-----------
#----------------------------------------------------------

printInicial:
		addi $v0, $zero, 15 	#Para escrever em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, inicial		#Carrega em $a1 o que deve ser escrito (a nota)
		addi $a2, $zero, 22 	#Numero de caracteres a serem escritos
		syscall					#Escreve no arquivo
		jr $ra					#Volta para o main (Nesse caso de printInicial)

printIdentacao:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, identacao
		addi $a2, $zero, 1
		syscall
		jr $ra

printQuebraLinha:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, quebraLinha
		addi $a2, $zero, 1
		syscall
		jr $ra

printMais:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, mais
		addi $a2, $zero, 1
		syscall
		jr $ra

printEspaco:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, espaco
		addi $a2, $zero, 1
		syscall
		jr $ra

printUm:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, numUm
		addi $a2, $zero, 1
		syscall
		jr $ra

printDois:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, numDois
		addi $a2, $zero, 1
		syscall
		jr $ra

printTres:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, numTres
		addi $a2, $zero, 1
		syscall
		jr $ra


printSemibreve:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, semibreve
		addi $a2, $zero, 2
		syscall
		jr $ra					#Volta para o case de tempo
									#Faz isso para os demais a baixo
printMinima:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, minima
		addi $a2, $zero, 1
		syscall
		jr $ra

printSemiminima:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, semiminima
		addi $a2, $zero, 2
		syscall
		jr $ra

printColcheia:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, colcheia
		addi $a2, $zero, 1
		syscall
		jr $ra

printSemicolcheia:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, semicolcheia
		addi $a2, $zero, 2
		syscall
		jr $ra

printFusa:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, fusa
		addi $a2, $zero, 1
		syscall
		jr $ra

printSemifusa:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, semifusa
		addi $a2, $zero, 2
		syscall
		jr $ra

printSustenido:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, sustenido
		addi $a2, $zero, 1
		syscall
		jr $ra


#-----------------------------------------
#-----------PRINT DAS NOTAS---------------
#-----------------------------------------


printAcoZ:
		addi $v0, $zero, 15 	#Para escrever em arquivo
		add $a0, $zero, $s0 	#Informa o file descriptor
		la $a1, acoZ			#Carrega em $a1 o que deve ser escrito (a nota)
		addi $a2, $zero, 1 	#Numero de caracteres a serem escritos
		syscall					#Escreve no arquivo a nota
		jr $ra					#Volta para o switch do write_
									#Mesma coisa para os demais prints de acordes
printAcoS:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoS
		addi $a2, $zero, 2
		syscall
		jr $ra

printAcoX:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoX
		addi $a2, $zero, 1
		syscall
		jr $ra

printAcoD:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoD
		addi $a2, $zero, 2
		syscall
		jr $ra

printAcoC:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoC
		addi $a2, $zero, 1
		syscall
		jr $ra

printAcoV:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoV
		addi $a2, $zero, 1
		syscall
		jr $ra

printAcoG:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoG
		addi $a2, $zero, 2
		syscall
		jr $ra

printAcoB:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoB
		addi $a2, $zero, 1
		syscall
		jr $ra

printAcoH:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoH
		addi $a2, $zero, 2
		syscall
		jr $ra

printAcoN:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoN
		addi $a2, $zero, 1
		syscall
		jr $ra

printAcoJ:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoJ
		addi $a2, $zero, 2
		syscall
		jr $ra

printAcoM:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoM
		addi $a2, $zero, 1
		syscall
		jr $ra

printAcoVirgula:
		addi $v0, $zero, 15
		add $a0, $zero, $s0
		la $a1, acoVirgula
		addi $a2, $zero, 3
		syscall
		jr $ra


#######################################################################################################################

exit_at_all:

	#Fechar arquivo
	addi $v0, $zero, 16 	#16 = fecha arquivo
	add $a0, $zero, $s0 #filedescriptor
	syscall #Norre aq
