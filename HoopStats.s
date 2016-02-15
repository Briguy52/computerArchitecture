.data
nln: .asciiz "\n"
askName: .asciiz "What is the player name?"
askJersey: .asciiz "What is the jersey number?"
askPoints: .asciiz "How many points per game?"
space: .asciiz " " 
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
# la $a0, name # where to store?
# li $a1, 64 # how much space?
# move $t0, $a0 # store
# syscall

.text
	.globl main

main:
	# TODO: figure out when to do the stack pointer stuff
	li $s7, 0 # head node empty? 0 = empty, 1 = not empty
	
	li $v0, 9 # malloc syscall for HEAD node
	li $a0, 72
	syscall
	move $s0, $v0

	li $v0, 9 # malloc syscall for NEXT node
	li $a0, 72
	syscall
	move $s1, $v0 # store address of current node
	
askForString:	
	li $v0, 4 # print string
	la $a0, askName
	syscall
	
	li $v0, 9 # malloc syscall for NEW node 
	li $a0, 72
	syscall
	move $s2, $v0 # TODO: $s2 is the NEW NODE for storing NAME, JPG, and POINTER
	
	li $v0, 8 # read string
	move $a0, $s2 # STORE name in my NEW node
	la $a1, 64 # number of chars to read + 1
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
		
		sw $t3, 64($s2) # move NAME bytes down and store your JPG

		beqz $s7, newLL
		
		j existingLL

newLL: 
	li $s7, 1 # set head to NON-EMPTY
	move $s0, $s2 # add new node ($s2) to head ($s0) 
	move $s1, $s0 # add these next node in list ($s1)
	j askForString # begin next cycle
	
existingLL:
	sw $s2, 68($s1) # prepare to store POINTER
	move $s1, $s2 # this -> this.next
	j askForString # begin next cycle
	
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

		j printHead
		
printHead:
	# TODO: streamline your code!
	
	li $v0, 4 # print String
	la $a0, 0($s0) #load head NAME
	syscall 
	
	li $v0, 4 # print String
	la $a0, space # load space
	syscall
	
	li $v0, 1 # print Integer
	lw $a0, 64($s0) # load head JPG
	syscall
	
	li $v0, 4 # print String
	la $a0, nln # load new line
	syscall
	
	lw $a1, 68($s0) # load pointer to NEXT
	
	j printRemaining

	printRemaining:
		# $a0 is the NODE, $a1 is the pointer to its NEXT
		beqz $a1, end # TODO: if null pointer (no next) then END
		
		li $v0, 4 # print String
		la $a0, 0($a0) # load node NAME
		syscall
		
		li $v0, 4 # print String
		la $a0, space # load space
		syscall
		
		li $v0, 1 # print Integer
		lw $a0, 64($a0) # load node JPG
		syscall
		
		li $v0, 4 # print String
		la $a0, nln # load new line
		syscall
		
		lw $t0, 68($a1) # TODO: load pointer to NEXT
		move $a1, $t0 
		
		j printRemaining
		
end:
	li $v0, 10 # service for leaving
	syscall