.data

prompt1: .asciiz "Enter 0 to sort in descending order.\n"
prompt2: .asciiz "Any number different than 0 will sort in ascending order.\n"
prompt3: .asciiz "Before Sort:\n"
prompt4: .asciiz "\n\nAfter Sort:\n"
newline: .asciiz "\n"
length: .word 9
list: .word 7, 9, 4, 3, 8, 1, 6, 2, 5

.text

.globl main
main:
	li $v0, 4
	la $a0, prompt1  	#print prompt1
	syscall

	li $v0, 4
	la $a0, prompt2		#print prompt2
	syscall

	li $v0, 5
	syscall	 	        #read int
	add $s7, $v0, $zero

	li $v0, 4
	la $a0 prompt3  	#print prompt3
	syscall

	la $a1, list
	lw $a2, length		#print list
	jal printdata

	li $s0, 0               #store k(= 0) in $t0
	li $s1, 0               #store j(= k + 1) in $t1
	la $s2, list		#store list[min]
	la $s3, list		#store list[j]
	la $t3, list		#store list[k]
	addi $s3, $s3, 4	
	li $s4, 0		#store min in $s4
	lw $s6, length          #store length in $s6
	add $s6, $s6, $s6       #multiply length by 2
	add $s6, $s6, $s6       #multiply length by 2 again. length now == length * 4
	addi $s5, $s6, -4       #store length-1 in $s5 for mainloop increment
	addi $s6, $s6, 0        #store length in $s6
				#we have k in $s0, j in $s1, list[min] in $s2, list[j] in $s3, 
				#min in $s4, length - 1 in $s5
				#length in $s6, and direction in $s7. Also, list[k] is stored in $t3

	
mainloop:

	beq $s0, $s5, mainexit	#check at the beginning of every loop if you need to exit
	add $s4, $s0, $zero	#set min equal to k at the beginning of every loop
	add $s2, $t3, $zero	#set list[min] to wherever list[k] is
	add $s3, $t3, 4		#set list[j] to list[k+1]
	add $s1, $s0, 4		#set j to k+1
subloop:

	beq $s1, $s6, subexit	#check at the beginning of every loop if you need to exit

	add $a0, $s7, $zero	#
	lw $a1, 0($s2)		#
	lw $a2, 0($s3)		#fill out $a0, $a1, and $a2 with arguments for check procedure
	jal check		#jump to check

	beq $v0, $zero, checkfalse #if $v0 is == 0, jump to checkfalse
	add $s4, $s1, $zero	#set min equal to k
	add $s2, $s3, $zero	#set list[min] equal to list[k]
	checkfalse:

	addi $s1, $s1, 4	#increment j
	addi $s3, $s3, 4	#increment list[j] to reflect change in j value
	bne $s1, $s6, subloop	#check at the end of every loop if you need to exit
subexit:

	beq $s4, $s0, equal	#if min and k are equal, then the values cant be swapped
	
	lw $t0, 0($s2)		#load 2 temp values in registers $t0 and $t1
	lw $t1, 0($t3)

	sw $t1, 0($s2)		#store each temp in the position of the other temp
	sw $t0, 0($t3)

equal:
	addi $s0, $s0, 4	#increment k by 1
	addi $t3, $t3, 4	#increment list[k] to reflect change in j
	bne $s0, $s5, mainloop	#check at end of loop
	
mainexit:

	li $v0, 4
	la $a0, prompt4         #print prompt4
	syscall

	la $a1, list
	lw $a2, length          #print list
	jal printdata

	li $v0, 4
	la $a0, newline         #print newline
	syscall
	
	li $v0, 10
	syscall

###########################################################################
				#End of main


check:

	bne $a0, $zero, gthan	#if direction != 0, sort in descending
	slt $v0, $a1, $a2	
	j end
gthan:
	slt $v0, $a2, $a1
end:
	jr $ra			#return to main



printdata:
	addi $t7, $zero, 0	#temp for iterating through list
for:
	lw $t6, 0($a1)		#load from list
	addi $a1, $a1, 4	#increment position in list by 1

	li $v0, 1
	move $a0, $t6		#print integer
	syscall

	li $v0, 11
	li $a0, 32		#print space
	syscall

	addi $t7, $t7, 1	#increment temp var used to iterate through list

	bne $t7, $a2, for	#check if done iterating through array

	jr $ra			#return to main
