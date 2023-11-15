MapCompassBK = CustomItem:extend()

function MapCompassBK:init(name, dungeonCode)
    self:createItem(name)
    self.code = dungeonCode .. "_mcbk"
    self:setProperty("dungeon", dungeonCode)
    self:setState(0)

    self:updateIcon()
end

function MapCompassBK:setState(state)
    self:setProperty("state", state)
end

function MapCompassBK:getState()
    return self:getProperty("state")
end

function MapCompassBK:updateIcon()
    if self:getState() < 4 then
        if self:getState() < 2 then
            if self:getState() < 1 then
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-000.png")
            else
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-010.png")
            end
        else
            if self:getState() < 3 then
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-001.png")
            else
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-011.png")
            end
        end
    else
        if self:getState() < 6 then
            if self:getState() < 5 then
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-100.png")
            else
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-110.png")
            end
        else
            if self:getState() < 7 then
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-101.png")
            else
                self.ItemInstance.Icon = ImageReference:FromPackRelativePath("images/icons/mapcompassbigkey-111.png")
            end
        end
    end
end

function MapCompassBK:onLeftClick()
    local newState = (self:getState() + 4) % 8

    self:setState(newState)
    
    local item = Tracker:FindObjectForCode(self:getProperty("dungeon") .. "_bigkey")
    if item then
        item.Active = newState & 0x4 > 0
    end
end

function MapCompassBK:onRightClick()
    local newState = (self:getState() & 0x4) + ((self:getState() & 0x3) + 1) % 4

    self:setState(newState)
    
    local item = Tracker:FindObjectForCode(self:getProperty("dungeon") .. "_map")
    if item then
        item.Active = newState & 0x1 > 0
    end

    item = Tracker:FindObjectForCode(self:getProperty("dungeon") .. "_compass")
    if item then
        item.Active = newState & 0x2 > 0
    end
end

function MapCompassBK:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function MapCompassBK:providesCode(code)
    return 0
end

function MapCompassBK:advanceToCode(code)
    if code == nil or code == self.code then
        self:setState((self:getState() + 1) % 8)
    end
end

function MapCompassBK:save()
    return {}
end

function MapCompassBK:load(data)
    local newState = 0
    local item = Tracker:FindObjectForCode(self:getProperty("dungeon") .. "_map")
    if item.Active then
        newState = newState + 1
    end
    item = Tracker:FindObjectForCode(self:getProperty("dungeon") .. "_compass")
    if item.Active then
        newState = newState + 2
    end
    item = Tracker:FindObjectForCode(self:getProperty("dungeon") .. "_bigkey")
    if item.Active then
        newState = newState + 4
    end
    self:setState(newState)
    return true
end

function MapCompassBK:propertyChanged(key, value)
    if key == "state" then
        self:updateIcon()
    end
end
