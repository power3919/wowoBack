module("ModifyData",package.seeall)

sceneNumber = 1
chapterNumber = 1 
starNumber = 0

--设置场景数
function setSceneNumber(num)
	sceneNumber = num
end
--设置关卡数
function setChapterNumber(num)
	chapterNumber = num
end
--得到场景数
function getSceneNumber()
	return sceneNumber
end
--得到关卡数
function getChapterNumber()
	return chapterNumber
end
--设置星星数
function setStarNumber(num)
	starNumber = num
end
--得到星星数
function getStarNumber()
	return starNumber
end

--写入沙盒路径
function writeToDoc(str)
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
    local f = assert(io.open(docpath, 'w'))
    f:write(str)
    f:close()
end

--从沙盒路径下读出
function readFromDoc()
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
	-- local f = assert(io.open(docpath, 'r'))
 --  	local str = f:read("*all")
 --  	f:close()
 	local str = cc.FileUtils:getInstance():getStringFromFile(docpath)
  	return str
end
