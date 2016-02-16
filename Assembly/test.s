.data

.text
	.globl main

main:
	# li $t0, 10 # t0 is a constant 10
	# li $t1, 0 # t1 is our counter (i)
	li $t0, 1
	li $t1, 2
	move $a0, $t0 # pass first arg in $a0
	move $a1, $t1 # pass second arg in $a1
	jal foo
	j end
	
loop:
	# beq $t1, $t0, end # if t1 == 10 we are done
# 	addi $t1, $t1, 1 # add 1 to t1
# 	li $v0, 1 # service for printing ints
# 	# li $a0, 5
# 	move $a0, $t1
#     syscall         # print whatever's in a0
# 	j loop # jump back to the top
	
foo: 
	add $t3, $a0, $a1 # add two arguments and store
	move $v0, $t3
	li $v0, 1
	syscall
	jr $ra
	 
end:
	li $v0, 10 # service for leaving
	syscall
	