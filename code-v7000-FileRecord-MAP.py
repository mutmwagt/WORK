'''
术语规范：
简述：BS指256M，bs指256K
 
BS：指大小，256M
bs：指大小，256K
SecsPerBS：每BS扇区数
SecsPerbs：每bs扇区数
 
FRid：文件记录号
FRDs：文件记录在整个LUN上应该的物理扇区号
FRDBS：文件记录在整个LUN上应该的BS号
FRDbs：文件记录在整个LUN上应该的bs号
FRDbsiBS:文件记录所在的bs，在所在BS中的序号
FRDSibs：文件记录所在的扇区，在所在的bs中的序号
 
SMDid：位图所在的磁盘号
SMBS：位图所在的磁盘的BS号
SMbs：位图所在的磁盘的bs号
SMDs:位图的起始扇区号
 
SDid：源数据所在的磁盘号
SDBS：源数据所在的BS号
SDbs：源数据所在的bs号
SDs：源数据所在的扇区号
SDSibs：源数据所在的扇区，在所在的bs中的序号
SDbsiBS：源数据所在的bs，在所在的BS中的序号
 
Mbsi8GM：数据所在bs条目，在8G位图中的序号
MbsiBS：数据所在的bs条目，在当前BS位图中的序号
MBSi8GM：数据所在的BS条目，在8G位图中的序号
'''
import sys
import os
import struct
import sqlite3
import time
 
BS = 256 * 1024 * 1024
bs = 256 * 1024
SecsPerBS = BS // 512
SecsPerbs = bs // 512
bs_tnum = 128 * 1024 * 1024
 
 
def trans(FRid, MFT_Slice_List):
    mft_no_clus = FRid // 8
    mft_no_sec = (FRid % 8) * 2
 
    for i in MFT_Slice_List:
        if i[0] + i[2] > mft_no_clus:
            if i[0] > mft_no_clus:
                continue
 
            FRDs = (mft_no_clus - i[0] + i[1]) * 16 + mft_no_sec
            break
 
    FRDs += 262208  # DBR pos
    return FRDs
 
 
def find_FRid_SDbs(FRid):
    mftlist = []
    FRDS = trans(FRid, MFT_Slice_List)
 
    # cu_mft 是 allv2.db 的cursor
 
    cu_mft.execute(r"select * from mft_info  WHERE FRID = %d" % FRid)
    rows = cu_mft.fetchall()
    # SDid, SDS, FRid 是 row[0], row[1], row[2]
    new = 0
    for row in rows:
        if row[1] % 512 == FRDS % 512:      # 扇区号一致
            new += 1
            SDid = row[0]
            SDS = row[1]
            mftlist.append([FRid, FRDS, SDid, SDS])
 
    if new != 1:    # 所选记录不唯一， 返回空的 mftlist
        print("FR(%d), result not found or not only, new = %d, FRDS = %d" % (FRid, new, FRDS))
        # os.system("pause")
        # pass
        return
 
    return mftlist
 
 
def find_bs_SMBS(FRDs, SDid, SDs):
 
    SMDBS_list = []     # 位图列表
    FRbs = (FRDs // 512)
 
    SDBS = SDs // SecsPerBS
    SDbsiBS = (SDs % SecsPerBS) // SecsPerbs
    print("FRDs,SDid,SDs is:",FRDs,SDid,SDs)
    print("SDbsiBS is %d"%SDbsiBS)
    # cu_m 是 map_v2.db 的 cursor
    cu_m.execute(r"select * from map_info where v_num =  %d" % (FRbs * 512 + 1))  # +1: 是因为v7000 MAP最低位为1，可能表示类型
    rows = cu_m.fetchall()
    print("rows: ", rows)
    os.system("pause")
 
    x = 0
    # EM_SMDid, EM_SMBS, EM_Mbsi8GM, EM_FRDS_add_1 = range(4)
    for row in rows:
 
        Mbsi8GM = row[2]     # 数据所在bs条目，在8G位图中的序号
        FRDbsiBS = (FRDs % SecsPerBS) // SecsPerbs
        MbsiBS = (Mbsi8GM + 2) % 1024   # 数据所在的bs条目，在当前BS位图中的序号
        MBSi8GM = (Mbsi8GM + 2) // 1024  # 数据所在的BS条目，在8G位图中的序号
        print("MBSi8GM,SDbsiBS,MbsiBS is", MBSi8GM, SDbsiBS, MbsiBS)
        os.system("pause")
        if MBSi8GM == 0:
            if SDbsiBS == MbsiBS:
                x += 1
                SMDid = row[0]  # 位图所在的磁盘号
                SMBS = row[1]  # 位图所在的磁盘的BS号
                SMDBS_list.append([SMDid, SMBS, 0, SMDid, SMBS])
        else:
            if SDbsiBS == MbsiBS:
                x += 1
                SMDid = row[0]  # 位图所在的磁盘号
                SMBS = row[1]  # 位图所在的磁盘的BS号
                SMDBS_list.append([SMDid, SMBS, MBSi8GM, SDid, SDBS])
                SMDBS_list.append([SMDid, SMBS, 0, SMDid, SMBS])
 
    if x == 0:
        print("FRDs:%d result not found!" % FRDs)
        # os.system("pause")
        # pass
        print("line 131 ,x == 0")
        return
    os.system("pause")
    print(SMDBS_list)
    return SMDBS_list
 
#tmp1 writefile to disk
writedisk = False
if writedisk:
    fd = open("\\\\.\\physicaldrive3",'rb+')
def update_1Gmap(bsMapList, map1g_list):
 
    SMDid, SMBS, MBSi8GM, SDid, SDBS = bsMapList
    SMDs = SMBS * SecsPerBS + 1024
    SDbs = SDBS * 1024
 
    smFile = sDisk[SMDid][1]  # 位图所在磁盘
    sdFile = sDisk[SDid][1]  # 数据所在磁盘
 
    # 到指定位图位置，读取 bs = 256K 字节
    smFile.seek(SMDs * 512)
    mData = smFile.read(bs)
 
    if MBSi8GM == 0:  # 8GB 的第一个256K
        mapitem = struct.unpack_from("1022Q", mData, 0)
        start_sec = 1024
    elif MBSi8GM < 32:
        # print("MBSi8gm IS",MBSi8GM)
        mapitem = struct.unpack_from("1024Q", mData, MBSi8GM * 8192 - 16)  # 1024 * 8 代表一个256M
        start_sec = 0
    else:
        return
    t = 0
    keyMap = SMDid * 1000000 + SMBS * 100 + MBSi8GM
    cu.execute(r"INSERT or ignore into MAP values(%d, %d, %d, %d, %d, %d)" % (keyMap, SMDid, SMBS, MBSi8GM, SDid, SDBS))
    cx.commit()
    # print(keyMap, SMDid, SMBS, MBSi8GM, SDid, SDBS)
    # os.system("pause")
 
    for ii in mapitem:
        if ii == 3:  # 跳过位图为3的
            t += 1
            continue
 
        FRDbs = (ii - 1) // 512
 
        if FRDbs > bs_tnum:
            t += 1
            print("FRDBS is too large, FRDbs: %d" % FRDbs)
 
        else:
            value1 = (SDbs + t) * SecsPerbs  + start_sec # value指应该的bs的扇区位置
            value = value1 + (SDid << 48)
 
            # valueT = 0
 
            if map1g_list[FRDbs] != 0 and map1g_list[FRDbs] != value:
                print("FRDBS is error, FRDbs: %d,\tmap1g_list[FRDbs]:%08X\tvalue:%08X" % (FRDbs, map1g_list[FRDbs], value))
                os.system("pause")
                # pass
            else:
                map1g_list[FRDbs] = value
                #tmp1 write file
                if writedisk:
                    fd.seek(FRDbs * 512)
                    sDisk[SDid][1].seek(value * 512)
                    tmpdata = sDisk[SDid][1].read(bs)
                    fd.write()
                #tmp write file end
                # SMDid, SMBS, MBSi8GM, SDid, SDBS
            t += 1
 
sDisk = []
sDisk.append("")
sDisk.append("")
sDisk.append("")
sDisk.append("")
sDisk.append(["h:\mdisk4.img", 0])
sDisk.append(["g:\mdisk5.img", 0])
sDisk.append(["i:\mdisk6.img", 0])
sDisk.append(["d:\mdisk7.img", 0])
sDisk.append(["e:\mdisk8.img", 0])
sDisk.append(["f:\mdisk9.img", 0])
 
for disk in sDisk[4:10]:
    disk[1] = open(disk[0], 'rb')
 
cx_mft = sqlite3.connect("f:\zy\\new_mft\\allv2.db")
cu_mft = cx_mft.cursor()
cx_m = sqlite3.connect("F:\\zy\\map\\map_v2.db")
cu_m = cx_m.cursor()
cx = sqlite3.connect("f:\\zy\\map\\256M_to_disk_map.db")
cu = cx.cursor()
 
cu.execute("""create table if not exists MAP(
        mapKey INT PRIMARY KEY NOT NULL,
        SMDid int,
        SMDBS int,
        Mbsi8GM int,
        SDid int,
        SDDBS int
        );
""")
# 打开1GMAP文件，读入LIST
MAP_file = "F:\\zy\\map\\1gmap_1.img"
f_map1g = open(MAP_file, 'rb+')
dmap = f_map1g.read()
map1g_list = list(struct.unpack('%dQ' % bs_tnum, dmap))
 
# 前两个256M块
# cu.execute(r"INSERT or ignore into MAP values(%d, %d, %d, %d, %d, %d)" % (40080010, 4, 800, 10, 6, 814))
# cu.execute(r"INSERT or ignore into MAP values(%d, %d, %d, %d, %d, %d)" % (40080000, 4, 800, 0, 4, 800))
tlst = [[4, 800, 10, 6, 814], [4, 800, 0, 4, 800]]
update_1Gmap(tlst[0], map1g_list)
update_1Gmap(tlst[1], map1g_list)
 
# 解析mft_list 文件
f = open("mft_list.txt", 'r')     # 位置在哪？？
d = f.readlines()
MFT_Slice_List = []
for i in d:
    t = i.split()
    # t[0] 是 VCN 号, t[1] 是 LCN 号, t[2] 是 连续簇数
    MFT_Slice_List.append([int(t[0]), int(t[1]), int(t[2])])
 
 
# MFT的编号；在LUN中应该的扇区位置；现在所在的磁盘号；现在所在磁盘的扇区位置
# EL_FRid, EL_FRDS, EL_SDid, EL_SDS = range(4)
 
for i in MFT_Slice_List[2:]:
    print("start: ", i)
    tt = 0      # 用于累计KB数， 1 KB是一个FR
    curFRID = i[0] * 8
    curFRID = 1988304 # test1
    slice0p = trans(curFRID, MFT_Slice_List)  # 要处理的第一个bs片断的起始扇区号
 
    slice0s = 512 - slice0p % 512  # 第一个片断的扇区数
    slice0FRnum = slice0s // 2
    sliceEnd_s = (i[2] * 16 + slice0p) % 512   # 最后一个片断的扇区数
    middle_bs = (i[2] * 16 - slice0s - sliceEnd_s) // 512  # 中间有多少个bs片断
 
    for ii in range(middle_bs + 2):
        if ii == 0:  # 第一个片断
            p = slice0p
            start_fr = curFRID
            fr_num = slice0FRnum
        elif ii == middle_bs + 1:  # 最后一个片断
            p = ii * 512 - 512 + (slice0p + slice0s)
            start_fr = curFRID + slice0FRnum + ii * 256
            fr_num = sliceEnd_s // 2
        else:
            p = ii * 512 - 512 + (slice0p + slice0s)
            start_fr = curFRID + slice0FRnum + ii * 256
            fr_num = 256
 
        FRDbs = p // 512
        if map1g_list[FRDbs] != 0:
            continue
 
        isfoundmap = False
        for FRid1 in range(start_fr, start_fr + fr_num + 1):
            mftlist = find_FRid_SDbs(FRid1)  # 在这个函数中，又求了一次 FRDS, ??
            if mftlist is None:
                continue
            else:
                SMDBS_list = find_bs_SMBS(mftlist[0][1], mftlist[0][2], mftlist[0][3])
                # print("SMDBS_list: ", SMDBS_list)
                # SMDBS_list 可能完成多个匹配
                if SMDBS_list is None:
                    break
                else:
                    isfoundmap = True
                for lst in SMDBS_list:
                    # print("********************")
                    #SMDBS_list = find_bs_SMBS(lst[1], lst[2], lst[3])  # SMDBS_list 可能完成多个匹配
                    print("lins 293 ",lst)
                    update_1Gmap(lst, map1g_list)
            if isfoundmap:
                break;
            print("line296")
            os.system("pause")
        print("line 298")
        os.system("pause")
 
 
print("end:", time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())))
 
dmap = struct.pack("%dQ" % bs_tnum, *map1g_list)
 
# 更新map文件
f_map1g.seek(0)
f_map1g.write(dmap)
f_map1g.close()
 
# cu.execute(r"INSERT or ignore into MAP values(%d, %d, %d, %d, %d, %d)" % (40080010, 4, 800, 10, 6, 814))
 
# 第一个256M块
# cu.execute(r"INSERT or ignore into MAP values(%d, %d, %d, %d, %d, %d)" % (40080000, 4, 800, 0, 4, 800))
# cx.commit()
 
# BS_ID含义如下：ABBBBBCC，A表示磁盘ID，BBBBB表示本片断位图在磁盘位置(256M块编号)，CC表示本次处理的256M块的编号(0-31)
# MAP_POS表示:256M的位置，一般位图仍要向后偏移1024个扇区
# BS_ID_indisk表示8G内的256M序号
# SOURCE_POS表示源磁盘的256M的位置