print("Intro to computer system");
--[[
#1:Ints are not Integers,Floats are not Reals

	Computer Arithmetic
		Does not generation ramdom values
		"usual" mathematical properties
		Observation

#2:You`ve Got to Know Assembly
	Nerver write programs in assembly
	But:Understanding assembly is key to machine-level execution model

#3：Memory Matters
	Ramdom Access Memoty is an Unphysical Abstraction
		Memory is not unbounded
		Memory referencing bugs especially pernicious
		Memory referencing Errors
			C and C++ do not provide any memory protection
			Can lead to nasty bugs
			How can I deal with this?
				Program in Java,Ruby or ML

#4:There`s more to performance than asymptotic complexity
	Memory system performance example

#5:Computers do more than execute programs
	Role within CS/ECE curriculum
	Course perspective
	Power programmers
		Manage the flow of data
		Manage concurrency

15-213/18-213 and 15-513
Textbooks
	Randal E.Bryant and David R. O`Hallaron,
		"Computer Systems:A Programmer`s Perspective,Second Edition"(CS:APP2e),Prentice Hall,2011
		https://csapp.cs.cmu.edu

	Brian Kernighan and Dennis Ritchie,
		"The C Programming Language,Second Edition",Prentice Hall,1988

Cheting
	-What is ?
		Sharing code:by copying,retyping,looking at,or supplying a file
		Coaching:help your friend to write alab,line-by-line
		Copying code from previous course
	What is not ?
		Explaining how to use systems or tools
		Helping others with high-level design issues


Binary Representations
	Base 2 Number Representation
	Electronic implementation

Encoding Byte Values
	Byte = 8 bits
		Binary
			00000000(2) to 11111111(2)
		Decimal	
			0(10) to 255(10)
		Hexadecimal
			00(16) to FF(16)
			'0' to '9' and 'A' to 'F'

Data Representations
	C:char\short\int\long\long long\float\double\long double\pointer

Boolean Algebra
	Algebraic representation of logic
		Encode "True" as 1 and "False" as 0
	And\Or\Not\Exclusive-Or(Xor)
		A&B\A|B\~A\A^B
Example:Representing & Manipulating Sets
	Representation
		width w bit vector represents subsets of {0,...,w-1}
		a(j) = 1 if j ∈ A
			01101001 {0,3,5,6}
			76543210

			01010101 {0,2,4,6}
			76543210
	Operations
		&	Intersection			01000001 {0,6}
		|	Union					01111101 {0，2，3，4，5，6}	
		^	Symmetirc difference	00111100 (2,3,4,5)
		~	Complement				10101010 {1,3,}
Contrast: Logic Operations in C
	Cotrast to Logical Operators
		&&,||,!
			View 0 as "False"
			Anyting nonzero as "True"
			always return 0 or 1
			Early termination
Shift Operations
	Left Shift:		x << y
		Shift bit-vector x left y positions
			- Throw away extra bits in left
		Fill with 0`s on right
	Right Shift:	x >> y
		Shift bit-vector x right y positions
			Throw awat extra bits on right
		Logical shift
			Fill with o`s on left
		Arthmetic shift
			Replicate most signficant bit on left
	Undefined Behavior
Encoding Integers
	Unsigned
	Two`s Complement
	C short 2 bytes long
		x 	15213 3B 6D	0011101101101101
		y  -15213 C4 93 1100010010010011
	Sign Bit
		For 2`s complement,most significant bit indicates sign
			0 for nonnegative
Numeric Ranges
	Values for W = 16
	UMax	65535	FF FF	1111111111111111
	TMax	32767	7F FF	0111111111111111
	TMin   -32768	80 00	1000000000000000
	-1	   	   -1	FF FF	1111111111111111
	 0		   	0	00 00	0000000000000000
Conversion Visualized
	2`s Comp. -> Unsigned
		Ordering Inversion
		Negative -> Big Positive
Signed vs. Unsigned in C
	Constants
	Casting
Summary:
	Expanding,Truncating:Basic Rules
		Expanding(e.g., short int to int)
			Unsigned: zeros added
			Signed: sign extension
			Both yield expected result
	Truncating(e.g., unsigned to unsigned short)
	]]--