.data
nln: .asciiz "\n"
askName: .asciiz "What is the player name?"
askJersey: .asciiz "What is the jersey number?"
askPoints: .asciiz "How many points per game?"
test: .asciiz "test\n"
flag: .asciiz "Ending cycle\n"
done: .asciiz "DONE"
full: .space 72
name: .space 64
nameAndJPG: .space 68
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
	li $s7, 0 # head node empty? 0 = empty, 1 = not empty
	
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
	move $s2, $v0 # TODO: store address of allocated space 
	
	li $v0, 8 # read string
	move $a0, $s2 # address for string to be stored
	# la $a0, name
	la $a1, name # number of chars to read + 1
	# li $a1, 64
	syscall
	
	j checkDone
	
	continue:
		la $a0, askJersey
		li $v0, 4
		syscall
		
		li $v0, 5  # 1) load in word/argument    
		syscall  
		move $t1, $v0
		
		la $a0, askPoints
		li $v0, 4
		syscall
		
		li $v0, 5  # 1) load in word/argument    
		syscall  
		move $t2, $v0
		
		sub $t3, $t1, $t2 # JPG = jersey - points
		
		move $a0, $t3
		li $v0, 1
		syscall 
		
		sw $t3, name($s2) # move name bytes down and store your JPG

		beqz $s7, newLL
		
		j askForString
	
checkDone:  
	# TODO: great!
		lb $t1($a0) # first char of input
		la $t2, done # load "D"
		lb $t3($t2) # first char of DONE (D)
		
		bne $t1, $t3, continue # ask for jersey/points

		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		addi $t2, $t2, 1
		lb $t3($t2) # second char of DONE (O)
		
		bne $t1, $t3, continue # ask for jersey/points
		
		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		addi $t2, $t2, 1
		lb $t3($t2) # third char of DONE (N)
		
		bne $t1, $t3, continue # ask for jersey/points
		
		addi $a0, $a0, 1 # shift over to next letter
		lb $t1($a0) # first char of input
		addi $t2, $t2, 1
		lb $t3($t2) # fourth char of DONE (E)
		
		bne $t1, $t3, continue # ask for jersey/points
		
		li $v0, 4 # print string
		la $a0, flag
		syscall

		j print

newLL: 
	li $s7, 1 # set head to NON-EMPTY
	addi $s0, $s2, 0 # add new node ($s2) to head ($s0) 
	addi $s1, $s0, 0 # add these next node in list ($s1) 
	j askForString # begin next cycle
	
existingLL:
	sw $s2, nameAndJPG($s1) # move along next node (past already stored name + JPG)
	move $s1, $s2 # shift pointers along
	j askForString # begin next cycle
	
print:
	li $v0, 10 # service for leaving
	syscall