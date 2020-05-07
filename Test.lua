local lib = {windowCount = 0};
local Inst = Instance.new;
local RGB = Color3.fromRGB;
local uD = UDim2.new;
function lib:Create(class, props)
    local obj = Inst(class)
    for i, v in next, props do
        if i ~= "Parent" then
            obj[i] = v
        end
    end
end
function lib:NewWindow(options)
    assert(options, "Not")
    local window = {count = 0, closed = false};
    self.windowCount = self.windowCount + 1
    self.ui = self.ui or self:Create("ScreenGui",{Enabled = true,IgnoreGuiInset = true,Name = "GameMenu",ResetOnSpawn = false,Parent = game:GetService('CoreGui')})
    window.Top = self:Create("Frame",{
        BackgroundColor3 = RGB(31, 31, 31),
        BorderSizePixel = 0,
        Size = uD(0,200,0,35),
        Position = uD(0, (15 + ((210 * self.windowCount) - 210)), 0, 45),
        Name = options.Name,
        Parent = self.ui
    })
    window.Title = self:Create("TextLabel"),{
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 25,
        Text = options.Name,
        Size = UDim2.new(1,0,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = _G.Colors.textcolor,
        ZIndex = 2,
        Parent = window.Top
    })
    window.TitlePadding = self:Create("UIPadding",{
        PaddingLeft = UDim.new(0,10),
        PaddingRight = UDim.new(0,25),
        Parent = window.Title
      })
    local Button = self:Create("ImageButton",{
        BackgroundTransparency = 1,
        Image = "rbxassetid://4995866843",
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.new(0,25,0,35),
        Position = UDim2.new(0.81,0,0,0),
        ZIndex = 3,
        Parent = window.Top
    })
    window.Background = self:Create("Frame",{
        BackgroundColor3 = RGB(31, 31, 31)
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,0,0),
        AnchorPoint = Vector2.new(0.5,0),
        Position = UDim2.new(0.5,0,1,0),
        ClipsDescendants = true,
        Parent = window.Topbar
    })
    window.Sorter = self:Create("UIListLayout",{
        Padding = UDim.new(0,5),
        Parent = window.Background
    })
    window.BackgroundPadding = self:Create("UIPadding",{
        PaddingLeft = UDim.new(0,10),
        PaddingRight = UDim.new(0,10),
        PaddingTop = UDim.new(0,5),
        PaddingBottom = UDim.new(0,5),
        Parent = window.Background
    })
    return window
end

return lib



