local words = {"floor ", "eyebrow ", "leader ", "product ", "knot ", "enter ", "negotiation ", "interactive ", "possibility ", "switch ", "central ", "agreement ", "trivial ", "lifestyle ", "chain ", "association ", "astonishing ", "economic ", "mark ", "assume ", "drag ", "see ", "trustee ", "fur ", "contempt ", "elephant ", "safe ", "helicopter ", "visible ", "hike ", "buy ", "sand ", "highway ", "rotten ", "tune ", "grind ", "vein ", "medium ", "veteran ", "advantage ", "opposition ", "thoughtful ", "chip ", "spite ", "dentist ", "form ", "cabinet ", "a ", "an ", "at ", "is ", "isn't ", "do", "don't ", "kill ", "destroy ", "yucky ", "robux ", "fortnite ", "roblox ", "shut ", "up ", "down ", "left ", "right ", "quiet ", "opposite ", "the ", "not ", "quite ", "reverse ", "of " , "can ", "call ", "hang ", "yourself ", "you ", "your "}
local targets = {"r dad ", "r mom ", "r brother ", "r sister ", "r house ", "r car "}
local attacks = {"looks like ", "smells like ", "sounds like ", "feels like ", "is "}

local message = "you" .. targets[math.random(1, #targets)] .. "" .. attacks[math.random(1, #attacks)] .. ""
local rng = math.random(1, 24)

for i = 0, rng do
    message = message .. "" .. words[math.random(1, #words)]
end

if not game:GetService("TextChatService") == nil then 
    for _, v in next, game:GetService("TextChatService").TextChannels:GetChildren() do
        if v:FindFirstChild(game:GetService("Players").LocalPlayer.Name) and v.Name ~= 'RBXSystem' then
            v:SendAsync(message)
        end
    end
else
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message,"All")
end
