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
	
	salvar_registrador:
		add $s0, $zero, 122
		add $s1, $zero, 120
		add $s2, $zero, 99
		add $s3, $zero, 118
		add $s4, $zero, 98
		add $s5, $zero, 110
		add $s6, $zero, 109
		add $s7, $zero, 44
		
		jr $ra

#######################################################################################################################
		
		write_to_file:
		
			mul $,, $t6, 50
			
			jr $ra
			
		
#######################################################################################################################

	set_key:
		
		#$t9 é a ultima tecla pressionada
		#$t8 é a tecla atualmente pressionada
	
		beq $t9, $t8, return_key
		
		add $t7, $zero, $ra
		jal write_to_file
		add $ra, $zero, $t7
		add $t6, $zero, $zero
		
		check_z:
			bne $s0, $t8, check_s
			add $a0, $zero, 48
			j put_key
		
		check_s:
			add $t5, $zero, 115
			bne $t5, $t8, check_x
			add $a0, $zero, 49
			j put_key
			
		check_x:
			bne $s1, $t8, check_d
			add $a0, $zero, 50
			j put_key
			
		check_d:
			add $t5, $zero, 100
			bne $t5, $t8, check_c
			add $a0, $zero, 51
			j put_key
			
		check_c:
			bne $s2, $t8, check_v
			add $a0, $zero, 52
			j put_key
			
		check_v:
			bne $s3, $t8, check_g
			add $a0, $zero, 53
			j put_key
			
		check_g:
			add $t5, $zero, 103
			bne $t5, $t8, check_b
			add $a0, $zero, 54
			j put_key
			
		check_b:
			bne $s4, $t8, check_h
			add $a0, $zero, 55
			j put_key
			
		check_h:
			add $t5, $zero, 104
			bne $t5, $t8, check_n
			add $a0, $zero, 56
			j put_key
			
		check_n:
			bne $s5, $t8, check_j
			add $a0, $zero, 57
			j put_key
			
		check_j:
			add $t5, $zero, 106
			bne $t5, $t8, check_m
			add $a0, $zero, 58
			j put_key
			
		check_m:
			bne $s6, $t8, check_comma
			add $a0, $zero, 59
			j put_key
			
		check_comma:
			bne $s7, $t8, none_of_above
			add $a0, $zero, 60
			j put_key
			
		none_of_above:
			addi $a0, $zero, 0
			
		
		put_key:
			add $t9, $zero, $t8
		return_key:
			jr $ra
			
			
#######################################################################################################################


	main:
		jal salvar_registrador
		addi $a0, $zero, 63
		addi $a1, $zero, 550
		addi $a2, $zero, 88
		addi $a3, $zero, 80
		
#######################################################################################################################
	
	loop:
		addi $v0, $zero, 12
		syscall
				
		add $t8, $zero, $v0
		
		addi $t6, $zero, 1
		jal set_key
		
		#j exit_at_all
		
		addi $v0, $zero, 31
		syscall
		j loop
		
		
#######################################################################################################################


exit_at_all:
