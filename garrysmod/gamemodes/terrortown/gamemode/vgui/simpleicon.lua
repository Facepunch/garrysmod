-- Altered version of gmod's SpawnIcon
-- This panel does not deal with models and such


local matHover = Material( "vgui/spawnmenu/hover" )

local PANEL = {}

AccessorFunc( PANEL, "m_iIconSize",         "IconSize" )

function PANEL:Init()
   self.Icon = vgui.Create( "DImage", self )
   self.Icon:SetMouseInputEnabled( false )
   self.Icon:SetKeyboardInputEnabled( false )

   self.animPress = Derma_Anim( "Press", self, self.PressedAnim )

   self:SetIconSize(64)

end

function PANEL:OnMousePressed( mcode )
   if mcode == MOUSE_LEFT then
      self:DoClick()
      self.animPress:Start(0.1)
   end
end

function PANEL:OnMouseReleased()
end

function PANEL:DoClick()
end

function PANEL:OpenMenu()
end

function PANEL:ApplySchemeSettings()
end

function PANEL:OnCursorEntered()
   self.PaintOverOld = self.PaintOver
   self.PaintOver = self.PaintOverHovered
end

function PANEL:OnCursorExited()
   if self.PaintOver == self.PaintOverHovered then
      self.PaintOver = self.PaintOverOld
   end
end

function PANEL:PaintOverHovered()

   if self.animPress:Active() then return end

   surface.SetDrawColor( 255, 255, 255, 80 )
   surface.SetMaterial( matHover )
   self:DrawTexturedRect()

end

function PANEL:PerformLayout()
   if self.animPress:Active() then return end
   self:SetSize( self.m_iIconSize, self.m_iIconSize )
   self.Icon:StretchToParent( 0, 0, 0, 0 )
end

function PANEL:SetIcon( icon )
   self.Icon:SetImage(icon)
end

function PANEL:GetIcon()
   return self.Icon:GetImage()
end

function PANEL:SetIconColor(clr)
   self.Icon:SetImageColor(clr)
end

function PANEL:Think()
   self.animPress:Run()
end

function PANEL:PressedAnim( anim, delta, data )

   if anim.Started then
      return
   end

   if anim.Finished then
      self.Icon:StretchToParent( 0, 0, 0, 0 )
      return
   end

   local border = math.sin( delta * math.pi ) * (self.m_iIconSize * 0.05 )
   self.Icon:StretchToParent( border, border, border, border )

end

vgui.Register( "SimpleIcon", PANEL, "Panel" )

---

local PANEL = {}

function PANEL:Init()
   self.Layers = {}
end

-- Add a panel to this icon. Most recent addition will be the top layer.
function PANEL:AddLayer(pnl)
   if not IsValid(pnl) then return end

   pnl:SetParent(self)

   pnl:SetMouseInputEnabled(false)
   pnl:SetKeyboardInputEnabled(false)

   table.insert(self.Layers, pnl)
end

function PANEL:PerformLayout()
   if self.animPress:Active() then return end
   self:SetSize( self.m_iIconSize, self.m_iIconSize )
   self.Icon:StretchToParent( 0, 0, 0, 0 )

   for _, p in ipairs(self.Layers) do
      p:SetPos(0, 0)
      p:InvalidateLayout()
   end
end

function PANEL:EnableMousePassthrough(pnl)
   for _, p in pairs(self.Layers) do
      if p == pnl then
         p.OnMousePressed  = function(s, mc) s:GetParent():OnMousePressed(mc) end
         p.OnCursorEntered = function(s) s:GetParent():OnCursorEntered() end
         p.OnCursorExited  = function(s) s:GetParent():OnCursorExited() end

         p:SetMouseInputEnabled(true)
      end
   end
end

vgui.Register("LayeredIcon", PANEL, "SimpleIcon")

-- Avatar icon
local PANEL = {}

function PANEL:Init()
   self.imgAvatar = vgui.Create( "AvatarImage", self )
   self.imgAvatar:SetMouseInputEnabled( false )
   self.imgAvatar:SetKeyboardInputEnabled( false )
   self.imgAvatar.PerformLayout = function(s) s:Center() end

   self:SetAvatarSize(32)

   self:AddLayer(self.imgAvatar)

   --return self.BaseClass.Init(self)
end

function PANEL:SetAvatarSize(s)
   self.imgAvatar:SetSize(s, s)
end

function PANEL:SetPlayer(ply)
   self.imgAvatar:SetPlayer(ply)
end

vgui.Register( "SimpleIconAvatar", PANEL, "LayeredIcon" )


--- Labelled icon

local PANEL = {}

AccessorFunc(PANEL, "IconText", "IconText")
AccessorFunc(PANEL, "IconTextColor", "IconTextColor")
AccessorFunc(PANEL, "IconFont", "IconFont")
AccessorFunc(PANEL, "IconTextShadow", "IconTextShadow")
AccessorFunc(PANEL, "IconTextPos", "IconTextPos")

function PANEL:Init()
   self:SetIconText("")
   self:SetIconTextColor(Color(255, 200, 0))
   self:SetIconFont("TargetID")
   self:SetIconTextShadow({opacity=255, offset=2})
   self:SetIconTextPos({32, 32})

   -- DPanelSelect loves to overwrite its children's PaintOver hooks and such,
   -- so have to use a dummy panel to do some custom painting.
   self.FakeLabel = vgui.Create("Panel", self)
   self.FakeLabel.PerformLayout = function(s) s:StretchToParent(0,0,0,0) end

   self:AddLayer(self.FakeLabel)

   return self.BaseClass.Init(self)
end

function PANEL:PerformLayout()
   self:SetLabelText(self:GetIconText(), self:GetIconTextColor(), self:GetIconFont(), self:GetIconTextPos())

   return self.BaseClass.PerformLayout(self)
end

function PANEL:SetIconProperties(color, font, shadow, pos)
   self:SetIconTextColor( color  or self:GetIconTextColor())
   self:SetIconFont(      font   or self:GetIconFont())
   self:SetIconTextShadow(shadow or self:GetIconShadow())
   self:SetIconTextPos(   pos or self:GetIconTextPos())
end

function PANEL:SetLabelText(text, color, font, pos)
   if self.FakeLabel then
      local spec = {pos=pos, color=color, text=text, font=font, xalign=TEXT_ALIGN_CENTER, yalign=TEXT_ALIGN_CENTER}

      local shadow = self:GetIconTextShadow()
      local opacity = shadow and shadow.opacity or 0
      local offset = shadow and shadow.offset or 0

      local drawfn = shadow and draw.TextShadow or draw.Text

      self.FakeLabel.Paint = function()
                                drawfn(spec, offset, opacity)
                             end
   end
end

vgui.Register("SimpleIconLabelled", PANEL, "LayeredIcon")
