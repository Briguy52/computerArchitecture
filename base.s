.data
strNamePrompt: .asciiz "\n Enter a name: \n"
strStatPrompt: .asciiz "Enter a stat:"
 
FINISHED: .asciiz "DONE\n" 
Dstr: .asciiz "D"
Ostr: .asciiz "O"
Nstr: .asciiz "N"
Estr: .asciiz "E"
Newstr: .asciiz "\n"
.text
	.globl main
main:
	li $t2, 5
	#la $t5, FINISHED
	li $t4, 1 #Node add counter

	li $a0, 68 # DONE - allot String buffer
	li $v0, 9 # TODO: read w/ malloc
	syscall
	add $s1, $v0, $zero #Save s1 as the head, set it as empty

	li $a0, 68
	li $v0, 9
	syscall
	add $s3, $v0, $zero #Save s3 as the current node, set it as empty
								
getName:
	#Initiating length of name to 0 
	#li $v1, 0 
	
	#Getting player name
	la $a0, strNamePrompt
	li $v0, 4
	syscall 
	
	li $a0, 68
	li $v0, 9
	syscall 
	add $s0, $v0, $zero
	
	add $a0, $v0, $zero
	li $a1, 60 
	li $v0, 8  
	syscall
	
	j strComp
	
strComp: 		
	#Comparing name to "DONE"
	
	la $t1, Dstr	#Load first character from "FINISHED"
	lb $t2($t1) 
	lb $t0($a0) #Load first character from input name
	
	#add $v1, $v1, 1 #Increment the number of characters that have been read
	beq $t2, $t0, strEqCont
	j statsLabel
	
strEqCont:
	la $t1, Ostr
	lb $t2($t1)
	addi $a0, $a0, 1
	lb $t0($a0)
	bne $t2, $t0, statsLabel
	
	la $t1, Nstr
	lb $t2($t1)
	addi $a0, $a0, 1
	lb $t0($a0)
	bne $t2, $t0, statsLabel
	
	la $t1, Estr
	lb $t2($t1)
	addi $a0, $a0, 1
	lb $t0($a0)
	bne $t2, $t0, statsLabel
	
	la $t1, Newstr
	lb $t2($t1)
	addi $a0, $a0, 1
	lb $t0($a0)
	bne $t2, $t0, statsLabel
	j printPlayers												
																																										
statsLabel: #Inputting player stats (if "DONE" is not entered)
	#add $s1, $s0, 0  #Creating head of linked list 
	
	la $a0, strStatPrompt
	li $v0, 4
	syscall 
	
	#Ask for player's ppg
	li $v0, 6	
	syscall
	mov.s $f1, $f0
	
	la $a0, strStatPrompt
	li $v0, 4
	syscall 
	
	#Ask for player's rebounds
	li $v0, 6
	syscall
	mov.s $f2, $f0
	
	la $a0, strStatPrompt
	li $v0, 4
	syscall 
	
	#Ask for player's turnovers
	li $v0, 6
	syscall 
	mov.s $f3, $f0 		
					
	#Calculating player's 		
	add.s $f4, $f1, $f2 	#Points + Rebounds in $f4
	div.s $f5, $f4, $f3	#Player efficiency = $f4/$f3 
	s.s $f5, 60($s0) 	#Stores player's efficiency 
	
	mov.s $f12, $f5
	li $v0, 2 
	syscall  
	
	li $t7, 1 
	beq $t4, $t7, headIsNull 
	j linkNodes 
			
headIsNull:
	add $s1, $s0, $zero #Set the node you want to link into head (which is empty)  
	addi $t4, $t4, 1 #Increment node counter to one such that this branch never runs again outside of the first node you need to put in 
	add $s3, $s1, $zero #Current 
	j getName
linkNodes:
	#lw $a0, 0($s3) #Load pointer
	#beqz $a0, nodeAdd #If pointer points to null, add node 
	sw $s0, 64($s3) #
	move $s3, $s0 #Set pointer to next thing 	
	j getName  
	
printPlayers: 
	la $a0, Newstr
	li $v0, 4
	syscall
	#Printing head
	la $a0, 0($s1)
	li $v0, 4
	syscall 
	
	l.s $f12, 60($s1) 
	li $v0, 2
	syscall 
	 
	lw $a1, 64($s1) #Load pointer of head node 
	
	la $a0, Newstr
	li $v0, 4
	syscall
	
	j iterateThrough
iterateThrough:
	beqz $a1, end   
	
	la $a0, Newstr #Putting in a new line 
	li $v0, 4
	syscall
	
	la $a0, 0($a1)	#Load name of player of the node that our iteration is currently on 
	li $v0, 4
	syscall
		
	l.s $f12, 60($a1) #Load player eff. of the node that our iteration is currently on 
	li $v0, 2
	syscall
	
	la $a0, Newstr
	li $v0, 4
	syscall
	
	lw $t0, 64($a1)	#Load pointer 
	add $a1, $t0, 0 #Go to next node 
	
	j iterateThrough 
end:
	li $v0, 10
	syscall