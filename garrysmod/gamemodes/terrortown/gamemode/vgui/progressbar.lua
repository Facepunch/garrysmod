-- Version of DProgressBar I can mess around with

local PANEL = {}

AccessorFunc( PANEL, "m_iMin",  "Min" )
AccessorFunc( PANEL, "m_iMax",  "Max" )
AccessorFunc( PANEL, "m_iValue",    "Value" )
AccessorFunc( PANEL, "m_Color",     "Color" )

function PANEL:Init()
   self.Label = vgui.Create( "DLabel", self )
   self.Label:SetFont( "DefaultSmall" )
   self.Label:SetColor( Color( 0, 0, 0 ) )
   
   self:SetMin( 0 )
   self:SetMax( 1000 )
   self:SetValue( 253 )
   self:SetColor( Color( 50, 205, 255, 255 ) )
end

function PANEL:LabelAsPercentage()
   self.m_bLabelAsPercentage = true
   self:UpdateText()
end

function PANEL:SetMin( i )
   self.m_iMin = i
   self:UpdateText()
end

function PANEL:SetMax( i )
   self.m_iMax = i
   self:UpdateText()
end

function PANEL:SetValue( i )
   self.m_iValue = i
   self:UpdateText()
end

function PANEL:UpdateText()
   if ( !self.m_iMax ) then return end
   if ( !self.m_iMin ) then return end
   if ( !self.m_iValue ) then return end
   
   local fDelta = 0;
   
   if ( self.m_iMax-self.m_iMin != 0 ) then
      fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
   end
   
   if ( self.m_bLabelAsPercentage ) then
      self.Label:SetText( Format( "%.2f%%", fDelta * 100 ) )
      return
   end
   
   if ( self.m_iMin == 0 ) then
      
      self.Label:SetText( Format( "%i / %i", self.m_iValue, self.m_iMax ) )
      
   else
   end
end

function PANEL:PerformLayout()
   self.Label:SizeToContents()
   self.Label:AlignRight( 5 )
   self.Label:CenterVertical()
end

function PANEL:Paint()

   local fDelta = 0;
   
   if ( self.m_iMax-self.m_iMin != 0 ) then
      fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
   end
   
   local Width = self:GetWide()

   surface.SetDrawColor( 0, 0, 0, 170 )
   surface.DrawRect( 0, 0, Width, self:GetTall() )
   
   surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a * 0.5 )
   surface.DrawRect( 2, 2, Width - 4, self:GetTall() - 4 )
   surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
   surface.DrawRect( 2, 2, Width * fDelta - 4, self:GetTall() - 4 )

end

vgui.Register( "TTTProgressBar", PANEL, "DPanel" )
