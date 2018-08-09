//
// Attract-Mode Front-End
// Réglad sub V2 (Game station HD remixed)
//
//

class UserConfig {
      </ label="Mode", help="If select Expert mode, logo, wheel logo & background color will be accroding by layout.nut file.", options="Expert", order=1 /> mode="Expert";
      </ label="Play Video Sound", help="Play Video Sound", options="Yes,No", order=2 /> sound="Yes";       
      </ label="Display Time", help="Display current time", options="Yes,No", order=3 /> enable_time="No";      
      </ label="Display Game List Option", help="How to display game list", options="vert_wheel_right, Spin + ListBox, ListBox Only", order=4 /> listType="ListBox Only";
	  </ label="Display Logo Option", help="The artwork to logo", options="Wheel Only, Nothing", order=7 /> wheel_logo="Wheel Only";      
      </ label="CRT Effect", help="Enable CRT effect (requires shader support)", options="Yes,No", order=8 /> enable_crt="No";
      </ label="Flyer Aspect Ratio", help="Flyer preserve aspect ratio", options="Yes,No", order=9 /> ratio="No";
	  </ label="Display Move Strip", help="Display move strip. Remember to create a new artwork folder called [flyer2]", options="Yes,No", order=10 /> enable_strip="Yes";
      </ label="Display Spin Option", help="The artwork to spin", options="wheel, snap", order=11 /> orbit_art="wheel";
      </ label="Transition Time", help="Time in milliseconds for spin.", order=12 /> transition_ms="40";
	  </ label="Show flyer art", help="Show flyer art at the left of the screen", options="Yes,No", order=13 /> enable_gflyer="Yes";
	  </ label="Enable system logos", help="Select system logos", options="Yes,No", order=14 /> enable_slogos="Yes";
	  </ label="Show character art", help="Show character at the left of the screen", options="Yes,No", order=15 /> enable_gfanart="Yes";
 }  

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font="roboto";

fe.load_module( "fade" );
fe.load_module("animate");

local TRIGGER = Transition.EndNavigation;

//No Available Image /////////////////////////////////////////////////////////////////////////////////
 local no_available = fe.add_artwork("no_available_image.png", flx*0.6, fly*0.35, flw*0.12, flh*0.21 );
 no_available.alpha = 230;

// Fill an entire surface with our snap at a resolution of 1280x720 ///////////////////////////////////
 local surface = fe.add_surface( 854, 480 ); 
 local snap = surface.add_artwork("snap", 0, 0, 854, 480);
 snap.trigger = TRIGGER;
 snap.preserve_aspect_ratio = true;
 surface.set_pos( flx*0.013, fly*0.11, flw*0.645, flh*0.708 );
 if ( my_config["sound"] == "No" ){
     snap.video_flags = Vid.NoAudio;
}

if ( my_config["enable_crt"] == "Yes" )
  {
    local sh = fe.add_shader( Shader.VertexAndFragment, "crt.vert", "crt.frag" );
	sh.set_param( "rubyInputSize", 640, 480 );
    	sh.set_param( "rubyOutputSize", ScreenWidth, ScreenHeight );
    	sh.set_param( "rubyTextureSize", 640, 480 );
	sh.set_texture_param("rubyTexture"); 
	surface.shader = sh;
  }

// Background Art ///////////////////////////////////////////////////////////////////////////////////

local b_art = fe.add_image("background.png", 0, 0, flw, flh );
b_art.alpha=255;

// Flyer ///////////////////////////////////////////////////////////////////////////////////
if ( my_config["enable_gflyer"] == "Yes")  
{
local flyer = fe.add_image ( "../../menu-art/flyer/[Title]", flx*0.722, fly*0.18, flw*0.23, flh*0.54 );
flyer.trigger = Transition.EndNavigation;
flyer.alpha=255;
}

// slogos ///////////////////////////////////////////////////////////////////////////////////
if ( my_config["enable_slogos"] == "Yes")  
{
local slogos = fe.add_image ("../Regaladsystem/slogos/[Title]", flx*0.3, fly*0.3, flw*0.7, flh*0.7 );
slogos.trigger = Transition.EndNavigation;
slogos.alpha=255;
}

// Fanart //////////////////////////////////////////////////////////////////////////////////////////

if ( my_config["enable_gfanart"] == "Yes" )
{
local fanart = fe.add_image("../Regaladsystem/fanart/[Title]", flx*0.0, fly*0.5, flw*0.5, flh*0.5 );
fanart.trigger = Transition.EndNavigation;
}

// Wheel Settings /////////////////////////////////////////////////////////////////////////////////////
if ( my_config["listType"] == "ListBox Only" ){
 }

// Wheel Settings /////////////////////////////////////////////////////////////////////////////////////
if ( my_config["listType"] == "ListBox Only" ){
 }

else{
 {
local bottom = fe.add_image ("bottom.png",flx*0.72, fly*0.0, flw*0.244, flh*1.3);
fe.load_module( "conveyor" );
local wheel_x = [ flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.692, flx*0.722, flx*0.722, flx*0.722, flx*0.722, flx*0.722, ]; 
local wheel_y = [ -fly*0.17, -fly*0.055, fly*-0.05, fly*0.055, fly*0.165, fly*0.275, fly*0.386, fly*0.56, fly*0.67 fly*0.78, fly*0.885, fly*0.84, ];
local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.24, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
local wheel_a = [  150,  150,  150,  150,  150,  150, 255,  150,  150,  150,  150,  150, ];
local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.168,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
local wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
local num_arts = 8;

class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >= 10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
		m_obj.video_flags = Vid.NoAudio;
	}
};

 local wheel_entries = [];
 for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

 local remaining = num_arts - wheel_entries.len();


// we do it this way so that the last wheelentry created is the middle one showing the current ///////////////
// selection (putting it at the top of the draw order)
 for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

 local conveyor = Conveyor();
 conveyor.set_slots( wheel_entries );
 conveyor.transition_ms = 50;
 try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
 }
}

//Display current time /////////////////////////////////////////////////////////////////////////////////////////
if ( my_config["enable_time"] == "Yes" ){
  local dt = fe.add_text( "", flx*0.036, fly*0.886, flw*0.2, flh*0.095 );
  dt.align = Align.Left;
  dt.alpha = 200;

  local clock = fe.add_image ("clock.png",flx*0.02, fly*0.9, flw*0.048, flh*0.075);
  clock.alpha = 200;

function update_clock( ttime ){
  local now = date();
  dt.msg = format("%02d", now.hour) + ":" + format("%02d", now.min );
}
  fe.add_ticks_callback( this, "update_clock" );
}

//Game List Animation ///////////////////////////////////////////////////////////////////////////////////////////
 ::OBJECTS <- {
 tick = fe.add_image ("tick.png",flx*0.94, fly*0.42, flw*0.028, flh*0.047),
 marquee = fe.add_artwork("marquee", flx*-0.2, fly*0.67, flw*0.18, flh*0.1),
 gameListBG = fe.add_image ("default.png",flx, 0, flw*0.47, flh*1.01),
 gameListBox = fe.add_listbox( flx, fly*0.19, flw*0.39, flh*0.7 ),
 gameListTitle = fe.add_text("[Title]", flx, fly*0.055, flw*0.05, flh*0.1),
 gameListList1 = fe.add_text("[ListSize]",flx, fly*0.93, flw*0.26, flh*0.06),
 gameListList2 = fe.add_text("[ListEntry]",flx, fly*0.9, flw*0.26, flh*0.06),
 gameListList3 = fe.add_text("[ListEntry]/[ListSize]",flx*0.78, fly*0.9, flw*0.3, flh*0.06), 
 moveStrip = fe.add_artwork("flyer2", flx*-0.85, fly*0.8, flw*0.821, flh*0.163 ),
 wheelLogo = fe.add_artwork("wheel", flx*0.25, fly*0.058, flw*0.15, flh*0.12),
 logo = fe.add_image("logo.png", flx*0.0265, fly*0.03, flw*0.23, flh*0.13 ),
 
 }
 
// modules /////////////////////////////////////////////////////////////////////////////////////////////////////////

::OBJECTS["marquee"].trigger = TRIGGER;
::OBJECTS["moveStrip"].trigger = TRIGGER;

//Animation for Global & Expert Mode ///////////////////////////////////////////////////////////////////////////////

 local move_shrink1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.842, time = 1
 }
 local move_shrink2 = {
    when = When.ToNewSelection ,property = "x", start = flx end = flw, time = 100, delay= 4000
 } 
 local move_marquee1 = {
    when = Transition.ToNewSelection ,property = "x", start = flx*-0.3, end = 0, time = 900
 }
 local move_marquee2 = {    
    when = Transition.ToNewSelection ,property = "x", start = 0, end = flx*-0.3, time = 1100, delay = 4000
 }
 local move_strip1 = {    
    when = Transition.ToNewSelection ,property = "x", start = flx*-0.85 end = flx*0, time = 3000, delay = 4000
 }
 local move_strip2 = {    
    when = Transition.ToNewSelection ,property = "x", start = flx*-0.85 end = flx*-0.85, time = 1, delay = 1
 }
 local move_strip3 = {    
    when = Transition.ToNewList ,property = "x", start = flx*-0.85 end = flx*-0.85, time = 1, delay = 1
 }
 local move_gameListBG1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.66, time = 1
 }
 local move_gameListBG2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.55, end = flw, time = 100, delay= 4000
 } 
 local move_gameListBox1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.66, time = 1
 }
 local move_gameListBox2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.57, end = flw, time = 80, delay= 4000
 }
  local move_gameListTitle1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.72, time = 1
 }
 local move_gameListTitle2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.72, end = flw, time = 65, delay=4000
 }
 local move_gameListList1 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.719, time = 1
 }
 local move_gameListList2 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.719, end = flw, time = 400, delay= 4000
 }
 local move_gameListList3 = {
    when = Transition.ToNewSelection ,property = "x", start = flw, end = flx*0.689, time = 1
 }
 local move_gameListList4 = {
    when = When.ToNewSelection ,property = "x", start = flx*0.689, end = flw, time = 550, delay= 4000
 }
  local move_gameListList9 = {
    when = Transition.ToNewSelection ,property = "alpha", start = 200, end = 0, time = 4000
 }
 local move_gameListList10 = {
    when = Transition.ToNewList ,property = "alpha", start = 200, end = 0, time = 1
 }
 
//Animation for Simple Mode ///////////////////////////////////////////////////////////////////////////////////////////

 local move_gameListBG3 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.1, end = flx*-0.15, time = 800, tween = Tween.Bounce
 }
 local move_gameListBG4 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.1, end = flx*-0.15, time = 800, tween = Tween.Bounce
 }
 local move_gameListBox3 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.1, end = flx*0.0, time = 800, tween = Tween.Bounce
 }
 local move_gameListBox4 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.1, end = flx*0.0, time = 800, tween = Tween.Bounce
 }
 local move_gameListList5 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.7, end = flx*-0.3, time = 800, tween = Tween.Bounce 
 }
 local move_gameListList6 = {
    when = Transition.StartLayout ,property = "x", start = flw*0.7, end = flx*-0.3, time = 800, tween = Tween.Bounce
 }
 local move_gameListList7 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.7, end = flx*-0.2, time = 800, tween = Tween.Bounce 
 }
 local move_gameListList8 = {
    when = Transition.ToNewList ,property = "x", start = flw*0.7, end = flx*-0.2, time = 800, tween = Tween.Bounce
 }

//Animation ////////////////////////////////////////////////////////////////////////////////////////////////////////

if ( my_config["listType"] == "Spin + ListBox" ){
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList3 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList4 ) );
  OBJECTS.gameListList3.visible = false;
  OBJECTS.tick.visible = false; 
  }

else if ( my_config["listType"] == "Spin Only" ){
  animation.add( PropertyAnimation( OBJECTS.gameListList3, move_gameListList9 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList3, move_gameListList10 ) );
  OBJECTS.gameListList3.visible = true;
  OBJECTS.tick.visible = false; 
  }

else if ( my_config["listType"] == "ListBox Only" ){
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBG, move_gameListBG2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListTitle, move_gameListTitle1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListTitle, move_gameListTitle2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListBox, move_gameListBox2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList1 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList1, move_gameListList2 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList3 ) );
  animation.add( PropertyAnimation( OBJECTS.gameListList2, move_gameListList4 ) );
  OBJECTS.gameListList3.visible = false; 
  OBJECTS.tick.visible = false; 
  }

if ( my_config["wheel_logo"] == "Nothing" ){
 OBJECTS.logo.visible = false;
 OBJECTS.wheelLogo.visible = false;
}

else if ( my_config["wheel_logo"] == "Wheel Only" ){
 OBJECTS.logo.visible = false;
 OBJECTS.wheelLogo.visible = true;
 OBJECTS.wheelLogo.trigger = Transition.EndNavigation;
}

if ( my_config["enable_strip"] == "No" ){
 OBJECTS.moveStrip.visible = false;
}

 OBJECTS.tick.alpha = 230;
 OBJECTS.gameListBox.charsize = 25;
 OBJECTS.gameListBox.align = Align.Left;
 OBJECTS.gameListBox.rows= 13;
 OBJECTS.gameListBox.set_sel_rgb( 255, 255, 255 );
 OBJECTS.gameListBox.set_selbg_rgb( 0, 32, 255 );
 OBJECTS.gameListBox.set_rgb( 255, 255, 255 );
 OBJECTS.gameListList1.align = Align.Right;
 OBJECTS.gameListList1.alpha = 180;
 OBJECTS.gameListList2.set_rgb( 255, 255, 255 );
 OBJECTS.gameListList2.align = Align.Right;
 OBJECTS.gameListList2.alpha = 230;
 OBJECTS.gameListList3.alpha = 10;
