#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

#firstnum=5
#secondnum=2

#Gathering the three numbers from the user using the read command and placing each in their own variable
read -p "Please provide a number: " num1
read -p "Please provide a second number: " num2
read -p "And lastly, please provide one more number: " num3


#doing the math for each requirement of the task and then placing the result of each calculation in its own variable
sum=$((num1 + num2 + num3))
product=$((num1 * num2 * num3))

#Commented out the following because the task says to only include the sum and product, 
#so the following isn't needed
#dividend=$((firstnum / secondnum))
#fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")


#printing the results using cat and all the variables gathered earlier
cat <<EOF
I calculated the sum of your 3 numbers in the following formula: $num1 + $num2 + $num3 = $sum
I calculated the product of your three numbers in the following formula: $num1 * $num2 * $num3 = $product

EOF


#$firstnum divided by $secondnum is $dividend
#  - More precisely, it is $fpdividend
