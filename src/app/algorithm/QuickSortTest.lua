--
-- Author: <wangguojun@playcrab.com>
-- Date: 2017-03-01 21:46:18
--
local list = {4,6,2,7,8,1,9,3}
local count = 1
local function divsion( list,left,right )
	local baseNum = list[left]
	while left < right do
		while left < right and list[right] >= baseNum do
			right = right - 1
		end
		print("right",right)
		list[left] = list[right]
		while left < right and list[left] <= baseNum do
			left = left + 1
		end
		print("left",left)
		list[right] = list[left]
	end
	list[left] = baseNum
	return left
end
local function quickSort( list,left,right )
	print("count",count,"left",left,"right",right)
	-- if left >= right-1 or count >= 100 then return end
	if left < right and count <= 1000 then 
		count = count+1
		-- 划分
		local i = divsion(list,left,right)
		dump(list,"i" .. i)
		-- 递归
		quickSort(list,left,i-1)
		quickSort(list,i+1,right)
	end
end

quickSort(list,1,#list)

local list1 = {4,6,2,7,8,1,9,3,3}

local function selectSort( list )
	for i=1,#list do
		local tempIndex = i
		local tempValue = list[i]
		for i1=i,#list do
			if list[i1] > tempValue then
				tempIndex = i1 
				tempValue = list[i1]
			end
		end
		list[i],list[tempIndex] = list[tempIndex],list[i]
	dump(list,"i=".. i .." tempIndex=" .. tempIndex )
	end
end

-- selectSort(list1)

local list2 = {4,1,2,7,8,1,9,6,3}

local function insertSort( list )
	for i=1,#list do
		local temp = list[i]
		local j = i-1
		while j>0 and list[j] > temp do
			print("i",i,j)
			list[j+1] = list[j]
			j=j-1
		end
		list[j+1] = temp
	end
	dump(list)
end

-- insertSort(list2)
local list3 = {4,1,2,7,8,0,9,6,3}
local function shellSort( list )
	local step = math.floor(#list/2)
	while step >= 1 do
		for i=step,#list do
			local temp = list[i]
			local j = i-step
			-- print("i.",i,"  step:",step,"===========")
			while j>0 and list[j] > temp do
				-- print("...........j.",j)
				list[j+step] = list[j]
				-- dump(list)
				j = j - step
			end
			list[j+step] = temp
			-- dump(list)
		end
		step = math.floor(step/2)
	end
	dump(list)
end

-- shellSort(list3)

local function bineraSearch( list,value )
	local half = math.floor(#list/2)
	while (half> 1) and (half < #list) do
		count = count+1
		if count > 100 then return end
		print("half..",half,list[half]==value,list[half])
		if list[half] == value then
			return half
		else
			if list[half] > value then
				half = math.floor(half/2)
			else
				half = math.floor((half+#list)/2)
			end
		end
		print("half..11",half)
	end
end

local function bineraSearch( list,value )
	local low = 1
	local high =#list
	while(low <= high) do
		local middle = math.floor((low+high)/2)
		if list[middle] == value then 
			return middle 
		else
			if list[middle] > value then
				high = middle-1
			else
				low = middle+1
			end
		end
	end
end

-- print("查找。。。。。3",bineraSearch(list3,3))
-- print("查找。。。。。4",bineraSearch(list3,4))
-- print("查找。。。。。5",bineraSearch(list3,5))
-- print("查找。。。。。6",bineraSearch(list3,6))
-- sop = {}
-- print("heloo" .. sop.good)