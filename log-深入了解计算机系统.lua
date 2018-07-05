print("深入理解计算机系统-笔记");
--[[
-深入理解计算机系统

	-#1 计算机系统漫游

-Part 1 程序结构和执行
	-#6 存储器层次结构
		memory system、cache memory、 main memory、locality、SRAM、DRAM、ROM、HDD、SSD、memory mountain
		-6.1 存储技术
			-6.1.1 随机访问存储器 Ramdom-Access Memory,RAM
				静态ROM(SRAM)
					用途	高速缓存存储器，CPU 芯片上或片下
					原理	双稳态存储器单元(bistable),六晶体管电路
						无限期保持在两个不同电压配置或状态之一，其他任何状态都不稳定
						左稳态、右稳态、亚稳态(metastable)
					应用	通电状态永远保持它的值，即使有干扰(电子噪音)扰乱电压，当干扰消除，电路就会恢复到稳定值
				动态ROM(DRAM)
					用途	主存或图形系统的帧缓冲区
					原理	每个位存储对电容充电，每个30*10^15法拉 (femtofarad)
						对干扰非常敏感，当电容电压被扰乱就永远不会恢复了，暴露在光线下会导致电容电压改变，数码相机和摄像机传感器本质就是 DRAM 单元阵列
						会漏电，10~100毫秒时间失去电荷，幸运的是计算机运行时钟周期以纳秒计算，保持时间相对来说比较长
					应用	内存以周期性读出，然后重刷内存每一位，有些系统使用纠错码，可以纠正字节级的错误
				传统 DRAM
					超单元(supercell),单元(bit),行,列.设超单元 d = 16 supercell,单元 w = 8 bit,行 r = 4,列 c = 4,地址(i,j) = (2,1).信息通过引脚(pin)流入流出芯片,2组引脚,8个 data 引脚,2个 addr 引脚,携带2位行和列的超单元
				关于术语(DRAM)
					存储领域中，计算机架构师称之为"单元"，电路设计者倾向为"字"，本书为避免歧义采用"超单元"
					内存控制器( memory controller )
					行访问选通脉冲( Row Access Strobe ) RAS
					列访问选通脉冲( Column Access Strobe) CAS
				内存模块(memory module)
					双列直插内存模块(Dual Inline Memory Module,DIMM)
						Core i7,64位芯片
				增强 DRAM
					快页模式 DRAM(Fast Page Mode DRAM,FPM DRAM)
					扩展数据输出 DRAM(Extended Date Out DRAM,EDO DRAM)
					同步 DRAM(Synchronous DRAM,SDRAM)
					双倍数据速率同步 DRAM(Double Data-Rate Synchronous DRAM,DDR SDRAM)
						DDR(2Bit),DDR2(4Bit),DDR3(8Bit),Intel Core i7只支持 DDR3 SDRAM
					视频 RAM(Video RAM,VRAM)
				非易失性存储(nonvolatile memory)
					即使关电后,仍然保存信息.由于历史原因,ROM 有的类型可读可写,但是整体上都成为只读存储器(Read-Only Memory,ROM)
					可编程 ROM(Programmable ROM,PROM)
						熔丝(fuse),只可高电流熔断一次
					可擦写可编程 ROM(Erasable Programmmable ROM,EPROM)
					电子可擦除 PROM(Electrically Erasable PROM,EEPROM)
					闪存(flash memory)
						基于 EEPROM, 包括固态银盘(Solid State Disk,SSD)
					固件(firmware)
						包括基本输入\输出系统(BIOS)
				访问主存
					总线(bus)
					总线事务(bus transaction)
					读事务(read transaction)
					写事务(write transaction)
					I/O 桥接器(I/O bridge)
					系统总线(system bus)
					内存总线(memory bus)
					北桥(northbridge)
					南桥(southbridge)
					前端总线(Front Side Bus,FSB)
					总线接口(bus interface)
			-6.1.2 磁盘存储
				磁盘构造
					盘片(platter)
					表面(surface)
					主轴(spindle)
					旋转速率(rotational rate)
					转每分钟(Revolution Per Minute,RPM)
					磁道(track)
					扇区(sector)
					间隙(gap)
					磁盘驱动器(disk drive)
					磁盘(disk)
					旋转磁盘(rotating disk)
					柱面(cyliner)
				磁盘容量
					记录密度(recording density)(位/英寸)
					磁道密度(track density)(道/英寸)
					面密度(areal density)(位/平方英寸)
					多区记录(multiple zone recording)
					记录区(recording zone)
					磁盘容量公式
						磁盘容量=字节数/扇区 * 平均扇区数/磁道 * 磁道数/表面 * 表面数/盘片 * 盘片数/磁盘
				旁注
					单位 K(kilo)\M(mega)\G(giga)\T(tera)根据上下文明确定
					DRAM&SRAM 容量计量单位使用二进制
					磁盘&网络相关 I/O 设备容量单位使用十进制
				磁盘操作
					磁盘用读/写头(read/write head)
					传动臂(actuator arm)
					寻道(seek)
					头冲撞(head crash)
					访问时间(access time)
					寻道时间(seek time)
					旋转时间(rotational latency)
					传送时间(transfer time)
				逻辑磁盘块
					C\H\S
				连接 I/O 设备
					外围设备互联(Peripheral Component Interconnect,PCI)
						PC 和 MAC 都可以使用 PCI 总线,设计与底层 CPU 无关
					通用串行总线(Universal Serial Bus,USB)
						键盘\鼠标\调制解调器\数码相机\游戏操纵杆\打印机\外部磁盘驱动器\固态硬盘
						USB 3.0\USB 3.1
					图形卡
					主机总线适配器
						通信协议
						磁盘接口
							SCSI
							SATA
					访问磁盘
						内存映射 I/O(memory-mapped I/O)
						I/O 端口(I/O port)
						直接内存访问(Direct Memory Access,DMA)
							DMA 传送(DMA transfer)
			-6.1.3 固态硬盘(Solid State Disk,SSD)
				闪存芯片&闪存翻译层(flash translation layer)
				平均磨损(wear leveling)
			-6.1.4 存储技术趋势
				速度 SDRAM > DRAM > SSD > HDD
				应用程序的 局部性(locality)
		-6.2 局部性
		-6.3 存储器层次结构(memory hierachy)
			L0 ~ L6
			L0:寄存器
			L1:L1高速缓存(SRAM)
			L2:L2高速缓存(SRAM)
			L3:L3高速缓存(SRAM)
			L4:主存(DRAM)
			L5:本地二级存储(本地磁盘)
			L6:远程二级存储(分布式文件系统\ Web 服务器)
				安德鲁文件系统(Andrew File System,AFS)
				网络文件系统(Network File System,NFS)
			其他存储层次结构
				磁带(Tape)
			-6.3.1 存储器层次结构中的缓存
				高速缓存(cache)
				缓存(caching)
				组块(chunk)
				块(block)
				传送单元(transfer unit)
				1.缓存命中(cache hit)
				2.缓存不命中(cache miss)
					替换(replacing)&驱逐(evicting)
					牺牲块(victim block)
					替换策略(replacement policy)
						最近最少使用(LRU)
				3.缓存不命中的种类
					冷缓存(cold cache)
					强制性不命中(compulsory miss)
					冷不命中(cold miss)
					缓存暖身(warmed up)
					放置策略(placement policy)
					冲突不命中(conflict miss)
					工作集(work set)
					容量不命中(capacity miss)
				4.缓存管理
					存储层次结构的本质:
						每一层存储设备是较低一层的缓存,每一层上,某种形式的逻辑必须管理缓存,判定命中不命中,处理他们,管理缓存逻辑的可以是硬件或软件,或两者结合
					例如:
						L0:
							编译器管理寄存器文件,缓存层次结构的最高层
						L1\L2\L3:
							的缓存完全由内置缓存中的硬件逻辑管理
						L4\L5:
							虚拟内存的系统中, DRAM 主存是磁盘数据块的缓存,由操作系统软件和 CPU 上的地址翻译硬件共同管理
						L6:
							AFS 分布式文件系统中,本地磁盘是缓存,由运行在本地机器上的 AFS 客户端进程管理
			-6.3.2 存储器层次结构概念小结
				利用时间局部性
				利用空间局部性

				类型		缓存目标		缓存地址		延迟		管理设备
			CPU寄存器 4字节或8字节字 CPU寄存器		 0		编译器
				TLB 	地址翻译   芯片上的TLB		 0		硬件 MMU
			L1高速缓存	64字节块   L1高速缓存		 4		硬件
			L2高速缓存	64字节块   L2高速缓存		10		硬件
			L3高速缓存 	64字节块	  L3高速缓存		50		硬件
			虚拟内存 		4KB 页		主存 	   200		硬件+ OS
			缓冲区缓存	部分文件		主存 	   200		OS
			磁盘缓存 		磁盘扇区	磁盘驱动器     100000		控制器固件
			网络缓存		部分文件	本地磁盘    	 10000000	NFS 客户
			浏览器缓存	Web 页	本地磁盘 		 10000000	Web 浏览器
				Web 	Web 页	远程服务器磁盘 1000000000 代理服务器
		-6.4 高速缓存存储器
			早期计算机系统只有三层架构:CPU 寄存器\ DRAM 主存储器\磁盘存储
			-6.4.1 通用高速缓存存储器组织结构
				高速缓存组(cache set)
				高速缓存行(cache line)
				数据块(block)\有效位(valid bit)\标记位(tag bit)
						基本参数
				参数				描述
				S=2^s 			组数
				E 				行数
				B=2^b 		块大小(字节)
				m=log2(M)	主存物理地址位数
						衍生量
				M=2^m 		内存地址最大数量
				s=log2(S)	主索引位数量
				b=log2(B)	块偏移位数量
				t=m-(s+b)	标记位数量
				C=B*E*S 不包括像有效位和标记位开销的高速缓存大小(字节)
			-6.4.2 直接映射高速缓存(direct-mapped cache)
				1.组选择
				2.行匹配
				3.字抽取
				4.不命中时的行替换
				5.综合:运行中的直接映射高速缓存
				6.冲突不命中
					抖动(threash)
						高速缓存反复的家在和驱逐相同的高速缓存块的组
					填充字节可以修正抖动问题
			-6.4.3 组相连高速缓存(set associative cache)
				1.组选择
				2.行匹配和字选择
				3.不命中时的行替换
					最不常使用( Least-Frequently-Used,LFU)
					最近最少使用(Least-Recently-Used,LRU)
			-6.4.4 全相联高速缓存(fully asscociative cache)
				1.组选择
				2.行匹配和字选择
				TLB
			-6.4.5 有关写的问题
				写命中(write hit)
				直写(write-through)
				写回(write-back)
				修改位(dirty bit)
				写分配(write-allocate)
				非写分配(not-write-allocate)
			-6.4.6 高速缓存层次结构案例
				只保存指令的高速缓存(i-cache)
				只保存程序数据的高速缓存(d-cache)
				都保存的高速缓存(unified cache)
				Intel core i7
					Regs 
					
					L1 i-cache \ L1 d-cache
					
					L2 unified cache

					L3 unified cache
			-6.4.7 高速缓存参数的性能影响
				不命中率(miss rate)
				命中率(hit rate)
				命中时间(hit time)
				不命中处罚(miss penalty)
				1.高速缓存大小的影响
				2.块大小影响
				3.相联度影响
				4.写策略影响
					写缓冲区(write buffer)
		-6.5 编写高速缓存友好的代码
		-6.6 综合:高速缓存对程序性能的影响
			-6.6.1 存储器山(memory mountain)
				读吞吐量(read throughput)&读带宽(read bandwidth)
				紧密程序循环(tight program loop)
				时间局部性(size)&空间局部性(stride)
				硬件预取(prefetching)机制
			-6.6.2 重新排列循环以提高空间局部性
				分块技术(blocking)
				片(chunk)
				块(block)
			-6.6.3 在程序中利用局部性
				注意力集中在内循环,大部分计算和内存访问发生这里
				按照数据对象存储在内存的顺序\步长来读数据,增大空间局部性
				只要从存储器读入了一个数据对象,就尽可能多使用它,从而增大时间局部性
		-6.7 小结(Summary)
			RAM
				DRAM
				SRAM
			ROM
				Flash
				SSD











-Part 2
-Part 3
]]--