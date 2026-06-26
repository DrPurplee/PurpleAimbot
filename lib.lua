-- ╔══════════════════════════════════════════════════════╗
-- ║   Nexonix Library — Watermark patché (logo-only)    ║
-- ║   Remplace le loadstring de la lib par celui-ci     ║
-- ╚══════════════════════════════════════════════════════╝

local LibUrl = "https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/nexonix/Library.lua"

-- Charge la source brute de la lib
local LibSource = game:HttpGet(LibUrl)

-- ══════════════════════════════════════════════════════
--  NOUVELLE SECTION WATERMARK : logo = taille du carré
-- ══════════════════════════════════════════════════════
local NewWatermark = [==[
        Library.Watermark = function(Self, Params)
            Params = Params or { }
            local Watermark = {
                Name = Params.Name or Params.name or "Nexonix",
                Logo = Params.Logo or Params.logo or "rbxassetid://77749228793011",
                Items = { }
            }
            local Items = { } do
                -- Le frame s'adapte à la taille du logo (AutomaticSize XY)
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -15, 0, 15),
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    CornerRadius = UDim.new(0, 6)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingTop    = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingLeft   = UDim.new(0, 4),
                    PaddingRight  = UDim.new(0, 4)
                })

                -- Le logo dicte la taille du frame via AutomaticSize
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0, 0),
                    Image = Watermark.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 42, 0, 42),
                    BorderSizePixel = 0
                })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Logo"].Instance,
                    CornerRadius = UDim.new(0, 4)
                })

                -- Stubs invisibles pour ne pas casser le code existant
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Text = "", Visible = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0
                })

                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Visible = false,
                    Size = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Liner"]
                })

                Watermark.Items = Items
            end

            function Watermark:AddItem(Icon, Text)
                local D = Library:Create("TextLabel", {
                    Name = "\0", Parent = Items["Watermark"].Instance,
                    Visible = false, Text = Text or "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0
                })
                return D, D
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text) end

            return setmetatable(Watermark, Library)
        end
]==]

-- Trouve et remplace la section Watermark dans la source de la lib
local startMarker = "        Library.Watermark = function(Self, Params)"
local endMarker   = "\n        Library.KeybindList"

local startIdx = LibSource:find(startMarker, 1, true)
local endIdx   = LibSource:find(endMarker, 1, true)

if startIdx and endIdx then
    LibSource = LibSource:sub(1, startIdx - 1)
        .. NewWatermark
        .. LibSource:sub(endIdx)
    print("[Nexonix Patcher] ✔ Watermark section remplacée !")
else
    warn("[Nexonix Patcher] ✘ Section Watermark introuvable — lib non patchée")
end

return loadstring(LibSource)()
