-- Đặng Minh Lâm Hub - Tốc Độ Cao + Chống Phát Hiện
-- Tương thích Delta Executor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Cấu hình tốc độ cao
local CONFIG = {
    TocDoBay = 500,          -- TỐC ĐỘ CỰC CAO
    KhoangCachNhat = 15,     -- Nhặt xa hơn
    ThoiGianCho = 0.01,      -- Gần như tức thời
    PhimBatTat = Enum.KeyCode.RightShift,
    PhimAnUI = Enum.KeyCode.RightControl,
    ViTriNha = nil,
    TuDongBayVe = true,
    KillAura = false,
    PhamViKillAura = 50,
    ChongSatThuong = true,
    ChongBay = true,
    ChongKick = true,
    NoiTrong = "Tất cả",
    TocDoNhat = 0.01,
    TeleportMode = true     -- Teleport thay vì bay
}

local DangHoatDong = false
local DanhSachTrung = {}
local DaAnUI = false
local DanhSachNoiTrong = {"Tất cả", "Trứng thường", "Trứng hiếm", "Trứng event", "Trứng pet"}
local NoiTrongDaChon = "Tất cả"

-- === CHỐNG PHÁT HIỆN + CHỐNG KICK ===
pcall(function()
    if getgenv then
        getgenv().DangMinhLamHub = true
        getgenv().Hidden = true
    end
end)

-- Hook kick
pcall(function()
    local OldKick = LocalPlayer.Kick
    LocalPlayer.Kick = function() end
end)

-- Chặn kick từ remote
task.spawn(function()
    while task.wait(1) do
        if not CONFIG.ChongKick then continue end
        pcall(function()
            for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local ten = string.lower(obj.Name)
                    if string.find(ten, "kick") or string.find(ten, "ban") or string.find(ten, "remove") then
                        pcall(function()
                            obj.OnClientEvent:Connect(function() end)
                        end)
                    end
                end
            end
        end)
    end
end)

-- === GUI NGẮN GỌN ===
pcall(function()
    if CoreGui:FindFirstChild("DangMinhLamHub") then
        CoreGui.DangMinhLamHub:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DangMinhLamHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Nút mở
local NutMo = Instance.new("TextButton")
NutMo.Size = UDim2.new(0, 50, 0, 50)
NutMo.Position = UDim2.new(0, 15, 0.5, -25)
NutMo.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
NutMo.BorderSizePixel = 0
NutMo.Text = "L"
NutMo.TextColor3 = Color3.fromRGB(0, 255, 150)
NutMo.TextScaled = true
NutMo.Font = Enum.Font.GothamBlack
NutMo.Parent = ScreenGui

local NutMoCorner = Instance.new("UICorner")
NutMoCorner.CornerRadius = UDim.new(1, 0)
NutMoCorner.Parent = NutMo

local NutMoStroke = Instance.new("UIStroke")
NutMoStroke.Color = Color3.fromRGB(0, 255, 150)
NutMoStroke.Thickness = 2
NutMoStroke.Parent = NutMo

-- Frame chính (thu gọn)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 150)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- Tiêu đề
local TieuDeFrame = Instance.new("Frame")
TieuDeFrame.Size = UDim2.new(1, 0, 0, 32)
TieuDeFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
TieuDeFrame.BorderSizePixel = 0
TieuDeFrame.Parent = MainFrame

local TieuDeCorner = Instance.new("UICorner")
TieuDeCorner.CornerRadius = UDim.new(0, 8)
TieuDeCorner.Parent = TieuDeFrame

local TieuDeText = Instance.new("TextLabel")
TieuDeText.Size = UDim2.new(1, -70, 1, 0)
TieuDeText.Position = UDim2.new(0, 12, 0, 0)
TieuDeText.BackgroundTransparency = 1
TieuDeText.Text = "ĐẶNG MINH LÂM HUB  |  SPEED"
TieuDeText.TextColor3 = Color3.fromRGB(0, 255, 150)
TieuDeText.TextScaled = true
TieuDeText.Font = Enum.Font.GothamBold
TieuDeText.TextXAlignment = Enum.TextXAlignment.Left
TieuDeText.Parent = TieuDeFrame

local NutDong = Instance.new("TextButton")
NutDong.Size = UDim2.new(0, 26, 0, 26)
NutDong.Position = UDim2.new(1, -30, 0, 3)
NutDong.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
NutDong.BorderSizePixel = 0
NutDong.Text = "X"
NutDong.TextColor3 = Color3.fromRGB(255, 255, 255)
NutDong.TextScaled = true
NutDong.Font = Enum.Font.GothamBold
NutDong.Parent = TieuDeFrame

local NutDongCorner = Instance.new("UICorner")
NutDongCorner.CornerRadius = UDim.new(0, 5)
NutDongCorner.Parent = NutDong

-- Tab
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 110, 1, -32)
TabFrame.Position = UDim2.new(0, 0, 0, 32)
TabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.Parent = TabFrame

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 6)
TabPadding.PaddingLeft = UDim.new(0, 4)
TabPadding.PaddingRight = UDim.new(0, 4)
TabPadding.Parent = TabFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -110, 1, -32)
ContentFrame.Position = UDim2.new(0, 110, 0, 32)
ContentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Hàm tạo tab
local DanhSachTab = {}

local function TaoTab(Ten)
    local NutTab = Instance.new("TextButton")
    NutTab.Size = UDim2.new(1, 0, 0, 30)
    NutTab.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    NutTab.BorderSizePixel = 0
    NutTab.Text = Ten
    NutTab.TextColor3 = Color3.fromRGB(180, 180, 180)
    NutTab.TextScaled = true
    NutTab.Font = Enum.Font.GothamBold
    NutTab.Parent = TabFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 5)
    TabCorner.Parent = NutTab
    
    local Trang = Instance.new("ScrollingFrame")
    Trang.Size = UDim2.new(1, 0, 1, 0)
    Trang.BackgroundTransparency = 1
    Trang.BorderSizePixel = 0
    Trang.ScrollBarThickness = 3
    Trang.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    Trang.CanvasSize = UDim2.new(0, 0, 0, 0)
    Trang.Visible = false
    Trang.Parent = ContentFrame
    
    local TrangList = Instance.new("UIListLayout")
    TrangList.Padding = UDim.new(0, 6)
    TrangList.Parent = Trang
    
    local TrangPadding = Instance.new("UIPadding")
    TrangPadding.PaddingTop = UDim.new(0, 8)
    TrangPadding.PaddingLeft = UDim.new(0, 8)
    TrangPadding.PaddingRight = UDim.new(0, 8)
    TrangPadding.Parent = Trang
    
    TrangList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Trang.CanvasSize = UDim2.new(0, 0, 0, TrangList.AbsoluteContentSize.Y + 20)
    end)
    
    DanhSachTab[Ten] = { Nut = NutTab, Trang = Trang }
    
    NutTab.MouseButton1Click:Connect(function()
        for _, tab in pairs(DanhSachTab) do
            tab.Trang.Visible = false
            TweenService:Create(tab.Nut, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 32)}):Play()
            tab.Nut.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        Trang.Visible = true
        TweenService:Create(NutTab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 255, 150)}):Play()
        NutTab.TextColor3 = Color3.fromRGB(12, 12, 18)
    end)
    
    return Trang
end

-- Toggle
local function TaoToggle(Trang, Ten, MacDinh, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = Trang
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 5)
    FrameCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -65, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Ten
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextScaled = true
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Nut = Instance.new("TextButton")
    Nut.Size = UDim2.new(0, 45, 0, 22)
    Nut.Position = UDim2.new(1, -55, 0.5, -11)
    Nut.BackgroundColor3 = MacDinh and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 65)
    Nut.BorderSizePixel = 0
    Nut.Text = MacDinh and "ON" or "OFF"
    Nut.TextColor3 = Color3.fromRGB(255, 255, 255)
    Nut.TextScaled = true
    Nut.Font = Enum.Font.GothamBold
    Nut.Parent = Frame
    
    local NutCorner = Instance.new("UICorner")
    NutCorner.CornerRadius = UDim.new(0, 11)
    NutCorner.Parent = Nut
    
    local TrangThai = MacDinh
    
    Nut.MouseButton1Click:Connect(function()
        TrangThai = not TrangThai
        Nut.Text = TrangThai and "ON" or "OFF"
        TweenService:Create(Nut, TweenInfo.new(0.15), {
            BackgroundColor3 = TrangThai and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 65)
        }):Play()
        if Callback then Callback(TrangThai) end
    end)
    
    return Nut
end

-- Nút
local function TaoNut(Trang, Ten, Callback)
    local Nut = Instance.new("TextButton")
    Nut.Size = UDim2.new(1, -5, 0, 32)
    Nut.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
    Nut.BorderSizePixel = 0
    Nut.Text = Ten
    Nut.TextColor3 = Color3.fromRGB(255, 255, 255)
    Nut.TextScaled = true
    Nut.Font = Enum.Font.GothamBold
    Nut.Parent = Trang
    
    local NutCorner = Instance.new("UICorner")
    NutCorner.CornerRadius = UDim.new(0, 5)
    NutCorner.Parent = Nut
    
    Nut.MouseButton1Click:Connect(function()
        if Callback then Callback() end
    end)
    
    return Nut
end

-- Slider
local function TaoSlider(Trang, Ten, Min, Max, MacDinh, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    Frame.BorderSizePixel = 0
    Frame.Parent = Trang
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 5)
    FrameCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 3)
    Label.BackgroundTransparency = 1
    Label.Text = Ten .. ": " .. MacDinh
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextScaled = true
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Thanh = Instance.new("Frame")
    Thanh.Size = UDim2.new(1, -20, 0, 6)
    Thanh.Position = UDim2.new(0, 10, 0, 32)
    Thanh.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Thanh.BorderSizePixel = 0
    Thanh.Parent = Frame
    
    local ThanhCorner = Instance.new("UICorner")
    ThanhCorner.CornerRadius = UDim.new(1, 0)
    ThanhCorner.Parent = Thanh
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((MacDinh - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Fill.BorderSizePixel = 0
    Fill.Parent = Thanh
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local NutKeo = Instance.new("TextButton")
    NutKeo.Size = UDim2.new(0, 14, 0, 14)
    NutKeo.Position = UDim2.new((MacDinh - Min) / (Max - Min), -7, 0.5, -7)
    NutKeo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NutKeo.BorderSizePixel = 0
    NutKeo.Text = ""
    NutKeo.Parent = Thanh
    
    local NutKeoCorner = Instance.new("UICorner")
    NutKeoCorner.CornerRadius = UDim.new(1, 0)
    NutKeoCorner.Parent = NutKeo
    
    local DangKeo = false
    
    NutKeo.MouseButton1Down:Connect(function() DangKeo = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then DangKeo = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if DangKeo and input.UserInputType == Enum.UserInputType.MouseMovement then
            local ViTri = math.clamp((input.Position.X - Thanh.AbsolutePosition.X) / Thanh.AbsoluteSize.X, 0, 1)
            local GiaTri = math.floor(Min + (Max - Min) * ViTri)
            Fill.Size = UDim2.new(ViTri, 0, 1, 0)
            NutKeo.Position = UDim2.new(ViTri, -7, 0.5, -7)
            Label.Text = Ten .. ": " .. GiaTri
            if Callback then Callback(GiaTri) end
        end
    end)
    
    return NutKeo
end

-- Label
local function TaoLabel(Trang, Ten)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -5, 0, 24)
    Label.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    Label.BorderSizePixel = 0
    Label.Text = Ten
    Label.TextColor3 = Color3.fromRGB(0, 255, 150)
    Label.TextScaled = true
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Trang
    
    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 5)
    LabelCorner.Parent = Label
    
    return Label
end

-- Dropdown
local function TaoDropdown(Trang, Ten, DanhSach, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = Trang
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 5)
    FrameCorner.Parent = Frame
    
    local Nut = Instance.new("TextButton")
    Nut.Size = UDim2.new(1, 0, 0, 32)
    Nut.BackgroundTransparency = 1
    Nut.Text = Ten .. " ▼"
    Nut.TextColor3 = Color3.fromRGB(230, 230, 230)
    Nut.TextScaled = true
    Nut.Font = Enum.Font.Gotham
    Nut.Parent = Frame
    
    local Mo = false
    
    Nut.MouseButton1Click:Connect(function()
        Mo = not Mo
        Frame.Size = UDim2.new(1, -5, 0, Mo and (32 + #DanhSach * 26) or 32)
    end)
    
    for i, Lua in ipairs(DanhSach) do
        local NutLua = Instance.new("TextButton")
        NutLua.Size = UDim2.new(1, -8, 0, 24)
        NutLua.Position = UDim2.new(0, 4, 0, 32 + (i - 1) * 26)
        NutLua.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        NutLua.BorderSizePixel = 0
        NutLua.Text = Lua
        NutLua.TextColor3 = Color3.fromRGB(200, 200, 200)
        NutLua.TextScaled = true
        NutLua.Font = Enum.Font.Gotham
        NutLua.Parent = Frame
        
        local NutLuaCorner = Instance.new("UICorner")
        NutLuaCorner.CornerRadius = UDim.new(0, 3)
        NutLuaCorner.Parent = NutLua
        
        NutLua.MouseButton1Click:Connect(function()
            Nut.Text = Ten .. ": " .. Lua .. " ▼"
            Mo = false
            Frame.Size = UDim2.new(1, -5, 0, 32)
            if Callback then Callback(Lua) end
        end)
    end
    
    return Nut
end

-- === LOGIC ===
local function LaTrung(obj)
    if not obj or not obj:IsA("BasePart") then return false end
    if not obj.Parent then return false end
    local ten = string.lower(obj.Name)
    return string.find(ten, "egg") or string.find(ten, "trung") or string.find(ten, "pet")
end

local function PhanLoaiTrung(Trung)
    if NoiTrongDaChon == "Tất cả" then return true end
    local ten = string.lower(Trung.Name)
    if NoiTrongDaChon == "Trứng thường" then
        return not (string.find(ten, "rare") or string.find(ten, "hiem") or string.find(ten, "event") or string.find(ten, "legend"))
    elseif NoiTrongDaChon == "Trứng hiếm" then
        return string.find(ten, "rare") or string.find(ten, "hiem") or string.find(ten, "legend") or string.find(ten, "epic")
    elseif NoiTrongDaChon == "Trứng event" then
        return string.find(ten, "event") or string.find(ten, "sukien")
    elseif NoiTrongDaChon == "Trứng pet" then
        return string.find(ten, "pet")
    end
    return true
end

-- TELEPORT TỨC THỜI (tốc độ cao)
local function TeleportDen(ViTri)
    if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
    HumanoidRootPart.CFrame = CFrame.new(ViTri)
end

-- Bay tốc độ cao (fallback)
local function BayDen(ViTri)
    if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
    local KhoangCach = (HumanoidRootPart.Position - ViTri).Magnitude
    if KhoangCach < 0.1 then return end
    local Huong = (ViTri - HumanoidRootPart.Position).Unit
    local Buoc = math.min(CONFIG.TocDoBay * task.wait(), KhoangCach)
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Huong * Buoc
end

local function DiChuyen(ViTri)
    if CONFIG.TeleportMode then
        TeleportDen(ViTri)
    else
        BayDen(ViTri)
    end
end

local function NhatTrung(Trung)
    if not Trung or not Trung.Parent then return end
    
    pcall(function()
        if Trung:FindFirstChildOfClass("ClickDetector") then
            fireclickdetector(Trung:FindFirstChildOfClass("ClickDetector"))
        end
    end)
    
    pcall(function()
        if Trung:FindFirstChildOfClass("ProximityPrompt") then
            local Prompt = Trung:FindFirstChildOfClass("ProximityPrompt")
            Prompt:InputHoldBegin()
            task.wait(0.01)
            Prompt:InputHoldEnd()
        end
    end)
    
    pcall(function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local ten = string.lower(obj.Name)
                if string.find(ten, "egg") or string.find(ten, "collect") or string.find(ten, "nhat") then
                    obj:FireServer(Trung)
                end
            end
        end
    end)
    
    pcall(function()
        if Trung:FindFirstChildOfClass("TouchTransmitter") then
            firetouchinterest(HumanoidRootPart, Trung, 0)
            task.wait(0.01)
            firetouchinterest(HumanoidRootPart, Trung, 1)
        end
    end)
end

local function QuetTrung()
    DanhSachTrung = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if LaTrung(obj) and PhanLoaiTrung(obj) then
            table.insert(DanhSachTrung, obj)
        end
    end
    table.sort(DanhSachTrung, function(a, b)
        if not HumanoidRootPart then return false end
        return (HumanoidRootPart.Position - a.Position).Magnitude < (HumanoidRootPart.Position - b.Position).Magnitude
    end)
    return #DanhSachTrung
end

local function BayVeNha()
    if not CONFIG.ViTriNha then return end
    if not HumanoidRootPart or not HumanoidRootPart.Parent then return end
    
    if CONFIG.TeleportMode then
        TeleportDen(CONFIG.ViTriNha)
    else
        local Dem = 0
        repeat
            BayDen(CONFIG.ViTriNha)
            task.wait()
            Dem = Dem + 1
        until (HumanoidRootPart.Position - CONFIG.ViTriNha).Magnitude <= 5 or Dem > 500 or not DangHoatDong
    end
end

-- === KILL AURA TỐC ĐỘ CAO ===
task.spawn(function()
    while task.wait(0.05) do
        if not CONFIG.KillAura then continue end
        if not HumanoidRootPart or not HumanoidRootPart.Parent then continue end
        
        pcall(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Humanoid") and obj.Parent ~= Character then
                    local Char = obj.Parent
                    if 
