local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Sans Simulator X | 9970498292, @Hamburga", HidePremium = false, SaveConfig = false, ConfigFolder = "OrionTest"})
local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


local Section = Tab:AddSection({
    Name = "Farm Section"
})
local AutoClick
Tab:AddToggle({
    Name = "AutoClicker",
    Default = false,
    Callback = function(Value)
        getgenv().AutoClicker = Value
        if getgenv().AutoClicker then
        
                AutoClick = game:GetService("RunService").Heartbeat:Connect(function()
                    local args = {
                        [1] = game:GetService("Players").LocalPlayer
                    }
                    game:GetService("ReplicatedStorage").RemoteEvents.GainClicks:FireServer(unpack(args))
                end)
            
        elseif AutoClick then
            AutoClick:Disconnect()
        end
    end
})


Tab:AddToggle({
    Name = "AutoLevel Up Pets",
    Default = false,
    Callback = function(Value)
        getgenv().AutoLevelUp = Value
        while getgenv().AutoLevelUp do
            task.wait()
            firetouchinterest(game.Workspace.XPorb, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
            firetouchinterest(game.Workspace.XPorb, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
        end    
    end
})
local Section = Tab:AddSection({
    Name = "Eggs Section"
})
local EggsList = {}

for i, lol in ipairs(game.Workspace.Eggs:GetChildren()) do
    table.insert(EggsList, lol.Name)
end

getgenv().EggOption = nil

Tab:AddDropdown({
    Name = "Eggs",
    Default = "None",
    Options = EggsList,
    Callback = function(Value)
        getgenv().EggOption = Value
    end    
})

getgenv().AutoOpenEggsCooldown = nil

Tab:AddTextbox({
    Name = "AutoOpen Eggs Cooldown",
    Default = "0.5",
    TextDisappear = true,
    Callback = function(Value)
        getgenv().AutoOpenEggsCooldown = Value or 0.5
    end	  
})

Tab:AddToggle({
    Name = "AutoOpen Egg (Single)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoOpenEggsSingle = Value
        while getgenv().AutoOpenEggsSingle do
            task.wait(getgenv().AutoOpenEggsCooldown)
            local args = {
                [1] = getgenv().EggOption
            }

            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Eclicked"):FireServer(unpack(args))
        end
    end    
})

Tab:AddToggle({
    Name = "AutoOpen Egg (Triple)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoOpenEggsTriple = Value 
        while getgenv().AutoOpenEggsTriple do
           task.wait(getgenv().AutoOpenEggsCooldown)
            local args = {
                [1] = getgenv().EggOption
            }

            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Rclicked"):FireServer(unpack(args))
        end
    end    
})
local noegganimation
Tab:AddToggle({
    Name = "No Egg Animation",
    Default = false,
    Callback = function(Value)
        getgenv().NoEggAnimation = Value
        if getgenv().NoEggAnimation then
            noegganimation = game:GetService("RunService").Heartbeat:Connect(function()
                for i, EggAnimation in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
                    if EggAnimation.Name == "Flash" or EggAnimation.Name == "ScreenGui" or EggAnimation.Name == "Sound" then
                        EggAnimation:Destroy()
                    end
                end
            end)
        elseif noegganimation then
            noegganimation:Disconnect()
        end
  end
})
local Section = Tab:AddSection({
    Name = "Pets Section"
})
local buttonCooldown = 2 -- Cooldown duration in seconds
local lastClickTime = 0 -- Variable to store the last click time

Tab:AddButton({
    Name = "Equip All Pets",
    Callback = function()
        local currentTime = os.time()
        local remainingCooldown = buttonCooldown - (currentTime - lastClickTime)
        
        if remainingCooldown <= 0 then
            lastClickTime = currentTime
            
            for i, pets in ipairs(game.Players.LocalPlayer.Pets:GetChildren()) do
                if pets.Equipped.Value == false then
                    local args = {
                        pets.Pet_ID.Value
                    }

                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetEquipped"):FireServer(unpack(args))
                    pets.Equipped.Value = true
                end
            end
        else
           Notification:Notify(
                    {
                        Title = "Notification",
                        Description = "Button is on cooldown. Please wait for " .. remainingCooldown .. " seconds.",
                    },
                    {OutlineColor = Color3.fromRGB(76, 0, 130), Time = 5, Type = "default"}
                )
        end
    end
})



Tab:AddButton({
    Name = "Unequip All Pets",
    Callback = function()
        for i, pets in ipairs(game.Players.LocalPlayer.Pets:GetChildren()) do 
            if pets.Equipped.Value then
                local args = {
                    [1] = pets.Pet_ID.Value
                }

                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetUnequipped"):FireServer(unpack(args))
                pets.Equipped.Value = false
            end
        end
    end    
})

getgenv().AutoDeletePetName = nil
  Tab:AddTextbox({
      Name = "Pets Name To",
      Default = "",
      TextDisappear = true,
      Callback = function(Value)
          getgenv().AutoDeletePetName = Value
      end	  
  })
  
  Tab:AddToggle({
      Name = "AutoDelete Pets",
      Default = false,
      Callback = function(Value)
          getgenv().AutoDeletePets = Value 
          while getgenv().AutoDeletePets do
              task.wait()
              if tostring(getgenv().AutoDeletePetName) == "All" or tostring(getgenv().AutoDeletePetName) == "all" then
                  for i, Petlol in ipairs(game.Players.LocalPlayer.Pets:GetChildren()) do
                      local args = {
                          [1] = Petlol.Pet_ID.Value
                      }
                      
                      game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetDelete"):FireServer(unpack(args))
                  end
              else
                  for i, Petlol in ipairs(game.Players.LocalPlayer.Pets:GetDescendants()) do
                      if Petlol.Name == tostring(getgenv().AutoDeletePetName) then
                          local args = {
                              [1] = Petlol.Pet_ID.Value
                          }
                          
                          game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetDelete"):FireServer(unpack(args))
                      end
                  end
              end
          end
      end
  })
  
local Tab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = Tab:AddSection({
    Name = "Misc Section"
})
local Multiplier1 = Tab:AddLabel("Multiplier : ")
Multiplier1:Set("Multiplier : ".. game.Players.LocalPlayer.PlayerStats.Multiplier.Value)
  
Tab:AddButton({
    Name = "Infinite Max Pets Equip", -- and yes, it's FE
    Callback = function()
        game.Players.LocalPlayer.PlayerStats.MaxPets.Value = math.huge
    end    
})
local hideurownpet
Tab:AddToggle({
        Name = "Hide ur Own Pets",
        Default = false,
        Callback = function(Value)
            getgenv().AntiClientCrasherLagger = Value 
            if getgenv().AntiClientCrasherLagger then
                hideurownpet = game:GetService("RunService").Heartbeat:Connect(function()
                for i, HidePet in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if HidePet:IsA("Model") then
                        HidePet:Destroy()
                    end
                end
                end)
            elseif hideurownpet then
              hideurownpet:Disconnect()
                end
        end
    })
  
  local TeleportTable = {
    "None",
    "Spawn",
    "Ruins",
    "Snowdin",
    "Hotland",
    "Secret Place",
  }
  getgenv().TeleportLol = nil
  Tab:AddDropdown({
	Name = "Teleport",
	Default = "None",
	Options = TeleportTable,
	Callback = function(Value)
		getgenv().TeleportLol = Value
	end    
})
  Tab:AddButton({
	Name = "Teleport",
	Callback = function()
if getgenv().TeleportLol == "Spawn" then
	 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(99, 6, 10)
	elseif getgenv().TeleportLol == "Ruins" then
	  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(24, 5, 159)
	elseif getgenv().TeleportLol == "Snowdin" then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(25, 4, 328)
	elseif getgenv().TeleportLol == "Hotland" then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(572, 32, -459)
	elseif getgenv().TeleportLol == "Secret Place" then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-27, 6, 442)
	  end
  	end    
})
local HWIDTable = {
  "beaf15e3-ad70-498f-98f0-d105d062a1a5", 
}
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

for i,v in pairs(HWIDTable) do
    if table.find(HWIDTable, HWID) then
local Tab = Window:MakeTab({
    Name = "Private",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = Tab:AddSection({
    Name = "Farm Section"
})
getgenv().MultipleValue = nil
Tab:AddTextbox({
    Name = "Value lol",
    Default = "1",
    TextDisappear = true,
    Callback = function(Value)
        getgenv().MultipleValue = Value
    end	  
})
Tab:AddButton({
    Name = "Multiplier",
    Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.Health = 0
      wait(0.5)
            for i, pets in ipairs(game.Players.LocalPlayer.Pets:GetChildren()) do
              for i = 1, getgenv().MultipleValue or 1 do
                local args = {
                    pets.Pet_ID.Value
                }

                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetEquipped"):FireServer(unpack(args))
              end
              if game.Players.LocalPlayer.Character ~= nil then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
              end
  
      end
    end	    
})
local Section = Tab:AddSection({
    Name = "Fun Section"
})
Tab:AddButton({
	Name = "Client Lagger",
	Callback = function()
for i = 1,1500 do 
 local args = {
    [1] = 1
}

game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetEquipped"):FireServer(unpack(args))
  end
  end	    
})

Tab:AddButton({
	Name = "Client Crasher",
	Callback = function()
for i = 1,50000 do 
 local args = {
    [1] = 1
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PetEquipped"):FireServer(unpack(args))
end
Notification:Notify(
                    {
                        Title = "Notification",
                        Description = "Please Wait to See The Effect."
                    },
                    {OutlineColor = Color3.fromRGB(76, 0, 130), Time = 5, Type = "default"}
                )
  end	    
})
local anticlirntcrasherandlagger
Tab:AddToggle({
        Name = "Anti Client Crasher and Lagger",
        Default = false,
        Callback = function(Value)
            getgenv().AntiClientCrasherLagger = Value 
            if getgenv().AntiClientCrasherLagger then
                anticlirntcrasherandlagger = game:GetService("RunService").Heartbeat:Connect(function()
                for i, HidePet in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if HidePet:IsA("Model") then
                        HidePet:Destroy()
                        
                    end
                end
                end)
            elseif anticlirntcrasherandlagger then
              heartbeat:Disconnect()
                end
        end
    })
  local hideotherspet
  Tab:AddToggle({
      Name = "Hide Others Pets",
      Default = false,
      Callback = function(Value)
          getgenv().HideAllPets = Value
          local LocalPlayer = game.Players.LocalPlayer
          if getgenv().HideAllPets then
              hideotherspet = game:GetService("RunService").Heartbeat:Connect(function()
                  for _, Player in ipairs(game.Players:GetPlayers()) do
                      if Player ~= LocalPlayer and Player.Character then
                          for _, HidePet in ipairs(Player.Character:GetDescendants()) do
                              if HidePet:IsA("Model") then
                                  HidePet:Destroy()
                              end
                          end
                      end
                  end
              end)
          elseif hideotherspet then
              hideotherspet:Disconnect()
          end
      end
  })
  
else
end
end


OrionLib:Init()



local function applyRainbowEffect(player)
  pcall(function()
    local hue = 0
    local saturation = 1
    local value = 1
    local increment = 0.01

    while true do
      
        if not player.Character or not player.Character.Head or not player.Character.Head.Stuff or not player.Character.Head.Stuff.TextName then
            break
        end
        
        player.Character.Head.Stuff.TextName.Font = Enum.Font.FredokaOne
        player.Character.Head.Stuff.TextName.Text = "🍔Hamburga🍔"
        player.Character.Head.Stuff.TextName.TextColor3 = Color3.fromHSV(hue, saturation, value)
        hue = (hue + increment) % 1
        wait(0.03) -- Adjust the delay between color changes if needed
       
    end
      end)
end
local HatedGuy = {
            ["amogus60s"] = true,
            ["l0weexwzfbp7kiqyksx0"] = true,
            ["LzQfOauYINSaNe572"] = true
        }
        
        for _, Hated in ipairs(game.Players:GetPlayers()) do
            if Hated and HatedGuy[Hated.Name] then
                wait(1)
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local ChatTag = {}
                ChatTag[Hated.Name] = {
                    TagText = "🍔Hamburga🍔",
                    TagColor = Color3.fromRGB(255, 250, 205),
                }
                local oldchanneltab
                local oldchannelfunc
                local oldchanneltabs = {}
        
                for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
                    if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
                        oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
                        oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
                        getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
                            local tab = oldchannelfunc(Self, Name)
                            if tab and tab.AddMessageToChannel then
                                local addmessage = tab.AddMessageToChannel
                                if oldchanneltabs[tab] == nil then
                                    oldchanneltabs[tab] = tab.AddMessageToChannel
                                end
                                tab.AddMessageToChannel = function(Self2, MessageData)
                                    if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
                                        if HatedGuy[Players[MessageData.FromSpeaker].Name] then
                                            if ChatTag[Players[MessageData.FromSpeaker].Name] then
                                                MessageData.ExtraData = {
                                                    NameColor = Players[MessageData.FromSpeaker].Team == nil and Color3.new(128, 0, 128) or Players[MessageData.FromSpeaker].TeamColor.Color,
                                                    Tags = {
                                                        table.unpack(MessageData.ExtraData.Tags),
                                                        {
                                                            TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
                                                            TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText,
                                                        },
                                                    },
                                                }
                                            end
                                        end
                                    end
                                    return addmessage(Self2, MessageData)
                                end
                            end
                            return tab
                        end
                    end
                end
        
                Notification:Notify(
                    {
                        Title = "Notification",
                        Description = "Owner of the script joined the server: " .. Hated.DisplayName .. "/" .. Hated.Name
                    },
                    {OutlineColor = Color3.fromRGB(76, 0, 130), Time = 5, Type = "default"}
                )
        
                pcall(function()
                    Hated.CharacterAdded:Connect(function()
                        pcall(function()
                            applyRainbowEffect(Hated)
                        end)
                    end)
                    Hated.CharacterRemoving:Connect(function()
                        pcall(function()
                            applyRainbowEffect(Hated)
                        end)
                    end)
        
                    applyRainbowEffect(Hated)
                end)
            end
        end
        
    