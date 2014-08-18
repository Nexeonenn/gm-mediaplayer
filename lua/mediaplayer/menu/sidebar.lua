include "common.lua"
include "sidebar_tabs.lua"
include "volume_control.lua"
include "playback.lua"
include "queue.lua"

local PANEL = {}

function PANEL:Init()

	self:SetPaintBackgroundEnabled( true )
	self:SetPaintBorderEnabled( false )

	self:SetSize( 385, 580 )

	self.Tabs = vgui.Create( "MP.SidebarTabs", self )
	self.Tabs:Dock( FILL )

	local curplaytab = vgui.Create( "MP.CurrentlyPlayingTab" )
	self.Tabs:AddSheet( "CURRENTLY PLAYING", curplaytab, nil, false, false )

	local panel = vgui.Create( "Panel" )
	self.Tabs:AddSheet( "RECENTLY VIEWED", panel, nil, false, false )

	self.VolumeControls = vgui.Create( "MP.VolumeControl", self )
	self.VolumeControls:Dock( BOTTOM )
	self.VolumeControls:SetHeight( 48 )

	self:InvalidateLayout( true )

end

function PANEL:Paint(w, h)

	surface.SetDrawColor( 0, 0, 0, 140 )
	surface.DrawRect( 0, 0, w, h )

end

function PANEL:PerformLayout()

	self:CenterVertical()
	self:AlignLeft( 10 )

	self.Tabs:SizeToContentWidth()

end

local MP_SIDEBAR = vgui.RegisterTable( PANEL, "EditablePanel" )


function MediaPlayer.ShowSidebar( mp )

	local sidebar = MediaPlayer._Sidebar

	if ValidPanel( sidebar ) then
		sidebar:Remove()
	end

	if not mp then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if not IsValid(ent) then return end

		mp = MediaPlayer.GetByObject( ent )
	end

	if not IsValid(mp) then return end

	sidebar = vgui.CreateFromTable( MP_SIDEBAR )
	sidebar:MakePopup()
	sidebar:ParentToHUD()

	sidebar:SetKeyboardInputEnabled( false )
	sidebar:SetMouseInputEnabled( true )

	MediaPlayer._Sidebar = sidebar

	hook.Run( MP.EVENTS.UI.MEDIA_PLAYER_CHANGED, mp )

end

function MediaPlayer.HideSidebar()

	local sidebar = MediaPlayer._Sidebar

	if ValidPanel( sidebar ) then
		sidebar:Remove()
		MediaPlayer._Sidebar = nil
	end

end

-- control.AddKeyPress( KEY_C, "MP.ShowSidebar", function() MediaPlayer.ShowSidebar() end )
-- control.AddKeyRelease( KEY_C, "MP.HideSidebar", function() MediaPlayer.HideSidebar() end )

control.AddKeyPress( KEY_C, "MP.ShowSidebarTest", function()
	-- Create test fixture
	local mp = MediaPlayer.Create( 'ui-test-player' )

	-- Create media object
	local mediaUrl = "https://www.youtube.com/watch?v=IMorTE0lFLc"
	local media = MediaPlayer.GetMediaForUrl( mediaUrl )

	-- Set metadata
	media._metadata = {
		title = "Test media",
		duration = 3600
	}

	media._OwnerName = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
	media._OwnerSteamID = "STEAM_0:1:15862026"
	media:StartTime( os.time() )

	mp:SetMedia( media )

	-- Display UI using fixture
	MediaPlayer.ShowSidebar( mp )
end )
