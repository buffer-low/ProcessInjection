global start

section .text

start:
	mov rax, 8
	and rax, rsp
	je main_routine
	sub rsp, 8
	jmp main_routine
	strcmp:
		push rdx
		push rcx
		push rsi
		push rdi
		
		strcmp_loop:
			xor rax, rax
			mov al, byte [rcx]
			mov ah, byte [rdx]
			test al, al
			je break_strcmp_loop
			test ah, ah
			je break_strcmp_loop
			sub al, ah
			xor ah, ah
			inc rcx
			inc rdx
			test al, al
			je strcmp_loop
		
		break_strcmp_loop:
		pop rdi
		pop rsi
		pop rcx
		pop rdx
		ret 
	
	main_routine:
	sub rsp, 400h
	mov rax, gs:[0x30]
	mov rax, ds:[rax + 0x60]
	mov rax, [rax + 24]
	mov rax, [rax + 10h]
	mov rax, [rax]
	mov rax, [rax]
	mov rax, [rax + 30h]
	
	mov [rsp + 400h], rax ; kernel32 base
	mov rbx, [rsp + 400h]
	xor rax, rax
	mov al, [rbx + 0x3c]
	add rbx, rax
	add rbx, 4
	add rbx, 20
	add rbx, 112
	xor rax, rax
	mov eax, [rbx]
	add rax, [rsp + 400h]
	mov [rsp + 3f8h], rax ; export data directory VA
	mov rbx, [rsp + 3f8h]
	xor rdi, rdi
	mov edi, [rbx + 28]
	add rdi, [rsp + 400h] 
	mov [rsp + 3f0h], rdi ;; export address VA 
	xor rsi, rsi
	mov esi, [rbx + 32]
	add rsi, [rsp + 400h] ; name pointer VA
	xor rdi, rdi
	mov edi, DWORD  [rbx + 36]
	add rdi, [rsp + 400h] ; orinal table
	xor rax, rax
	mov [rsp], rax ; count variable
	findFunctionLoop:
		xor rcx, rcx
		mov ecx, [rsi]
		add rcx, [rsp + 400h]
		mov rax, 41797261h
		mov [rsp + 200h], rax
		mov rax, 7262694c64616f4ch
		mov [rsp + 1f8h], rax
		lea rdx, [rsp + 1f8h]
		call strcmp
		test rax, rax
		jne findGetProcAddress
		mov rax, [rsp]
		inc rax
		mov [rsp], rax
		xor rax, rax
		mov ax, [rdi]
		shl rax, 2
		add rax, [rsp + 3f0h]
		xor rbx, rbx
		mov ebx, [rax]
		add rbx, [rsp + 400h]
		mov [rsp + 3e8h], rbx ; LoadLibraryA VA
		jmp breakFindFunctionLoop
		
		findGetProcAddress:
		xor rcx, rcx
		mov ecx, [rsi]
		add rcx, [rsp + 400h]
		mov rax, 737365726464h
		mov [rsp + 200h], rax
		mov rax, 41636f7250746547h
		mov [rsp + 1f8h], rax
		lea rdx, [rsp + 1f8h]
		call strcmp
		test rax, rax
		jne breakFindFunctionLoop 
		mov rax, [rsp]
		inc rax
		mov [rsp], rax
		xor rax, rax
		mov ax, [rdi]
		shl rax, 2
		add rax, [rsp + 3f0h]
		xor rbx, rbx
		mov ebx, [rax]
		add rbx, [rsp + 400h]
		mov [rsp + 3e0h], rbx ; GetProcAddress VA
		
		breakFindFunctionLoop:
		mov rax, [rsp]
		add rsi, 4
		add rdi, 2
		cmp rax, 2
		jl findFunctionLoop
	
	mov rax, 6c6ch
	mov [rsp + 200h], rax
	mov rax, 642e323372657355h
	mov [rsp + 1f8h], rax
	lea rcx, [rsp + 1f8h]
	mov rax, [rsp + 3e8h]
	call rax
	
	mov rcx, rax ; User32.dll HANDLE
	mov rax, 41786fh
	mov [rsp + 200h], rax
	mov rax, 426567617373654dh
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, [rsp + 3e0h]
	call rax
	mov [rsp + 3d8h], rax ; MessageBoxA VA
	
	mov rax, 6ch
	mov [rsp + 200h], rax
	mov rax, 6c642e6c6c64746eh
	mov [rsp + 1f8h], rax
	lea rcx, [rsp + 1f8h]
	mov rax, [rsp + 3e8h]
	call rax
	
	mov rcx, rax ; ntdll.dll handler
	mov rax, 64h
	mov [rsp + 200h], rax
	mov rax, 6165726854726573h
	mov [rsp + 1f8h], rax
	mov rax, 55746978456c7452h
	mov [rsp + 1f0h], rax
	lea rdx, [rsp + 1f0h]
	mov rax, [rsp + 3e0h]
	call rax
	mov [rsp + 3d0h], rax ; RtlExitUserThread VA
	
	xor rax, rax
	mov rcx, rax
	mov rax, 646c72h
	mov [rsp + 200h], rax
	mov rax, 6f57206f6c6c6548h
	mov [rsp + 1f8h], rax
	lea rdx, [rsp + 1f8h]
	mov rax, 6e6f6974706143h
	mov [rsp + 1f0h], rax
	lea r8, [rsp + 1f0h]
	xor rax, rax
	mov r9, rax
	mov rax, [rsp + 3d8h]
	call rax
	
	mov rax, 0
	mov rcx, rax
	mov rax, [rsp + 3d0h]
	call rax