
#===========macro segment============
.macro exit
li $v0, 10
syscall
.end_macro
#===========data segment=============
.data
msg1: .asciiz "Enter n: "
msg2: .asciiz "Enter Matrix:\n"
msg3: .asciiz "Enter Vector:\n"
msg4: .asciiz "Result: "
zero: .float	0.0
#===========code segment=============
.text
main:

la	$a0, msg1
li	$v0, 4
syscall			#prompt
li	$v0, 5
syscall			#read matrix size from user
move	$t1, $v0

la	$a0, msg2
li	$v0, 4
syscall			#prompt

move	$a0, $t1
jal	read_matrix	#call the read_matrix function
move	$t8, $v0

la	$a0, msg3
li	$v0, 4
syscall			#prompt

move	$a0, $t1
jal	read_vector	#call the read_vector function
move	$t9, $v0

move	$a0, $t1	# n
move	$a1, $t8	# A[n][n]
move	$a2, $t9	# X[n]
jal	MVM		#call the MVM function

move	$a0, $t1
move	$a1, $v0


jal	print_vector	#call the print vector function

exit
#------------functions---------------
#function to read the matrix
read_matrix:
	move	$s0, $a0
	mul	$s1, $s0, $s0

	li	$v0, 9
	sll	$a0, $s1, 2	
	syscall		# allocating memory for matrix
	move	$s2, $v0
	add	$t0, $0, $s2 	# starting address of matrix
	mul	$s1, $s0, $s0	# n * n (size of matrix)
	sll	$s1, $s1, 2	# multiply by 4 because flaot size is 4 bytes
	add	$s1, $s1, $s2
	r_loop:			# a loop to read matrix
	beq	$t0, $s1, stop_r_loop
	li	$v0, 6
	syscall
	s.s	$f0, ($t0)
	addi	$t0, $t0, 4
	j	r_loop
	stop_r_loop:
	add	$v0, $0, $s2
	jr	$ra
	

#function to read the vector
read_vector:
	move	$s0, $a0
	li	$v0, 9
	sll	$a0, $s0, 2	
	syscall		# allocate memory for vector
	move	$s2, $v0
	add	$t0, $0, $s2 	# starting address of matrix
	sll	$s1, $s0, 2	# multiply with 4 because 1 floating value size is 4 bytes
	add	$s1, $s1, $s2
	rv_loop:		# a loop to read the vector
	beq	$t0, $s1, stop_rv_loop
	li	$v0, 6
	syscall
	s.s	$f0, ($t0)
	addi	$t0, $t0, 4
	j	rv_loop
	stop_rv_loop:
	add	$v0, $0, $s2
	jr	$ra

#function to print the result (vector)
print_vector:
	move	$t2, $a0	# n
	move	$t5, $a1	# has starting address of vector
	sll	$t3, $t2, 2	# multiply by 4 because float size is 4 bytes
	add	$t3, $t3, $a1
	
	la	$a0, msg4
	li	$v0, 4
	syscall			# prints the "Result: " message
	
	p_loop:			# a loop to print the elements
	beq	$t5, $t3, stop_p_loop
	l.s	$f12, ($t5)
	li	$v0, 2
	syscall
	li	$v0, 11
	li	$a0, ' '
	syscall			# prints a space to seperate the numbers
	
	addi	$t5, $t5, 4
	j	p_loop
	
stop_p_loop:
	jr 	$ra
	
#function to multiply matrix with vector
MVM:
	move	$s0, $a0
	sll	$a0, $s0, 2
	li	$v0, 9
	syscall
	move	$s1, $v0	# V
	li	$s2, 0	# i = 0
	i_loop:
	beq	$s2, $s0, stop_i_loop
	l.s	$f1, zero	# sum = 0
	li	$s3, 0	# j = 0
	j_loop:
	beq	$s3, $s0, stop_j_loop
	
	# &m + (row_Index * col_Size + col_Index) * element_Size:
	mul	$s4, $s2, $s0
	add	$s4, $s4, $s3
	sll	$s4, $s4, 2
	add	$s4, $s4, $a1	# A[i][j]
	
	sll	$s5, $s3, 2
	add	$s5, $s5, $a2	# X[j]
	
	l.s	$f4, ($s4)
	l.s	$f5, ($s5)
	mul.s	$f2, $f4, $f5
	add.s	$f1, $f1, $f2
	addi	$s3, $s3, 1	# j++
	j	j_loop
	stop_j_loop:
	sll	$s4, $s2, 2
	add	$s4, $s4, $s1
	s.s	$f1, ($s4)
	addi	$s2, $s2, 1	# i++
	j	i_loop
	stop_i_loop:
	add	$v0, $0, $s1
	jr	$ra
	
