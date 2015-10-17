
require("config")
require("cocos.init")
require("framework.init")
require("app.Data")
require("app.Class.ModifyData")
require("app.Class.ClassManager")
require("app.Class.PublicData")


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("res/ui/")

    self:enterScene("StartScene")
end

return MyApp
