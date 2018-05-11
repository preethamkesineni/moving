# xSpim Memory Demo Program

#  Data Area
.data

space:
    .asciiz " "

newline:
    .asciiz "\n"

dispArray:
    .asciiz "\nCurrent Array:\n"

convention:
    .asciiz "\nConvention Check\n"

myArray:
	.word 0 33 123 -66 332 -1 -223 453 9 45 -78 -14  

#Text Area (i.e. instructions)
.text

main:
    ori     $v0, $0, 4          
    la      $a0, dispArray 
    syscall

    ori     $s1, $0, 12
    la      $s0, myArray

    add     $a1, $0, $s1
    add     $a0, $0, $s0
 
    jal     DispArray

    ori     $s2, $0, 0
    ori     $s3, $0, 0
    ori     $s4, $0, 0
    ori     $s5, $0, 0
    ori     $s6, $0, 0
    ori     $s7, $0, 0
    
    add     $a1, $0, $s1
    add     $a0, $0, $s0

    jal     PrintReverse

    add     $s1, $s1, $s2
    add     $s1, $s1, $s3
    add     $s1, $s1, $s4
    add     $s1, $s1, $s5
    add     $s1, $s1, $s6
    add     $s1, $s1, $s7

    add     $a1, $0, $s1
    add     $a0, $0, $s0
    jal     DispArray

    j       Exit

DispArray:
    addi    $t0, $0, 0 
    add     $t1, $0, $a0

dispLoop:
    beq     $t0, $a1, dispend
    sll     $t2, $t0, 2
    add     $t3, $t1, $t2
    lw      $t4, 0($t3)

    ori     $v0, $0, 1
    add     $a0, $0, $t4
    syscall

    ori     $v0, $0, 4
    la      $a0, space
    syscall

    addi    $t0, $t0, 1
    j       dispLoop    

dispend:
    ori     $v0, $0, 4
    la      $a0, newline
    syscall
    jr      $ra 

ConventionCheck:
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi $v0, $zero, -1
    addi $v1, $zero, -1
    addi $a0, $zero, -1
    addi $a1, $zero, -1
    addi $a2, $zero, -1
    addi $a3, $zero, -1
    addi $k0, $zero, -1
    addi $k1, $zero, -1
    jr      $ra
    
Exit:
    ori     $v0, $0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

PrintReverse:
    #TODO: write your code here, $a0 stores the address of the array, $a1 stores the length of the array

	#saving old register data
        addi $sp, $sp, -16
        sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	li $s0, 0 #index x
       	move $s1, $a1 #index y
	addiu $s2, $s1, -1
	move $s3, $a0 #array
	
loop:
        li $t1, 2#terminating value
	div $s1, $t1
	mflo $t1

        beq $s0, $t1, ConventionPrints

        #get value from array at index x
        sll $t3, $s0, 2
        addu $t4, $t3, $s3
        lw $t6, 0($t4)

        #get value from array at index y
        sll $t3, $s2, 2
        addu $t4, $t3, $s3
        lw $t7, 0($t4)

        #swap values from two index parts
        sll $t3, $s0, 2
        addu $t4, $t3, $s3
        sw $t7, 0($t4)

        sll $t3, $s2, 2
        addu $t4, $t3, $s3
        sw $t6, 0($t4)     
          
         
        #increment x
        addiu $s0, $s0, 1
             
        #decrement y
        li $t1, -1
        addu $s2, $s2, $t1 
 
        j loop
	
     	

ConventionPrints:
	
	li $s0, 0	

ConventionLoop:
	beq $s0, $s1, end_loop	

	sll $t3, $s0, 2
        addu $t4, $t3, $s3
        lw $t6, 0($t4)

	#saving register data pre convention check
	addi $sp, $sp, -20
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $ra, 12($sp)
        sw $s3, 16($sp)

	#print value in flipped array
        li $v0, 1
        move $a0,$t6
        syscall

        jal ConventionCheck

        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $ra, 12($sp)
        lw $s3, 16($sp)
        addi $sp, $sp, 20
	#loading register data post conventioncheck
	
	addiu $s0, $s0, 1 #index value	

	j ConventionLoop


    
end_loop:
	
	
        lw $s0, 0($sp)
        lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	#loading old register data
	
    # Do not remove this line
    jr      $ra
