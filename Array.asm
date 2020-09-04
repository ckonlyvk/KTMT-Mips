.data
    mang:.word 1000
    sophantu: .asciiz "Nhap so phan tu cua mang: "
    cacphantu: .asciiz  "Nhap cac phan tu:\n"
    bien:.asciiz "\n********************************************************************"
    cau1:.asciiz "\n*Chon 1 - Xuat cac phan tu                                         *"
    cau2:.asciiz "\n*Chon 2 - Tinh tong cac phan tu                                    *"
    cau3:.asciiz "\n*Chon 3 - Liet ke cac phan tu la so nguyen to                      *"
    cau4:.asciiz "\n*Chon 4 - Tim max                                                  *"
    cau5:.asciiz "\n*Chon 5 - Tim phan tu co gia tri x(nguoi dung nhap vao) trong mang *"
    cau6:.asciiz "\n*Chon 6 - Thoat chuong trinh                                       *"
    chon:.asciiz "\nXin moi chon chuc nang:"
    xuatphantu:.asciiz  "\nCac phan tu la:"
    xuattongcacphantu:.asciiz "Tong cac phan tu la: "
    xuongdong:.asciiz "\n"
    ngto:.asciiz "So nguyen to la: "
    khongngto:.asciiz "Khong co so nguyen to trong mang"
    giatrimax:.asciiz "Gia tri max la: "
    gtrix:.asciiz "Xin moi nhap gia tri cua x: "
    vitrix:.asciiz "Vi tri cua X la: "
    khongcovitrix:.asciiz "Khong co vi tri cua X trong mang"
    space: .asciiz " " 
.text	

	
main:
		
	jal nhapsophantu
	move $k0,$sp	# Giu dia chi dau tien cua stack
	la $t8,mang	# Giu dia chi dau tien cua mang
	la $t9,mang	# Mang luu cac phan tu

	li $v0,4
	la $a0,cacphantu
	syscall

	jal nhapcacphantu
	
	jal menu	

	li $v0,10
	syscall

nhapsophantu:
	li $v0,4
	la $a0,sophantu
	syscall

	li $v0,5
	syscall
			
	move $t0,$v0
	sle $t1,$t0,$zero
	sge $t2,$t0,1000

	beq $t1,1,nhapsophantu
	beq $t2,1,nhapsophantu
	jr $ra


nhapphantu:
	li $v0,5
	move $a0, $zero
	syscall
			
	move $t1,$v0  		# Luu gia tri nhap vao $t1


	sw $t1,($t9)
	addi $t9,$t9,4	
			
	jr $ra

nhapcacphantu:
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4	
	beq $t2,$t0,quayvemain	# Dieu kien thoat lap va tro lai ham main
	addi $t2,$t2,1		# Bien dem
	jal nhapphantu
	j nhapcacphantu

quayvemain:
	move $sp,$k0	
	lw $k1,($sp)
	jr $k1

menu:
	sw $ra,($sp)		# Luu vi tri quay ve cho menu
	
	move $sp,$k0
	subu $sp,$sp,4		# Cho stack quay ve vi tri thu 2
	move $t9,$t8		# Cho mang quay ve vi tri dau

	move $t2,$zero		# Dat bien dem ve 0
	move $t5,$zero 		# Dat lai bien tong ve 0

	li $v0,4
	la $a0,bien
	syscall
	la $a0,cau1
	syscall
	la $a0,cau2
	syscall
	la $a0,cau3
	syscall
	la $a0,cau4
	syscall
	la $a0,cau5
	syscall
	la $a0,cau6
	syscall
	la $a0,bien
	syscall
	la $a0,chon
	syscall

	li $v0,5		#chon chuc nang
	syscall
	
	move $s7,$v0 		# Luu gia tri chon chuc nang choh $s7

	jal xuatcacphantu
	jal tongcacphantu
	jal ktsonguyento
	jal max
	jal giatrix
	jal thoatchuongtrinh

	j menu

xuatcacphantu:
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4
	bne $s7,1,quayve	# So sanh voi chuc nang da chon
	beq $t2,$t0,quayve  	# Dieu kien thoat lap
	addi $t2,$t2,1 		# Bien dem
			
	

	lw $t4,($t9)		# Lay gia tri phan tu trong mang
	addi $t9,$t9,4		# Nhay sang o chua phan tu ke tiep

	li $v0,1
	addi $a0,$t4,0
	syscall

	li $v0,4
	la $a0,space
	syscall
	j xuatcacphantu


tongcacphantu:
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4
	bne $s7,2,quayve	# So sanh voi chuc nang da chon

	beq $t2,$t0,xuattong    # Dieu kien thoat lap
	addi $t2,$t2,1 		# Bien dem

	lw $t4,($t9)		# Lay gia tri phan tu trong mang
	addi $t9,$t9,4		# Nhay sang o chua phan tu ke tiep
			
	add $t5,$t4,$t5		# $t5 la gia tri tong cong don voi cac phan tu trong mang
			
	jal tongcacphantu
xuattong:
	li $v0,4
	la $a0,xuattongcacphantu
	syscall

	li $v0,1
	move $a0,$t5
	syscall
		 
	jal quayve


ktsonguyento:
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4
	bne $s7,3,quayve	# So sanh voi chuc nang da chon

	beq $t2,$t0,quayvemenu	# Dieu kien thoat lap
	addi $t2,$t2,1		# Bien dem cua vong lap ktsonguyento

	lw $t4,($t9)		# Lay gia tri phan tu trong mang
	addi $t9,$t9,4		# Nhay sang o chua phan tu ke tiep

	addi $s1,$zero,1	# Dat gia tri chay tu 1 de kiem tra so nguyen to
	jal songuyento
	j ktsonguyento


songuyento:	
	sw $ra,($sp)		# Luu gia tri quay ve ktsonguyento
	subu $sp,$sp,4
	blt $t4,2,quayvektsongto# Nho hon 2 thi khong phai so nguyen to quay ve ktsonguyento

	addi $s1,$s1,1		# Cho chay tu 2 va cong them 1 sau moi lan lap
	div $t4,$s1		# Lay phan tu chia cho cac so chay

	mfhi $s2		# Lay phan du cua phep chia
	
	beq $s2,$zero,ktbangchinhno # Neu chia het thi kt co bang chinh no hay khong
	j songuyento
		
quayvektsongto:
	move $sp,$k0		# Cho stack quay ve vi tri dau
	subu $sp,$sp,8		# Cho stack quay ve tri tri thu 3
		
	lw $k1,($sp)
	jr $k1
   	
ktbangchinhno:
	beq $t4,$s1,xuatnguyento
	j quayvektsongto	# Chia het nhung khong bang chinh no thi quay ve kt so nguyen to


xuatnguyento:
	addi $t7,$zero,1
	
	li $v0,1
	move $a0,$t4
	syscall

	li $v0,4
	la $a0,space
	syscall

	j quayvektsongto
	
quayvemenu:
	bgt $t7,$zero,quayve

	li,$v0,4
	la $a0,khongngto
	syscall

	j quayve

max: 
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4
	bne $s7,4,quayve	# So sanh voi chuc nang da chon

	beq $t2,$t0,xuatmax  	# Dieu kien thoat lap
	addi $t2,$t2,1

	lw $t4,($t9)
	addi $t9,$t9,4
	jal sosanh
	j max

sosanh:
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4

	blt $t6,$t4,gangiatri	# Gan gia tri lon cho $t6
	jr $ra

gangiatri:
	move $t6,$t4		# Gan gia tri lon cho $t6
	jr $ra

xuatmax:
	li $v0,4
	la $a0,giatrimax
	syscall
		
	li,$v0,1
	add $a0,$zero,$t6
	syscall

	j quayve

giatrix: 
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4
	bne $s7,5,quayve	# So sanh voi chuc nang da chon

	li $v0,4
	la $a0,gtrix
	syscall

	li $v0,5
	syscall

	move $t7,$v0

	jal timvitrix
	j quayve

timvitrix:
	beq $t2,$t0,khongtimdc  # Dieu kien thoat lap
	addi $t2,$t2,1		# Bien dem
				
	lw $s0,($t9)
	addi $t9,$t9,4

	beq $s0,$t7,xuatvitrix
			
	j timvitrix

xuatvitrix:
	li $v0,4
	la $a0,vitrix
	syscall

	li $v0,1
	add $a0,$zero,$t2
	syscall

	j quayvegiatrix

quayvegiatrix:
	move $sp,$k0		# Cho stack quay ve vi tri dau
	subu $sp,$sp,8		# Cho stack quay ve tri tri thu 3
		
	lw $k1,($sp)
	jr $k1	


khongtimdc:
	li $v0,4
	la $a0,khongcovitrix
	syscall		

	j menu

quayve:
	move $sp,$k0
	subu $sp,$sp,4	
	lw $k1,($sp)
	jr $k1

thoatchuongtrinh:
	sw $ra,($sp)		# Luu gia tri quay ve
	subu $sp,$sp,4
	bne $s7,6,quayve	# So sanh voi chuc nang da chon

	move $sp,$k0
		
	lw $k1,($sp)
	jr $k1	






