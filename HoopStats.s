.data
nln: .asciiz "\n"
askName: .asciiz "What is the player name? \n"
askJersey: .asciiz "What is the jersey number?"
askPoints: .asciiz "How many points per game?"
test: .asciiz "test\n"
flag: .asciiz "flag\n"
done: .asciiz "DONE\n"
D: .asciiz "D"
O: .asciiz "O"
N: .asciiz "N"
E: .asciiz "E"
full: .space 72
name: .space 64
jpg: .space 4
next: .space 4
# Syscall quick reference
# print_int: .word 1
# print_float: .word 2
# print_double: .word 3
# print_string: .word 4
# read_int: .word 5
# read_float: .word 6
# read_double: .word 7
# read_string: .word 8
# malloc: .word 9
# exit: .word 10
# print_character: .word 11
# read_character: .word 12
# open_file: .word 13
# read_file: .word 14
# write_file: .word 15

# li $v0, 8 # read String input
# la $a0, name # allot buffer
# li $a1, 64 # allot byte space
# move $t0, $a0 # store
# syscall

.text
	.globl main

main:
	li $v0, 9 # malloc syscall
	# la $a0, full # allot full buffer
	li $a0, 72
	syscall
	# move $s0, $v0 # store address of head node
	add $s0, $v0, $0

	li $v0, 9 # malloc syscall
	# la $a0, full # allot full buffer
	li $a0, 72
	syscall
	move $s1, $v0 # store address of current node
	
askForString:	
	li $v0, 4 # print string
	la $a0, askName
	syscall
	
	li $v0, 9 # malloc
	# la $a0, full # prep node
	li $a0, 72
	syscall
	move $s2, $v0 # store address of allocated space
	
	# li $a0, 72 # DONE - allot String buffer
	# li $v0, 9 # TODO: read w/ malloc
	# syscall
	# add $s1, $v0, $zero #Save s1 as the head, set it as empty
	
	li $v0, 8 # read string
	move $a0, $s2 # address for string to be stored
	# la $a0, name
	la $a1, name # number of chars to read + 1
	# li $a1, 64
	syscall
	
	j checkDone
	
	li $v0, 8 # read string
	move $a0, $v0
	la $a0, name
	move $t0, $a0
	syscall
	
	li $v0, 4 # print input name
	move $a0, $t0
	syscall
	
	# check if name is equal to DONE 
	move $a0, $t0 
	jal checkDone
	
	bnez $v0, continue  # check result
	
	li $v0, 4
	la $a0, test
	syscall
	
	j print
	
	continue:
		la $a0, askJersey
		li $v0, 4
		syscall
		
		li $v0, 5  # 1) load in word/argument    
		move $t1, $a0 # store        
		syscall  
		
		la $a0, askPoints
		li $v0, 4
		syscall
		
		li $v0, 5  # 1) load in word/argument    
		move $t2, $a0 # store        
		syscall  
		
		# TODO: store t0, t1, and t2 in a struct
		# j print
		j askForString
	
checkDone:  
		# move $t0, $a0 # store input string
		lb $t1($a0) # first char of input
		la $t2, D # load "D"
		lb $t3($t2) # first char of DONE (D)
		
		li $v0, 4 # print string
		la $a0, test
		syscall
		
		bne $t1, $t2, continue # ask for jersey/points

		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		la $t2, O # load "O"
		lb $t3($t2) # second char of DONE (O)
		
		bne $t1, $t2, continue # ask for jersey/points
		
		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		la $t2, O # load "N"
		lb $t3($t2) # third char of DONE (N)
		
		bne $t1, $t2, continue # ask for jersey/points
		
		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		la $t2, O # load "E"
		lb $t3($t2) # fourth char of DONE (E)
		
		bne $t1, $t2, continue # ask for jersey/points
		
		li $v0, 4 # print string
		la $a0, flag
		syscall
		
		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		la $t2, nln # load "E"
		lb $t3($t2) # fourth char of DONE (E)
		
		bne $t1, $t2, continue # ask for jersey/points
		
		j print
		
		
		# move $t0, $a0
		# la $t1, done
		# li $t4, 0 # counter variable
		# li $t5, 4
		# j loop
		#
		# loop:
		# 	beq $t4, $t5, continue
		# 	lb $t2($t0)
		# 	lb $t3($t1)
		# 	bne $t3, $t2, continue # ask for jersey/points
		# 	addi $t0, $t0, 1
		# 	addi $t1, $t1, 1
		# 	addi $t4, $t4, 1
		# 	j loop
				 
print:
	li $v0, 10 # service for leaving
	syscall