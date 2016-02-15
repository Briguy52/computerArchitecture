.data
nln: .asciiz "\n"
askName: .asciiz "What is the player name?"
askJersey: .asciiz "What is the jersey number?"
askPoints: .asciiz "How many points per game?"
test: .asciiz "test"
done: .asciiz "DONE"
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

.text
	.globl main

initStructs:
	# li $a0, full # allot full buffer
	# li $v0, 9 # malloc syscall
	# syscall
	# move $s0, $v0 # set head node
	#
	# li $a0, full # allot full buffer
	# li $v0, 9 # malloc syscall
	# syscall
	# move $s1, $v0 # set current node
	
main:	
	la $a0, askName
	la $v0, 4
	syscall
	
	li $v0, 8 # read String input
    la $a0, name # allot buffer
    li $a1, 64 # allot byte space
	move $t0, $a0 # store
    syscall
	
	li $v0, 9 # malloc
	li $a0, full # prep node
	syscall 
	move $s2, $v0 # TODO: what's this line for? 
	
	li $v0, 8 # read string 
	move $a0, $v0 
	li $a1, name
	# li $a1, 64 # TODO: do we need to allot byte space?
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
		j main 
	
checkDone:  
	    move $t1, $a0
	    la $t2, done
	loopThruString:
	    lb $t3($t1)         # load a byte from each string
	    lb $t4($t2)
		beqz $t3, checkt2 #str1 end
		beqz $t4, mismatch
		slt $t5, $t3, $t4  #compare two bytes
		bnez $t5, mismatch
		addi $t1, $t1, 1  #t1 points to the next byte of str1
		addi $t2, $t2, 1
		j loopThruString

		mismatch: 
		li $v0, 1
		j endfunction
		
		checkt2:
		bnez $t4, mismatch 
		li $v0, 0 

		endfunction:
		jr $ra

	 
print:
	li $v0, 10 # service for leaving
	syscall