local library = {windowCount = 0}

_G.Colors = _G.Colors or {}
if not _G.Colors or {}  then
  _G.Colors["dark"] = Color3.fromRGB(31,31,31)
  _G.Colors["textcolor"] = Color3.fromRGB(255,255,255)
  _G.Colors["semi-dark"] = Color3.fromRGB(31,31,31)
  _G.Colors["light-dark"] = Color3.fromRGB(45,45,45)
  _G.Colors["grey"] = Color3.fromRGB(65,65,65)
  _G.Colors["white"] = Color3.fromRGB(255,255,255)
  _G.Colors["toggle"] = Color3.new(99,255,88)
end

function library:Create(class, props)
  local object = Instance.new(class)

  for i, prop in next, props do
    if i ~= "Parent" then
      object[i] = prop
    end
  end
  object.Parent = props.Parent
  return object
end

function library:NewWindow(options)
  assert(options, "No options nigger!")
  local window = {
    count = 0,
    closed = false
  }
  self.windowCount = self.windowCount + 1
  self.ui = self.ui or self:Create("ScreenGui",{Enabled = true,IgnoreGuiInset = true,Name = "GameMenu",ResetOnSpawn = false,Parent = game:GetService('CoreGui')})
  window.Topbar = self:Create("Frame",{
    BackgroundColor3 = _G.Colors.dark,
    BorderSizePixel = 0,
    Size = UDim2.new(0,180,0,40),
    Position = UDim2.new(0, (15 + ((210 * self.windowCount) - 210)), 0, 45),
    Name = options.Name,
    Parent = self.ui
  })
  window.Title = self:Create("TextLabel",{
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextSize = 25,
    Text = options.Name,
    Size = UDim2.new(1,0,1,0),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = _G.Colors.textcolor,
    ZIndex = 2,
    Parent = window.Topbar
  })
  window.Gradient = self:Create("UiGradient",{
    Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(198, 255, 221)), ColorSequenceKeypoint.new(0.51, Color3.fromRGB(251, 215, 134)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(247, 121, 125))},
    Offset = Vector2.new(0, 0.5),
    Rotation = 1,
    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.05), NumberSequenceKeypoint.new(1.00, 0.05)},
    Parent = window.Title
  })
  window.TitlePadding = self:Create("UIPadding",{
    PaddingLeft = UDim.new(0,10),
    PaddingRight = UDim.new(0,25),
    Parent = window.Title
  })
  local UseButton = self:Create("ImageButton",{
    BackgroundTransparency = 1,
    Image = "rbxassetid://4995866843",
    ScaleType = Enum.ScaleType.Fit,
    Size = UDim2.new(0,30,0,20),
    Position = UDim2.new(0.81,0,0,0),
    ZIndex = 3,
    Parent = window.Topbar
  })
  window.Background = self:Create("Frame",{
    BackgroundColor3 = _G.Colors["semi-dark"],
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

  UseButton.MouseButton1Click:Connect(function()
    window.closed = not window.closed
    UseButton.Image = (window.closed and "rbxassetid://4995876424" or "rbxassetid://4995866843")
    window.Background.ClipsDescendants = true
    if window.closed then
			window:Resize(true, UDim2.new(1, 0, 0, 0))
		else
			window:Resize(true)
		end
  end)

  window.Topbar.Active = true
  window.Topbar.Selectable = true
  window.Topbar.Draggable = true

  --[[
  local mOuse = game:GetService('UserInputService'):GetMouseLocation()
  window.Topbar.Active = true

  window.Topbar.InputBegan:connect(function(input)
    if input.UserInputType = Enum.UserInputType.MouseButton1 then
      local objectPos = Vector2.new(mOuse.X - window.Topbar.AbsolutePosition.X, mOuse.Y - window.Topbar.AbsolutePosition.Y)
    end
  end)
  ]]

  local function GetSize()
    ySize = 0
    paddingCount = 0
    for i,v in next, window.Background:GetChildren() do
      if (not v:IsA('UIListLayout')) and (not v:IsA('UIPadding')) then
        ySize = (ySize + v.AbsoluteSize.Y) -- or (25 * window.count)
        paddingCount = paddingCount + 1
			end
    end
    return UDim2.new(1,0,0,ySize + ((5 * paddingCount) + 10))
  end

  function window:Resize(tween, udimnew)
    local size = udimnew or GetSize()
    if tween then
      self.Background:TweenSize(size,"Out", "Sine", 0.25, true)
    else
      self.Background.Size = size
    end
  end

  function window:AddLabel(text, callback)
    self.count = self.count + 1

    callback = callback or function() end
    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,25),
      Parent = self.Background
    })
    local TextLabel = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 18,
      Text = text,
      TextXAlignment = Enum.TextXAlignment.Left,
      Font = Enum.Font.GothamBold,
      Parent = Frame
    })
    self:Resize()
    return TextLabel
  end

  function window:AddButton(text, callback)
    self.count = self.count + 1

    callback = callback or function() end
    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,25),
      Parent = self.Background
    })
    local button = library:Create("ImageButton",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4759206979",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(24,24,24,24),
      Size = UDim2.new(1,0,1,0),
      Position = UDim2.new(0,0,0,0),
      ImageColor3 = _G.Colors["light-dark"],
      Parent = Frame
    })
    local label = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 18,
      Text = text,
      TextXAlignment = Enum.TextXAlignment.Center,
      Font = Enum.Font.GothamBold,
      Parent = button
    })
    button.MouseButton1Click:connect(function()
      callback()
      button.ImageColor3 = _G.Colors["grey"]
      wait(0.075)
      button.ImageColor3 = _G.Colors["light-dark"]
    end)
    self:Resize()
    return button
  end

  function window:AddToggle(text, callback, timeout, loop)
    self.count = self.count + 1

    local looped = loop or nil
    local toggle = false

    timeout = timeout or 0
    callback = callback or function() end
    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,25),
      Parent = self.Background
    })
    local TextLabel = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 18,
      Text = text,
      TextXAlignment = Enum.TextXAlignment.Left,
      Font = Enum.Font.GothamBold,
      Parent = Frame
    })
    local Trigger = library:Create("ImageButton",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4718876948",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(50,50,50,50),
      Size = UDim2.new(0,25,1,0),
      Position = UDim2.new(0.85,0,0,0),
      ImageColor3 = _G.Colors["dark"],
      Parent = Frame
    })
    local Overlay = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4719223305",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(50,50,50,50),
      Size = UDim2.new(0,0,0,0),
      AnchorPoint = Vector2.new(0.5,0.5),
      Position = UDim2.new(0.5,0,0.5,0),
      ImageColor3 = _G.Colors["toggle"],
      Parent = Trigger
    })
    Trigger.MouseButton1Click:connect(function()
      toggle = (not toggle and true or false)
      looped = loop or nil
      if toggle then
        Overlay:TweenSize(UDim2.new(1,0,1,0), "Out", "Sine", 0.25, true)
        if looped then
          while true do
            if not looped then break end
            callback(toggle)
            wait(timeout)
          end
          else
            callback(toggle)
        end
      else
        Overlay:TweenSize(UDim2.new(0,0,0,0), "Out", "Sine", 0.25, true)
        looped = false
        callback(toggle)
      end
    end)
    self:Resize()
    return Trigger
  end

  function window:AddTextBox(text, callback)
    self.count = self.count + 1

    callback = callback or function() end
    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,25),
      Parent = self.Background
    })
    local background = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4759206979",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(24,24,24,24),
      Size = UDim2.new(1,0,1,0),
      Position = UDim2.new(0,0,0,0),
      ImageColor3 = _G.Colors["light-dark"],
      Parent = Frame
    })
    local TextBox = library:Create("TextBox",{
      BackgroundTransparency = 1,
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      Font = Enum.Font.GothamBold,
      TextSize = 18,
      Text = "" or nil,
      PlaceholderText = text,
      Parent = background
    })
    TextBox.FocusLost:connect(function(...)
      callback(TextBox, ...)
    end)
    self:Resize()
    return TextBox
  end

  function window:AddDropdown(text, default, callback, list, autodots)
    assert(list, "Noting to add on list or list is nil!")
    self.count = self.count + 1

    callback = callback or function() end
    local selected = nil
    if default or default ~= nil then
      selected = default
    end
    local dropped = false

    local htext = nil
    if autodots == true then
      htext = text .. ":"
    else
      htext = text
    end

    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,40),
      Parent = self.Background
    })
    local MainBar = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4759206979",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(24,24,24,24),
      Size = UDim2.new(1,0,0,25),
      Position = UDim2.new(0.5,0,1,0),
      ImageColor3 = _G.Colors["light-dark"],
      AnchorPoint = Vector2.new(0.5,1),
      Parent = Frame
    })
    local DropButton = library:Create("ImageButton",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4748397539",
      ScaleType = Enum.ScaleType.Fit,
      Size = UDim2.new(0,20,1,0),
      Position = UDim2.new(0.85,0,0,0),
      Parent = MainBar
    })
    local DropFrame = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4747892704",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(24,24,24,24),
      Size = UDim2.new(1,0,0,0),
      AnchorPoint = Vector2.new(0.5,0),
      Position = UDim2.new(0.5,0,0.95,0),
      ImageColor3 = _G.Colors["light-dark"],
      ClipsDescendants = true,
      ZIndex = 2,
      Parent = Frame
    })
    local Heading = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Position = UDim2.new(0.5,0,0,0),
      Size = UDim2.new(1,0,0,14),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 14,
      Text = htext,
      TextXAlignment = Enum.TextXAlignment.Left,
      Font = Enum.Font.GothamBold,
      AnchorPoint = Vector2.new(0.5,0),
      Parent = Frame
    })
    local TextLabel = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 18,
      Text = selected,
      TextXAlignment = Enum.TextXAlignment.Left,
      Font = Enum.Font.GothamBold,
      Parent = MainBar
    })
    local UITextLabel = library:Create("UIPadding",{
      PaddingLeft = UDim.new(0,10),
      PaddingRight = UDim.new(0,25),
      Parent = TextLabel
    })
    local UIDropFrame = library:Create("UIPadding",{
      PaddingLeft = UDim.new(0,10),
      PaddingRight = UDim.new(0,10),
      PaddingTop = UDim.new(0,5),
      PaddingBottom = UDim.new(0,5),
      Parent = DropFrame
    })
    local Sorter = library:Create("UIListLayout",{
      Parent = DropFrame
    })

    for i,v in pairs(list) do
      local Button = library:Create("TextButton",{
        BackgroundTransparency = 1,
        TextColor3 = _G.Colors["textcolor"],
        Size = UDim2.new(1,0,0,25),
        Text = v,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        LayoutOrder = i,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
        Parent = DropFrame
      })
    end

    local function ListSize()
      ySize = 0
      for i,v in next, DropFrame:GetChildren() do
        if (not v:IsA('UIListLayout')) and (not v:IsA('UIPadding')) then
          ySize = (ySize + v.AbsoluteSize.Y)
        end
      end
      return UDim2.new(1,0,0,ySize + 10)
    end

    DropButton.MouseButton1Click:connect(function()
      dropped = (not dropped and true or false)
      DropButton.Image = (dropped and "rbxassetid://4748396613" or "rbxassetid://4748397539")
      self.Background.ClipsDescendants = (not dropped and false)
      local size = ListSize()
      if dropped then
        MainBar.Image = "rbxassetid://4747896889"
        DropFrame:TweenSize(size,"Out", "Sine", 0.25, true)
        for i,v in pairs(DropFrame:GetChildren()) do
          if (not v:IsA('UIListLayout')) and (not v:IsA('UIPadding')) then
            v.MouseButton1Click:connect(function()
              selected = v.Text
              TextLabel.Text = selected or v.Text
              dropped = false
              DropFrame:TweenSize(UDim2.new(1,0,0,0),"Out", "Sine", 0.25, true)
              MainBar.Image = "rbxassetid://4759206979"
              DropButton.Image = "rbxassetid://4748397539"
              callback(selected)
              wait(1)
              self.Background.ClipsDescendants = (dropped and true)
            end)
          end
      end
      else
        DropFrame:TweenSize(UDim2.new(1,0,0,0),"Out", "Sine", 0.25, true)
        MainBar.Image = "rbxassetid://4759206979"
        wait(1)
        self.Background.ClipsDescendants = (not dropped and true)
      end
    end)

    self:Resize()
    return TextLabel
  end

  function window:AddSlider(text, callback, max, step, snapping)
    self.count = self.count + 1
    
    if step == 0 and snapping then
      snapping = false
    end

    local Value

    callback = callback or function() end
    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,30),
      Parent = self.Background
    })
    local TextLabel1 = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Position = UDim2.new(0.5,0,0,0),
      Size = UDim2.new(1,0,0,14),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 14,
      Text = text,
      TextXAlignment = Enum.TextXAlignment.Left,
      Font = Enum.Font.GothamBold,
      AnchorPoint = Vector2.new(0.5,0),
      Parent = Frame
    })
    local TextLabel2 = library:Create("TextLabel",{
      BackgroundTransparency = 1,
      Position = UDim2.new(0,0,0,0),
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      TextSize = 14,
      Text = "0",
      TextXAlignment = Enum.TextXAlignment.Right,
      Font = Enum.Font.GothamBold,
      AnchorPoint = Vector2.new(0,0),
      Parent = TextLabel1
    })
    local cast = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4722964526",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(50,50,50,50),
      Size = UDim2.new(1,0,0,15),
      Position = UDim2.new(0.5,0,1,0),
      ImageColor3 = _G.Colors["light-dark"],
      AnchorPoint = Vector2.new(0.5,1),
      Parent = Frame
    })
    local fill = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4722964526",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(50,50,50,50),
      Size = UDim2.new(0,0,0,5),
      Position = UDim2.new(0.025,0,0.3,0),
      ImageColor3 = _G.Colors["white"],
      AnchorPoint = Vector2.new(0,0),
      Parent = cast
    })
    local slider = library:Create("ImageButton",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4722964526",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(50,50,50,50),
      Size = UDim2.new(0,15,0,15),
      Position = UDim2.new(0,0,0.5,0),
      ImageColor3 = _G.Colors["white"],
      AnchorPoint = Vector2.new(0.5,0.5),
      Parent = cast
    })
    local Padding = library:Create("UIPadding",{
      PaddingRight = UDim.new(0,15),
      Parent = cast
    })

    local UIS = game:GetService("UserInputService")
    local RUN = game:GetService("RunService")

    local held = false
    step = step or 0
    local GlobalValue = max

    UIS.InputEnded:connect(function(input,E)
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
        held = false
        end
    end)

    slider.MouseButton1Down:Connect(function()
      held = true
    end)

    function snap(number,factor)
      if factor == 0 then
        return number
      else
        return math.floor(number/factor+0.5)*factor	
      end
    end

    UIS.InputChanged:connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseMovement and held then
        local MPos = UIS:GetMouseLocation().X
        local SPos = fill.AbsolutePosition.X
        local CSize = cast.AbsoluteSize.X
        local Pos = snap((MPos-SPos)/CSize,step)
        local Precentage = math.clamp(Pos,0,1)
        slider.Position = UDim2.new(Precentage,0,slider.Position.Y.Scale,slider.Position.Y.Offset)
        fill.Size = UDim2.new(Precentage,0,fill.Size.Y.Scale,fill.Size.Y.Offset)
        local PrecValue = math.floor((GlobalValue*(Precentage*100))/100)
        Value = PrecValue
        TextLabel2.Text = PrecValue
        callback((Value or PrecValue))
      end
    end)

    --[[
    slider.MouseEnter:connect(function() 
      slider:TweenSize(UDim2.new(0,15,0,15),"Out", "Sine", 0.25, true)
      if held then
        slider:TweenSize(UDim2.new(0,15,0,15),"Out", "Sine", 0.25, true)
      end
    end)
    
    slider.MouseLeave:connect(function() 
      slider:TweenSize(UDim2.new(0,10,0,10),"Out", "Sine", 0.25, true)
      if held then
        slider:TweenSize(UDim2.new(0,15,0,15),"Out", "Sine", 0.25, true)
      end
    end)
    ]]

    self:Resize()
    return Value
  end

--[[
  function window:AddHotKeyBox(text, callback)
    self.count = self.count + 1

    callback = callback or function() end
    local Frame = library:Create("Frame",{
      BackgroundTransparency = 1,
      LayoutOrder = self.count,
      Size = UDim2.new(1,0,0,25),
      Parent = self.Background
    })
    local background = library:Create("ImageLabel",{
      BackgroundTransparency = 1,
      Image = "rbxassetid://4759206979",
      ScaleType = Enum.ScaleType.Slice,
      SliceCenter = Rect.new(24,24,24,24),
      Size = UDim2.new(1,0,1,0),
      Position = UDim2.new(0,0,0,0),
      ImageColor3 = _G.Colors["light-dark"],
      Parent = Frame
    })
    local TextBox = library:Create("TextBox",{
      BackgroundTransparency = 1,
      Size = UDim2.new(1,0,1,0),
      TextColor3 = _G.Colors["textcolor"],
      Font = Enum.Font.GothamBold,
      TextSize = 18,
      Text = "" or nil,
      PlaceholderText = text,
      Parent = background
    })

    TextBox.Focused:connect(function(...)
      game:GetService("UserInputService").InputBegan:connect(function(input, GP)
        if input.UserInputType = Enum.UserInputType.Keyboard then
          local key = input.KeyCode
          callback(TextBox,key,...)
          TextBox:Release(true)
        end
      end)
    end)

    self:Resize()
    return TextBox
  end
  --]]

return window
end -- Global End

return library
