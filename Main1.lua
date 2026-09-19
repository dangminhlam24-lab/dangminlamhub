-- Đặng Minh Lâm Hub - Bản Ngắn Gọn
-- Tương thích Delta Executor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

local CFG = {
    TocDo = 500,
    KhoangCach = 15,
    ViTriNha = nil,
    BayVe = true,
    KillAura = false,
    PhamViKA = 50,
    ChongST = true,
    Teleport = true,
    NoiTrong = "Tất cả"
}

local DangChay = false
local DaAnUI = false
local DSNoiTrong = {"Tất cả", "Trứng thường", "Trứng hiếm", "Trứng event", "Trứng pet"}

-- Anti-kick
pcall(function()
    LP.Kick = function() end
    if getgenv then getgenv().Hidden = true end
end)

-- Xóa GUI cũ
pcall(function()
    if CoreGui:FindFirstChild("DMLHub") then CoreGui.DMLHub:Destroy() end
end)

-- GUI
local SG = Instance.new("ScreenGui")
SG.Name = "DMLHub"
SG.ResetOnSpawn = false
SG.Parent = CoreGui

local NutMo = Instance.new("TextButton")
NutMo.Size = UDim2.new(0, 50, 0, 50)
NutMo.Position = UDim2.new(0, 15, 0.5, -25)
NutMo.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
NutMo.Text = "L"
NutMo.TextColor3 = Color3.fromRGB(0, 255, 150)
NutMo.TextScaled = true
NutMo.Font = Enum.Font.GothamBlack
NutMo.Parent = SG
Instance.new("UICorner", NutMo).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local TieuDe = Instance.new("TextLabel")
TieuDe.Size = UDim2.new(1, 0, 0, 32)
TieuDe.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
TieuDe.Text = "ĐẶNG MINH LÂM HUB"
TieuDe.TextColor3 = Color3.fromRGB(0, 255, 150)
TieuDe.TextScaled = true
TieuDe.Font = Enum.Font.GothamBold
TieuDe.Parent = Main
Instance.new("UICorner", TieuDe).CornerRadius = UDim.new(0, 8)

local NutDong = Instance.new("TextButton")
NutDong.Size = UDim2.new(0, 26, 0, 26)
NutDong.Position = UDim2.new(1, -30, 0, 3)
NutDong.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
NutDong.Text = "X"
NutDong.TextColor3 = Color3.fromRGB(255, 255, 255)
NutDong.TextScaled = true
NutDong.Font = Enum.Font.GothamBold
NutDong.Parent = Main

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -45)
Content.Position = UDim2.new(0, 10, 0, 38)
Content.BackgroundTransparency = 1
Content.Parent = Main

local List = Instance.new("UIListLayout", Content)
List.Padding = UDim.new(0, 6)

-- Hàm tạo toggle
local function TaoToggle(Ten, MacDinh, Callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 36)
    F.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    F.BorderSizePixel = 0
    F.Parent = Content
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -65, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = Ten
    L.TextColor3 = Color3.fromRGB(230, 230, 230)
    L.TextScaled = true
    L.Font = Enum.Font.Gotham
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F
    
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 45, 0, 22)
    B.Position = UDim2.new(1, -55, 0.5, -11)
    B.BackgroundColor3 = MacDinh and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 65)
    B.Text = MacDinh and "ON" or "OFF"
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.TextScaled = true
    B.Font = Enum.Font.GothamBold
    B.Parent = F
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 11)
    
    local TT = MacDinh
    B.MouseButton1Click:Connect(function()
        TT = not TT
        B.Text = TT and "ON" or "OFF"
        B.BackgroundColor3 = TT and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(55, 55, 65)
        if Callback then Callback(TT) end
    end)
    return B
end

-- Hàm tạo nút
local function TaoNut(Ten, Callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = Color3.fromRGB(0, 180, 130)
    B.Text = Ten
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.TextScaled = true
    B.Font = Enum.Font.GothamBold
    B.Parent = Content
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 5)
    B.MouseButton1Click:Connect(function()
        if Callback then Callback() end
    end)
    return B
end

-- Hàm tạo dropdown
local function TaoDropdown(Ten, DS, Callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 32)
    F.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    F.BorderSizePixel = 0
    F.ClipsDescendants = true
    F.Parent = Content
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 5)
    
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundTransparency = 1
    B.Text = Ten .. " ▼"
    B.TextColor3 = Color3.fromRGB(230, 230, 230)
    B.TextScaled = true
    B.Font = Enum.Font.Gotham
    B.Parent = F
    
    local Mo = false
    B.MouseButton1Click:Connect(function()
        Mo = not Mo
        F.Size = UDim2.new(1, 0, 0, Mo and (32 + #DS * 26) or 32)
    end)
    
    for i, V in ipairs(DS) do
        local BL = Instance.new("TextButton")
        BL.Size = UDim2.new(1, -8, 0, 24)
        BL.Position = UDim2.new(0, 4, 0, 32 + (i - 1) * 26)
        BL.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
        BL.Text = V
        BL.TextColor3 = Color3.fromRGB(200, 200, 200)
        BL.TextScaled = true
        BL.Font = Enum.Font.Gotham
        BL.Parent = F
        Instance.new("UICorner", BL).CornerRadius = UDim.new(0, 3)
        BL.MouseButton1Click:Connect(function()
            B.Text = Ten .. ": " .. V .. " ▼"
            Mo = false
            F.Size = UDim2.new(1, 0, 0, 32)
            if Callback then Callback(V) end
        end)
    end
end

-- Tạo UI
TaoToggle("Bật Auto Egg", false, function(v) DangChay = v end)
TaoToggle("Tự Động Bay Về", true, function(v) CFG.BayVe = v end)
TaoToggle("Teleport Tức Thời", true, function(v) CFG.Teleport = v end)
TaoToggle("Kill Aura", false, function(v) CFG.KillAura = v end)
TaoToggle("Chống Sát Thương", true, function(v) CFG.ChongST = v end)
TaoDropdown("Chọn Nơi Trộm", DSNoiTrong, function(v) CFG.NoiTrong = v end)
TaoNut("Lưu Vị Trí Nhà", function()
    if HRP then
        CFG.ViTriNha = HRP.Position
        StarterGui:SetCore("SendNotification", {Title = "Hub", Text = "Đã lưu nhà!", Duration = 2})
    end
end)
TaoNut("Bay Về Nhà Ngay", function()
    if CFG.ViTriNha and HRP then HRP.CFrame = CFrame.new(CFG.ViTriNha) end
end)

-- Logic
local function LaTrung(o)
    if not o or not o:IsA("BasePart") or not o.Parent then return false end
    local t = string.lower(o.Name)
    return string.find(t, "egg") or string.find(t, "trung") or string.find(t, "pet")
end

local function LocTrung(o)
    if CFG.NoiTrong == "Tất cả" then return true end
    local t = string.lower(o.Name)
    if CFG.NoiTrong == "Trứng hiếm" then return string.find(t, "rare") or string.find(t, "hiem") or string.find(t, "legend") end
    if CFG.NoiTrong == "Trứng event" then return string.find(t, "event") or string.find(t, "sukien") end
    if CFG.NoiTrong == "Trứng pet" then return string.find(t, "pet") end
    return not (string.find(t, "rare") or string.find(t, "hiem") or string.find(t, "event"))
end

local function NhatTrung(T)
    if not T or not T.Parent then return end
    pcall(function()
        if T:FindFirstChildOfClass("ClickDetector") then fireclickdetector(T:FindFirstChildOfClass("ClickDetector")) end
    end)
    pcall(function()
        if T:FindFirstChildOfClass("ProximityPrompt") then
            T:FindFirstChildOfClass("ProximityPrompt"):InputHoldBegin()
            task.wait(0.01)
            T:FindFirstChildOfClass("ProximityPrompt"):InputHoldEnd()
        end
    end)
    pcall(function()
        if T:FindFirstChildOfClass("TouchTransmitter") then
            firetouchinterest(HRP, T, 0)
            task.wait(0.01)
            firetouchinterest(HRP, T, 1)
        end
    end)
end

-- Vòng lặp chính
task.spawn(function()
    while task.wait(0.05) do
        if not DangChay then continue end
        if not HRP or not HRP.Parent then
            Char = LP.Character or LP.CharacterAdded:Wait()
            HRP = Char:WaitForChild("HumanoidRootPart")
            continue
        end
        
        local DS = {}
        for _, o in ipairs(Workspace:GetDescendants()) do
            if LaTrung(o) and LocTrung(o) then table.insert(DS, o) end
        end
        table.sort(DS, function(a, b)
            return (HRP.Position - a.Position).Magnitude < (HRP.Position - b.Position).Magnitude
        end)
        
        for _, T in ipairs(DS) do
            if not DangChay then break end
            if not T or not T.Parent then continue end
            
            if CFG.Teleport then
                HRP.CFrame = CFrame.new(T.Position + Vector3.new(0, 3, 0))
                task.wait(0.01)
            else
                local Dem = 0
                repeat
                    local KC = (HRP.Position - T.Position).Magnitude
                    local Huong = (T.Position - HRP.Position).Unit
                    HRP.CFrame = HRP.CFrame + Huong * math.min(CFG.TocDo * task.wait(), KC)
                    task.wait()
                    Dem = Dem + 1
                until KC <= CFG.KhoangCach or not T.Parent or Dem > 100
            end
            
            NhatTrung(T)
            task.wait(0.01)
            
            if CFG.BayVe and CFG.ViTriNha then
                HRP.CFrame = CFrame.new(CFG.ViTriNha)
                break
            end
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.05) do
        if not CFG.KillAura or not HRP or not HRP.Parent then continue end
        pcall(function()
            for _, h in ipairs(Workspace:GetDescendants()) do
                if h:IsA("Humanoid") and h.Parent ~= Char then
                    local C = h.Parent
                    if C:FindFirstChild("HumanoidRootPart") and (HRP.Position - C.HumanoidRootPart.Position).Magnitude <= CFG.PhamViKA then
                        if Char:FindFirstChildOfClass("Tool") then Char:FindFirstChildOfClass("Tool"):Activate() end
                    end
                end
            end
        end)
    end
end)

-- Chống sát thương
task.spawn(function()
    while task.wait(0.1) do
        if not CFG.ChongST or not Char or not Char.Parent then continue end
        pcall(function()
            local H = Char:FindFirstChildOfClass("Humanoid")
            if H then H.Health = H.MaxHealth end
        end)
    end
end)

-- Sự kiện
NutMo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
NutDong.MouseButton1Click:Connect(function() Main.Visible = false end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        DangChay = not DangChay
        StarterGui:SetCore("SendNotification", {Title = "Hub", Text = DangChay and "Auto: BẬT" or "Auto: TẮT", Duration = 2})
    end
    if input.KeyCode == Enum.KeyCode.RightControl then
        DaAnUI = not DaAnUI
        NutMo.Visible = not DaAnUI
        Main.Visible = false
    end
end)

StarterGui:SetCore("SendNotification", {Title = "Đặng Minh Lâm Hub", Text = "Đã tải! Nhấn L để mở menu", Duration = 4})
