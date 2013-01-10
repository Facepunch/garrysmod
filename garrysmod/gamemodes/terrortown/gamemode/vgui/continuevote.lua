-- It's like VoteScreen but different!
local PANEL = {}

PANEL.Votes = {
   {
      txt = "contvote_continue",
      keytxt = "[NUMPAD 1]",
      want = false
   },

   {
      txt = "contvote_change",
      keytxt = "[NUMPAD 2]",
      want = true
   }
};

function PANEL:Init()
   self:SetSkin( GAMEMODE.HudSkin )
   self:ParentToHUD()

   self.ControlCanvas = vgui.Create( "Panel", self )
   self.ControlCanvas:SetPaintBackgroundEnabled(false)
   self.ControlCanvas:SetKeyboardInputEnabled( false )
   self.ControlCanvas:SetMouseInputEnabled( false )

   self.ctrlList = vgui.Create( "DPanelList", self.ControlCanvas )
   self.ctrlList:SetDrawBackground( false )
   self.ctrlList:SetSpacing( 2 )
   self.ctrlList:SetPadding( 2 )
   self.ctrlList:EnableHorizontal( true )

   for _, data in ipairs(self.Votes) do
      local lbl = vgui.Create("DButton", self.ctrlList)
      Derma_Hook( lbl, "Paint", "Paint",	"GamemodeButton" )
      Derma_Hook( lbl, "ApplySchemeSettings", "Scheme", "GamemodeButton" )
      Derma_Hook( lbl, "PerformLayout", "Layout", "GamemodeButton" )

      lbl:SetText(data.keytxt .. "  " .. LANG.GetTranslation(data.txt))

      lbl:SetTall( 24 )
      lbl:SetWide( 300 )
      lbl:SetZPos(10)

      lbl.keytxt = data.keytxt
      lbl.txt = data.txt
      lbl.want = data.want
      lbl.numvotes = 0

      self.ctrlList:AddItem(lbl)
   end

   self.Peeps = {}

   for i =1, game.MaxPlayers() do
      self.Peeps[i] = vgui.Create( "DImage", self.ctrlList:GetCanvas() )
      self.Peeps[i]:SetSize( 16, 16 )
      --self.Peeps[i]:SetZPos( 1000 )
      self.Peeps[i]:SetVisible( false )
      self.Peeps[i]:SetImage( "icon16/emoticon_smile.png" )
      self.Peeps[i]:SetImageColor(Color(255,255,255, 100))
   end

   self:SetVisible(false)
end

function PANEL:PerformLayout()
   self:SetPos( 0, 0 )
   self:SetSize( 310, 60 )

   self:CenterHorizontal()

   self.ControlCanvas:StretchToParent( 0, 0, 0, 0 )
   self.ControlCanvas:SetZPos( 0 )

   self.ctrlList:StretchToParent( 2, 4, 2, 4 )
end

function PANEL:ResetPeeps()
   for i=1, game.MaxPlayers() do
      self.Peeps[i]:SetPos( math.random( 0, 600 ), -16 )
      self.Peeps[i]:SetVisible( false )
      self.Peeps[i].want = nil
   end
end

function PANEL:FindWantBar(want)
   for k, v in pairs( self.ctrlList:GetItems() ) do
      if v.want == want then return v end
   end
end

function PANEL:PeepThink( peep, ent )
   if not IsValid(ent) then
      peep:SetVisible( false )
      return
   end

   if peep.want == nil then
      peep:SetVisible( true )
      peep:SetPos( math.random( 0, 600 ), -16 )
      peep.CurPos = nil

      if ent == LocalPlayer() then
         peep:SetImage( "icon16/star.png" )
      end
   end

   peep.want = ent:GetNWString( "WantsVote", false )

   local bar = self:FindWantBar( peep.want )
   if IsValid(bar) then
      bar.numvotes = bar.numvotes + 1

      local vNewPos = Vector( (bar.x + bar:GetWide()) - 15 * bar.numvotes - 4, bar.y + ( bar:GetTall() * 0.5 - 8 ), 0 )

      if ( !peep.CurPos || peep.CurPos != vNewPos ) then
         peep:MoveTo( vNewPos.x, vNewPos.y, 0.2 )
         peep.CurPos = vNewPos
      end

      local a = 150 * math.max(0, vNewPos.x) / bar:GetWide()
      peep:SetImageColor(Color(255,255,255, a))
   end
end

function PANEL:Think()
   for k, v in pairs( self.ctrlList:GetItems() ) do
      v.numvotes = 0
   end

   for i=1, game.MaxPlayers() do
      self:PeepThink( self.Peeps[i], Entity(i) )
   end
end

local bgcolor = Color(0, 0, 10, 200)
function PANEL:Paint()
   draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), bgcolor)
end

function PANEL:Show()
   self:ResetPeeps()

   for _, pnl in pairs(self.ctrlList:GetItems()) do
      pnl:SetText(pnl.keytxt .. "  " .. LANG.GetTranslation(pnl.txt))
   end

   self:SetVisible(true)
end

function PANEL:Hide()
   self:SetVisible(false)
end

derma.DefineControl("ContinueVote", "", PANEL, "DPanel")
