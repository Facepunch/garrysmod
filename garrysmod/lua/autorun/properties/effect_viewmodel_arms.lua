
if SERVER then
    AddCSLuaFile()

    util.AddNetworkString( "UpdateEffectCArms" )
end

-- All of the bones that a model needs to have for C Arm bonemerging to work.
local armBones = {
    "ValveBiped.Bip01_Spine4",
    "ValveBiped.Bip01_L_Clavicle",
    "ValveBiped.Bip01_L_UpperArm",
    "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Hand",
    "ValveBiped.Bip01_L_Finger0",
    "ValveBiped.Bip01_L_Finger01",
    "ValveBiped.Bip01_L_Finger02",
    "ValveBiped.Bip01_L_Finger1",
    "ValveBiped.Bip01_L_Finger11",
    "ValveBiped.Bip01_L_Finger12",
    "ValveBiped.Bip01_L_Finger2",
    "ValveBiped.Bip01_L_Finger21",
    "ValveBiped.Bip01_L_Finger22",
    "ValveBiped.Bip01_L_Finger3",
    "ValveBiped.Bip01_L_Finger31",
    "ValveBiped.Bip01_L_Finger32",
    "ValveBiped.Bip01_L_Finger4",
    "ValveBiped.Bip01_L_Finger41",
    "ValveBiped.Bip01_L_Finger42",
    "ValveBiped.Bip01_R_Clavicle",
    "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_R_Finger0",
    "ValveBiped.Bip01_R_Finger01",
    "ValveBiped.Bip01_R_Finger02",
    "ValveBiped.Bip01_R_Finger1",
    "ValveBiped.Bip01_R_Finger11",
    "ValveBiped.Bip01_R_Finger12",
    "ValveBiped.Bip01_R_Finger2",
    "ValveBiped.Bip01_R_Finger21",
    "ValveBiped.Bip01_R_Finger22",
    "ValveBiped.Bip01_R_Finger3",
    "ValveBiped.Bip01_R_Finger31",
    "ValveBiped.Bip01_R_Finger32",
    "ValveBiped.Bip01_R_Finger4",
    "ValveBiped.Bip01_R_Finger41",
    "ValveBiped.Bip01_R_Finger42"
}

-- All of the C Arm models that ship with Garry's Mod.
local armModels = {
    "models/weapons/c_arms_citizen.mdl",
    "models/weapons/c_arms_chell.mdl",
    "models/weapons/c_arms_combine.mdl",
    "models/weapons/c_arms_cstrike.mdl",
    "models/weapons/c_arms_dod.mdl",
    "models/weapons/c_arms_hev.mdl",
    "models/weapons/c_arms_refugee.mdl"
}

local function IsViewModelEffectWithArmBones( ent )

    if ( not IsValid( ent ) ) then return false end
    if ( ent:GetClass() ~= "prop_effect" ) then return false end

    local child = ent:GetChildren()[1]
    if ( not IsValid( child ) ) then return false end
    if ( child:GetClass() ~= "prop_dynamic" ) then return false end

    -- Don't try to set C Arms on the C Arms models themselves
    if ( table.HasValue( armModels, child:GetModel() ) ) then return false end

    -- Check if the effect has all the required bones for C Arms.
    for _, boneName in ipairs( armBones ) do
        if ( not child:LookupBone( boneName ) ) then return false end
    end

    return true

end

properties.Add( "change_c_arms", {
	MenuLabel = "#change_c_arms",
	MenuIcon = "icon16/picture_edit.png",
    Order = 401,

	Filter = function( _, ent, ply )
        if ( not IsValid( ent ) ) then return false end
        if ( not gamemode.Call( "CanProperty", ply, "change_c_arms", ent ) ) then return false end
        if ( not IsViewModelEffectWithArmBones( ent ) ) then return false end

        return true
	end,

	MenuOpen = function( self, option, ent, _ )

        local child = ent:GetChildren()[1]
        if ( not IsValid( child ) ) then return end

        local activeIndex = ent:GetNW2Int( "CArmsIndex", 0 )

        -- Add a submenu to our automatically created menu option
		local submenu = option:AddSubMenu()

        -- Add an option to remove the C Arms system
        local removeOption = submenu:AddOption( "None" )
        removeOption:SetRadio( true )
        removeOption:SetChecked( activeIndex == 0 )
        removeOption:SetIsCheckable( true )
        removeOption.OnChecked = function( _, isChecked )
            if ( isChecked ) then
                self:SetArmsModel( ent, 0 )
            end
        end

        -- Add an option for each C Arms model
        for modelIndex = 1, #armModels do
            local model = armModels[ modelIndex ]
            local menuOption = submenu:AddOption( model )
            menuOption:SetRadio( true )
            menuOption:SetChecked( modelIndex == activeIndex )
            menuOption:SetIsCheckable( true )
            menuOption.OnChecked = function( _, isChecked )
                if ( isChecked ) then
                    self:SetArmsModel( ent, modelIndex )
                end
            end
        end

	end,

	Action = function( _, _ )
        -- Do nothing when clicked.  This is just a submenu header.
	end,

    SetArmsModel = function( self, ent, index )

        self:MsgStart()
            net.WriteEntity( ent )
            net.WriteUInt( index, 8 )
        self:MsgEnd()

    end,

    Receive = function( self, _, ply )

        local ent = net.ReadEntity()
        local index = net.ReadUInt( 8 )

        if ( not IsValid( ent ) ) then return end
        if ( index < 0 or index > #armModels ) then return end
        if ( not properties.CanBeTargeted( ent, ply ) ) then return end
        if ( not self:Filter( ent, ply ) ) then return end

        local child = ent:GetChildren()[1]
        if not IsValid( child ) then return end

        -- Add the arm index as a networked variable so players not within the Entity's PVS can initialize it later.
        ent:SetNW2Int( "CArmsIndex", index )

        -- Inform all connected players that the C Arms model has been changed.
        net.Start( "UpdateEffectCArms" )
            net.WriteEntity( ent )
            net.WriteUInt( index, 8 )
        net.Broadcast()

    end
} )

if not CLIENT then return end

local function SetCArms( ent, index )
    if ( not IsValid( ent ) ) then return end
    if ( index < 0 or index > #armModels ) then return end

    local child = ent:GetChildren()[1]
    if ( not IsValid( child ) ) then return end

    -- An index of 0 means the C Arms system should be removed.
    if ( index == 0 ) then
        if ( IsValid( ent.CArms ) ) then
            ent.CArms:Remove()
            ent.CArms = nil
        end
        return
    end

    -- If the entity doesn't have a C Arms ClientsideModel, create one.
    if ( not IsValid( ent.CArms ) ) then
        ent.CArms = ClientsideModel( armModels[ index ] )
        ent.CArms:SetParent( child )
        ent.CArms:AddEffects( EF_BONEMERGE )
        ent.CArms:SetModel( armModels[ index ] )

        ent:CallOnRemove( "RemoveCArms", function()
            if ( not IsValid( ent.CArms ) ) then return end
            ent.CArms:Remove()
        end )

        ent.CArms:Spawn()
        return
    end

    -- If the entity already has a C Arms ClientsideModel set up, just change its model.
    ent.CArms:SetModel( armModels[ index ] )

end

net.Receive( "UpdateEffectCArms", function()

    local ent = net.ReadEntity()
    local index = net.ReadUInt( 8 )

    SetCArms( ent, index )

end )

-- When an Entity enters the player's PVS, update its C Arms if applicable.
hook.Add( "OnEntityCreated", "SyncCHands", function( ent )

    -- Wait a tick to ensure the Entity has initialized
    timer.Simple( 0, function()

        if ( not IsValid( ent ) ) then return false end
        if ( not IsViewModelEffectWithArmBones( ent ) ) then return false end

        local index = ent:GetNW2Int( "CArmsIndex", 0 )

        SetCArms( ent, index )

    end )

end )
