.data
in: .asciiz "input.txt"
file_in: .asciiz "input_sort.txt"  
file_out: .asciiz "output_sort.txt"
out: .asciiz "output.txt"
buff: .space 1
buffer: .word
space: .asciiz" "
arr: .word 1000
.text
main:
	jal ReadFile

	la $s0,arr
	add $t6, $t2, $0

	addi $t6, $t1, -1
	move $t3, $t6 #$t6: So luong phan tu cua mang
	addi $t1, $0, 0	
	addi $t2, $t3, 1

	#input: t1, t2, t3
	# $t1: Vi tri left 
	# $t3: Vi tri pivot 
	jal QuickSort

	addi $t1,$0,0 #int i=0
	la $t0,arr# Luu dia chi mang tam
	addi $t2,$t6,1
	jal WriteFile
exit:
	li $v0,10
	syscall
#####################################
#Ham doc file
ReadFile:
	# Cac thanh ghi $s1 -> $s4 luu cac ky tu xuong dong
	addi $s1, $0, 13 #ky tu xuong dong 

	addi $s2, $0, 32 # khoang trang 

	addi $s3, $0, 45	#dau tru

	addi $s4,$0,10 #new feed

	# Cac thanh ghi $t0 -> $t6
	la $t0,arr #Luu dia chi mang
	addi $t1,$0,0 # i=0
	addi $t2,$0,0 #Luu kich thuoc
	#$t3 dung de luu tung ky tu tu buff
	addi $t4,$0,0 #Dung de luu cac gia tri cua mot phan tu trong mang 
	addi $t5,$0,10 # Luu hang so 
	addi $t6,$0,1 # De dinh danh so am hay duong
	
	#Mo file de doc
	li   $v0, 13       #13 = lenh sys dung de doc file
	la   $a0, file_in  #Mo file_in
	li   $a1, 0        #Chon che do doc
	li   $a2, 0       
	syscall          
	move $s0, $v0      # save the file descriptor 


#?oc tung ky tu ghep thanh 1 so hoan chinh va ghi vao mang
Lap:
	li   $v0, 14       # 14= lenh sys dung de doc 
	move $a0, $s0     
	la   $a1, buff   # Lay dia chi buff de doc
	li   $a2,  1  # Doc tung ky tu trong file vao buff
	syscall           

	lb $t3, buff # Load ky tu tu buff


	beq $t3,$s4,Lap # Neu gap ky tu dong moi bo qua 
	beqz $v0,ghivaomang #Khi ket thuc file
	beq $t3,$s3,soam # Neu gap ky tu '-'
	beq $t3,$s1,tinhkichthuoc # Gap ky tu xuong dong
	beq $t3,$s2,ghivaomang #Gap ky tu khoang trang

tinhso:	#Ghep dan dan cac ky tu va luu vao $t4 tao thanh 1 so hoan chinh
	mult $t4,$t5
	mflo $t4
	addi $t3,$t3,-48 # Vi cac ky tu load len chuoi nen phai tru 48 de sang kieu int
	add $t4,$t4,$t3
	j Lap

soam: #Danh dau so dang doc len la so am
	addi $t6,$0,-1
	j Lap

tinhkichthuoc: 
	bne $t2,$0,ghivaomang # So truoc ky tu xuong dong dau tien moi la kich thuoc
	add $t2,$t4,$0
	addi $t4,$0,0 
	j Lap

ghivaomang:# Khi gap ky tu xuong dong hoac khoang trang thi ta da duoc 1 ky tu hoan chinh de ghi vao mang	
	mult $t4,$t6
	mflo $t4

	sw $t4,($t0)

	addi $t0,$t0,4 # Dich sang phan tu ke tiep
	addi $t1,$t1,1 # Tang chi so mang len 1
	
	# Reset de chuan bi cho viec tinh toan phan tu tiep theo
	addi $t4,$0,0 
	addi $t6,$0,1 
	blt $t1,$t2,Lap

exitReadFile:
	# Close the file 
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall  
	jr $ra


####################################
#Ham ghi file
WriteFile:
	la $t3,buffer # mang giá tri dùng de ghi vao file		
	la $t0,arr#lay dia chi mang
	addi $t1,$0,0#i=0
	#$t2 chua kich thuoc mang
	#$t4 chua gia tri tung phan tu de xu ly
	#$t5 chua gia tri tung ky tu trong phan tu de ghi vao file 
	#$t6 chua gia tri tmp cua $t4 khi dao so
	addi $t6,$0,0
	#$t7,$t8 chua cac gia tri tmp trong khi tinh toan 
	addi $t9, $0, 0#Chua kich thuoc cua moi chuoi so
	# Mo file de ghi 
	li   $v0, 13       
	la   $a0, file_out   
	li   $a1, 1    
	li   $a2, 0       
	syscall          
	move $s0, $v0      
	


GhiMang: # Vong lap de ghi tung phan tu trong mang vao file
	lw $t4,($t0)
	beq $t4,$0,xulyso0
	blt $t4,$0,xulysoam 
	
	conti1:
	addi $sp, $sp, -4 #Init stack co kich thuoc 4 bytes
	sw $ra, 0($sp) #Luu $ra vao Stack trong RAM
	jal daoso

	lw $ra, 0($sp) # Restore $ra
	addi $sp, $sp, 4 #Release stack
	
	addi $sp, $sp, -4 #Init stack co kich thuoc 4 bytes
	sw $ra, 0($sp) #Luu $ra vao Stack trong RAM
	jal ghiso
	lw $ra, 0($sp) # Restore $ra
	addi $sp, $sp, 4 #Release stack


	conti2:

	addi $sp, $sp, -4 #Init stack co kich thuoc 4 bytes
	sw $ra, 0($sp) #Luu $ra vao Stack trong RAM
	jal ghikhoangtrang
	lw $ra, 0($sp) # Restore $ra
	addi $sp, $sp, 4 #Release stack

	

	addi $t0,$t0,4 # Dich sang phan tu ke tiep 
	addi $t1,$t1,1 # Tang chi so i+=1
	addi $t6,$0,0 # Bien luu so dao nguoc cua phan tu duoc reset lai
	blt $t1,$t2,GhiMang
	j exitWriteFile
xulyso0:
	addi $t5,$0,48 # 48 trong ascii ~ so 0
	sb $t5,($t3)
	
	#ghi ky tu 0 vao file
	li   $v0, 15       
	move $a0, $s0       
	move $a1, $t3     
	li   $a2, 2  
	syscall	
	j conti2
xulysoam:
	addi $t5,$0,45 # 45 trong ascii tuong duong dau tru
	sb $t5,($t3)
	
	#Dao so am thanh duong
	addi $t7,$0,-1 
	mult $t4,$t7
	mflo $t4

	#ghi ky tu tru vao file
	li   $v0, 15       
	move $a0, $s0     
	move $a1, $t3     
	li   $a2, 2       
	syscall
	j conti1

ghikhoangtrang:
	addi $t5,$0,32 # 32 trong ascii ~ ' '
	sb $t5,($t3)
	
	#ghi ky tu ' ' vao file
	li   $v0, 15       
	move $a0, $s0       
	move $a1, $t3     
	li   $a2, 2  
	syscall	
	jr $ra


daoso:
	#Chia $t4 cho 10 lay phan thuong va du 
	addi $t7,$0,10
	div $t4,$t7
	mflo $t4
	mfhi $t8 
	
	#Luu tmp gia tri dao cua chuoi $t4
	mult $t6,$t7
	mflo $t6

	add $t6,$t6,$t8	
	addi $t9, $t9, 1 # Dem so luong ky tu cua chuoi so
	bne $t4,$0,daoso #lap cho den khi $t4 = 0

	addi $t4,$t6,0	
	addi $t8, $0, 0 
	jr $ra
ghiso:	
	#Lay tung ky tu trong $t4 ghi vao file
	addi $t7,$0,10
	div $t4,$t7
	mflo $t4
	mfhi $t5
	addi $t5,$t5,48 # $t5 + 48 vi 48-> 57 la cac chu so trong ascii
	sb $t5,($t3)
	
	#Ghi ky tu vao file
	li   $v0, 15       
	move $a0, $s0       
	move $a1, $t3     
	li   $a2, 2 
	syscall
	
	addi $t8, $t8, 1 # Chi so cua chuoi so tang len 1
	blt $t8,$t9,ghiso
	
	addi $t9, $0, 0	# Reset kich thuoc ve 0 de tiep tuc th?c hien cho phan tu sau
	jr $ra


# Close the file 
exitWriteFile:
	li   $v0, 16       
	move $a0, $s0      
	syscall           
	jr $ra


#Ham tim chi so de chia doi mang thanh 2 mang con.		
partitionFunc:

add $s4, $0, $t1 #Vi tri left
add $s6, $0, $t3 #Vi tri pivot
addi $t2, $t3, -1
add $s5, $0, $t2 #Vi tri right = Vi tri pivot - 1

#input t1: left, t2: right, t3: pivot
#$s1, $s2, $s3 luu dia chi cua phan tu arr[left], arr[right], arr[pivot]
#$s4, $s5, $s6 luu vi tri cua left, right, pivot
#$s0: Dia chi mang
WhileTrue:
	addi $t7, $0, 4#kich thuoc
	mult $s4, $t7
	mflo $s1
	add $s1, $s1, $s0 #s1: Dia chi left 

	mult $s5, $t7
	mflo $s2
	add $s2, $s2, $s0 #s2: Dia chi right

	mult $s6, $t7
	mflo $s3
	add $s3, $s3, $s0 #s3: Dia chi pivot

	#Vong while thu 1
	SoSanhLeftAndPivot:
	lw $t1, ($s1)# $t1 = arr[left]
	lw $t3, ($s3)# $t3 = arr[pivot]

	bgt $s4, $s5 continue1 # left > right
	bge $t1, $t3 continue1 # arr[left] >= arr[pivot]
	
	j MoveRight
	Return1: 

	j SoSanhLeftAndPivot
	
	continue1:
	#Ket thuc vong while thu 1

	#Vong while thu 2
	SoSanhRightAndPivot:
	lw $t2, ($s2)# arr[right]
	lw $t3, ($s3)# arr[pivot]
	
	blt $s5, $s4 continue2 # right < left
	ble $t2, $t3 continue2 # arr[right] <= arr[pivot]
 
	j MoveLeft
	Return2:

	j SoSanhRightAndPivot

	continue2:
	#Ket thuc vong while thu 2

	bge $s4, $s5, continue0 # left >= right
	
	j HoanVi
	Return3: 

	addi $s4, $s4, 1 # left++
	addi $s5, $s5, -1 # right--

	j WhileTrue
continue0:
	add $t0, $0, $t1#Hoan Vi arr[left] va arr[pivot]
	add $t1, $0, $t3
	add $t3, $0, $t0
	
	sw $t1, ($s1)
	sw $t3, ($s3)	
 	
	add $t1, $0, $s4
	add $t3, $0, $s6
	add $t2, $0, $s5

	#Ket thuc ham partitionFunc
	jr $ra

QuickSort: #Thuat toan sap xep Quick Sort
	addi $sp, $sp, -20
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	sw $ra, 12($sp)
	bge $t1, $t3, exitQuickSort #Dieu kien dung: left >= pivot
	
	jal partitionFunc # Tim vi tri pos phan chia mang thanh 2 mang con.
	add $t5, $0, $s4 # $t5 = pos = partitionFunc(arr, low, high)
	sw $t5, 16($sp)

	addi $t3, $t5, -1
	lw $t1, 0($sp)
	jal QuickSort # Goi de quy cua mang tu left den (pos - 1)

	lw $t5, 16($sp)
	addi $t1, $t5, 1
	lw $t3, 8($sp)
	jal QuickSort # Goi de quy cua mang tu pos + 1 den right
			
exitQuickSort: 
	lw $t1, 0($sp)
	lw $t2, 4($sp)
	lw $t3, 8($sp)
	lw $ra, 12($sp)
	lw $t5, 16($sp)

	addi $sp, $sp, 20
	jr $ra

MoveRight: #left dich sang phai
	addi $s4, $s4, 1 # left++
	addi $s1, $s1, 4 #Tang dia chi
	j Return1


MoveLeft: #right dich sang trai
	addi $s5, $s5, -1 # right--
	addi $s2, $s2, -4 #Giam dia chi
	j Return2

HoanVi: #Hoan Vi arr[left] va arr[right]
	add $t0, $0, $t1
	add $t1, $0, $t2
	add $t2, $0, $t0
	sw $t1, ($s1)
	sw $t2, ($s2) 
	j Return3
