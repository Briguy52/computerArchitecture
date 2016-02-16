.data

.text
	.globl main

main:
	
	li $t0, 1
	li $t1, 2
	move $a0, $t0
	move $a1, $t1
		
	# addi $sp, $sp, -8 # grow the stack DOWN by 8 bytes!
# 	sw $t0, 0($sp) # store return address in the stack
# 	sw $t1,4($sp) # store a copy of $s0 - callee saved (from byte 4-8)

	jal foo
	
	# lw $t1, 4($sp) # restore $s0 from the stack
# 	lw $t0, 0($sp) # restore return address
# 	addi $sp, $sp, 8
	
	add $v1, $t0, $t1
	add $v0, $v0, $v1
	move $a0, $v0
	
	li $v0, 1
	syscall
	j end
	
foo: 
	# addi $sp, $sp, -8 # grow the stack DOWN by 8 bytes!
# 	sw $ra, 0($sp) # store return address in the stack
# 	sw $s0, 4($sp) # store a copy of $s0 - callee saved (from byte 4-8)

	add $s0, $a0, $a1 # add two arguments and store
	move $v0, $s0
	
	li $t0, 0 # for number 3
	li $t1, 0
	
	# lw $s0, 4($sp) # restore $s0 from the stack
# 	lw $ra, 0($sp) # restore return address
# 	addi$sp, $sp, 8
	
	jr $ra
	 
end:
	li $v0, 10 # service for leaving
	syscall