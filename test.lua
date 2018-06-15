--[[
--table用法：一维阵列
local t = {2,3,4,5,6,7,8,9,11}

print(t[3])

for i = 1,#t do
	print(t[i].." ")
end

--二维阵列
local t = {
	{1,1,1},
	{2,2,2},
	{3,3,3,}
}

print(t[2][2])

print(t[3][1])

--加入、插入阵列元素，不定义长度
local t = {}
t[1]=2
t[#t+1]=3
table.insert(t,1,4)

for i = 1,#t do
	print(t[i].." ")
end

--字符串索引
local t ={
	["a"] = "apple",
	["b"] = "body",
	["c"] = "cool"
}
print(t["a"])

--另外一种方式
local t = {
	a = "apple",
	b = "baby",
	c = "cool"
}

print(t["a"])

--使用t.a 表示t["a"]
local peter = {
	name = "peter",
	height = 180
}

print(peter.height) --180

--更复杂的引用
local family = {
	sister={
	name="Caoxu"
	},
	father={
	name="Rongnian"
	},
	mother={
	name="Aiqin"
	}
}

print(family.sister.name) --Caoxu

print(family["father"]["name"]) --Rongnian


--遍历复杂阵列
local family = {
	sister={
	name="Caoxu"
	},
	father={
	name="Rongnian"
	},
	mother={
	name="Aiqin"
	}
}

for key,value in pairs(family) do
	print(key,value.name)
end
	--sister	Caoxu
	--father	Rongnian
	--mother	Aiqin

--ipairs和pairs的差异
local t = {
	a=100,10,20,[5]=30
}

for key,value in ipairs(t) do
	print(key,value)
end
	--1 10

	--2 20

local t = {
	a=100,10,20,[5]=30
}

for key,value in pairs(t) do
	print(key,value)
end
	--1 10

	--2 20

	--a 100

	--5 30
]]--

local t={1,3,5,7,9}
table.remove(t,3)

for i,v in ipairs(t) do
    print(i,v)
    --1 1

    --2 3

    --3 7

    --4 9

end