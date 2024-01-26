# This program does the calculations of addition, subtraction, division, multiplication, factorial, which can be done in QTSPIM
# The calculator runs until the user exits the project. It means if one calculation is done, your 
# project is ready to get the next calculation unless the user selects to exit the program or gives an invalid input.

.data
string1: .asciiz "\nChoose an operation:\t1. Addition\t2. Subtraction\t3. Division\t\n4. Multiplication\t5. Factorial\t0. Exit\n"
string2: .asciiz "Enter a number: "
string3: .asciiz "Welcome to the SPIM Calculator! "
string4: .asciiz "Thank you for using SPIM Calculator! "
endLine: .asciiz "\n"
addition: .asciiz "Addition: "
subtraction: .asciiz "Subtraction: "
division: .asciiz "Division: "
multiplication: .asciiz "Multiplication: "
factorial: .asciiz "Factorial: "

.text
main:
    # Display the header - welcome statement
    li $v0, 4
    la $a0, string3
    syscall

    li $v0, 4
    la $a0, endLine
    syscall

# This inputLoop runs till the user enter '0' to exit the operations 
# or >5 which is an invalid operation to choose from 
inputLoop:
    li $v0, 4
    la $a0, endLine
    syscall

    # This runs in loop for any number of different operations
    li $t0, 0   # Initialize the sum to 0
    li $t2, 0   # Initialize the sum to 0  
    li $t3, 0   # Initialize the sum to 0

    li $v0, 4
    la $a0, string1        # Displays the menu operation statement - "Enter the number "
    syscall

    li $v0, 4
    la $a0, endLine
    syscall

    li $v0, 5              # Gets the input from the user - like what operation we want to proceed  - $t2
    syscall
    move $t2, $v0

    beqz $t2, Exit         # Exit if the user enters 0
                           # Process the user's choice
    bgt $t2, 5, Exit
    beq $t2, 5, Single
    bne $t2, 5, Twoinputs
    
# Only one number is needed for the factorial logic    
Single:
    li $v0, 4
    la $a0, string2        # Displays the statement - "Enter the number "
    syscall

    li $v0, 5              # Gets the input from the user
    syscall
    move $t0, $v0

    beq $t2, 5, Factorial  # if the user selected factorial, then the branch statement jumps to "Factorial logic"

# More than one number is needed for the add, sub, div and mul logic
Twoinputs:
    li $v0, 4
    la $a0, string2        # Displays the statement - "Enter the number "
    syscall

    li $v0, 5
    syscall                # Gets the input from the user - and store it in $t0
    move $t0, $v0

    li $v0, 4
    la $a0, string2        # Displays the statement - "Enter the number "
    syscall

    li $v0, 5  
    syscall                # Gets the input from the user - and store it in $t1
    move $t1, $v0

    beq $t2, 1, Addition   # Based on the user selected the operations, the code will jump to its corresponding logic
    beq $t2, 2, Subtraction
    beq $t2, 3, Division
    beq $t2, 4, Multiplication
    
# This Addition logic C = A + B, or allows more than two operands
Addition:
    
    add $t3, $t0, $t1
    move $a0, $t3

    addLoop:             # This loop allows for n number of numbers to be added until the user hit 0 
       li $v0, 4
       la $a0, string2
       syscall

     # Gets the number from the user
       li $v0, 5
       syscall
       move $t0, $v0

       beqz $t0, printSum   # Exit the loop if the user enters 0

       add $t3, $t3, $t0    # Accumulate the sum
  
       j addLoop

printSum:                 # Displays the addition output and then starts to ask the user if they would like to have another operation
    li $v0, 4
    la $a0, addition
    syscall

    move $a0, $t3
    li $v0, 1
    syscall
    j inputLoop           # jumps back to inputLoop to get the next operation as input 
 
# This Subtraction logic C = A - B, or allows more than two operands
   
Subtraction:
    
    sub $t3, $t0, $t1
    move $a0, $t3
   
    subLoop:                # This loop allows for n number of numbers to be subtracted until the user hit 0
       li $v0, 4
       la $a0, string2
       syscall

                            # Gets the number from the user
       li $v0, 5
       syscall
       move $t0, $v0

       beqz $t0, printSub   # Exit the loop if the user enters 0

       sub $t3, $t3, $t0       # Accumulate the sub
  
       j subLoop               # jumps back to inputLoop to get the next operation as input

printSub:                      # Displays the subtraction output and then starts to ask the user if they would like to have another operation
    li $v0, 4
    la $a0, subtraction
    syscall
   
    move $a0, $t3
    li $v0, 1
    syscall
    j inputLoop

# The Division logic C = A / B, or allows more than two operands (integer result is OK)
Division:
    
    div $t0, $t1
    mflo $t3
    move $a0, $t3

    divLoop:                # This loop allows for n number of numbers to be divided until the user hit 0
       li $v0, 4
       la $a0, string2
       syscall

                            # Gets the number from the user
       li $v0, 5
       syscall
       move $t0, $v0

       beqz $t0, printDiv   # Exit the loop if the user enters 0

       div $t3, $t0
       mflo $t3
  
       j divLoop            # jumps back to divLoop to get the next number

printDiv:                   # Displays the division output and then starts to ask the user if they would like to have another operation

    li $v0, 4
    la $a0, division
    syscall

    move $a0, $t3
    li $v0, 1
    syscall
    j inputLoop             # jumps back to inputLoop to get the next operation as input


# The Division logic C = A x B, or allows more than two operands
Multiplication:      
    
    mul $t3, $t0, $t1
    move $a0, $t3

    mulLoop:                # This loop allows for n number of numbers to be multiplied until the user hit 0
       li $v0, 4
       la $a0, string2
       syscall

                            # Gets the number from the user
       li $v0, 5
       syscall
       move $t0, $v0

       beqz $t0, printMul   # Exit the loop if the user enters 0

       mul $t3, $t3, $t0
  
       j mulLoop          

printMul:                 # Displays the multiplication output and then starts to ask the user if they would like to have another operation

    li $v0, 4
    la $a0, multiplication
    syscall

    move $a0, $t3
    li $v0, 1
    syscall
    j inputLoop               # jumps back to inputLoop to get the next operation as input       

# The Factorial logic Factorial: N! = N x (N-1)!
Factorial:
    
    move $t4, $t0

    li $t3, 1                          # Initialize the result to 1
    li $t5, 1                          # Initialize the counter to 1

FactorialLoop:
    ble $t5, $t4, MultiplyFactorial    # Check if the counter <= number

    li $v0, 4
    la $a0, factorial
    syscall

    move $a0, $t3      # Displays the factorial output and then starts to ask the user if they would like to have another operation
    li $v0, 1
    syscall
    j inputLoop         # jumps back to inputLoop to get the next operation as input

MultiplyFactorial:
    mult $t5, $t3       # Multiply the counter with the result
    mflo $t3            # Move the result from LO register to $t3
    addi $t5, $t5, 1    # Increment the counter
    j FactorialLoop     # Jump to the beginning of the loop
        

Exit:
    # Displays the Thank you note - when the user hit 0 to exit the operation or gives an invalid operation line number > 5
    li $v0, 4
    la $a0, string4
    syscall

    li $v0, 10
    syscall